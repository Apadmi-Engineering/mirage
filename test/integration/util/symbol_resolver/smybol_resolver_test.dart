import 'package:analyzer/dart/analysis/results.dart';
import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:code_builder/code_builder.dart';
import 'package:flumepod/src/util/symbol_resolver.dart';
import 'package:test/test.dart';

void main() {
  group("Symbol resolver unit tests", () {
    late SymbolResolver sut;

    setUp(() {
      sut = SymbolResolver();
    });

    test("accept - collects named types within generics", () async {
      /// This is a much simpler example than [SymbolResolver] would typically
      /// encounter but the point of this test is that a reference is collected
      /// to the [Model] class within [List].
      await resolveSources({
        "package|provider.g.dart": r"""
        abstract class _$DummySource extends $AsyncNotifier<List<Model>> {
          late final _$args = ref.$arg as int;
          int get param => _$args;
        
          FutureOr<List<Model>> build(
            int param,
          );
          @$mustCallSuper
          @override
          void runBuild() {
            final created = build(
              _$args,
            );
            final ref = this.ref as List<Model>;
            final element = ref.element as Future<List<Model>>;
            element.handleValue(ref, created);
          }
        }
        
        class Model {
          final int value;
        
          const Model({required this.value});
        }
      """
      }, (resolver) async {
        // Setup
        final libraryElement = await resolver.libraryFor(AssetId("package", "provider.g.dart"));
        final classElement = libraryElement.classes.firstWhere((it) => it.name == r"_$DummySource");
        final methodElement = classElement.methods.firstWhere((it) => it.name == "runBuild");
        final resolvedLibrary = await libraryElement.session.getResolvedLibraryByElement(libraryElement);
        if(resolvedLibrary is! ResolvedLibraryResult) {
          fail("Failed to resolve library");
        }
        final runBuildDeclaration = resolvedLibrary.getFragmentDeclaration(methodElement.firstFragment)?.node;
        if(runBuildDeclaration == null) {
          fail("Failed to get runBuild() method declaration");
        }

        // Run test
        runBuildDeclaration.accept(sut);

        // Verify
        final actualReferences = sut.consumeReferences();
        final expectedReferences = {
          Reference("Model", "asset:package/provider.g.dart")
        };
        expect(actualReferences, unorderedEquals(expectedReferences));
      });
    });
  });
}