import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart' as analyzer;
import 'package:code_builder/code_builder.dart';
import 'package:mirage/src/code_builders/classes/class_code_builder.dart';
import 'package:mirage/src/code_builders/fake_type_code_builder.dart';
import 'package:mirage/src/code_builders/method_code_builder.dart';
import 'package:mirage/src/import_finder.dart';
import 'package:mirage/src/models/errors.dart';
import 'package:mirage/src/models/fake_type.dart';
import 'package:mirage/src/seed_finder.dart';
import 'package:mirage/src/type_referencer.dart';
import 'package:riverpod/riverpod.dart';
import 'package:source_gen/source_gen.dart';

class SimpleNotifierDelegate
    with ClassCodeBuilderUtils
    implements ClassCodeBuilderDelegate {
  final FakeTypeCodeBuilder _fakeTypeCodeBuilder;
  final ImportFinder _importFinder;
  final MethodCodeBuilder _methodGenerator;
  final SeedFinder _seedFinder;
  final TypeReferencer _typeReferencer;

  const SimpleNotifierDelegate(
    this._fakeTypeCodeBuilder,
    this._importFinder,
    this._methodGenerator,
    this._seedFinder,
    this._typeReferencer,
  );

  @override
  List<Class> generate(analyzer.DartType type) {
    final classElement = getClassForType(type);
    final fakeTypes = _generateFakeTypes(classElement);

    final notifier = _getClassReference(classElement, fakeTypes);
    final fakedOutput = _generateFakeClasses(fakeTypes) ?? [];
    return fakedOutput + [notifier];
  }

  Class _getClassReference(ClassElement element, Set<FakeType> fakeTypes) {
    return Class((builder) {
      final typeName = getTypeName(element.thisType);

      final superType = element.supertype;
      if (superType == null) {
        throw ProviderSupertypeNotFound(element.thisType);
      }
      // Class signature
      builder
        ..name = "Mock$typeName"
        ..docs.add("// Mirage generated mock of class [$typeName].")
        ..extend = _typeReferencer.obtainReferenceForType(superType)
        ..mixins.add(refer("Mock", "package:mockito/mockito.dart"))
        ..implements.add(refer(typeName, _importFinder.getImportUrl(element)));

      // Add seeded constructor
      final seedType = _seedFinder.getNonVoidSeedType(element);
      if (seedType != null) {
        builder.fields.add(
          Field(
            (field) => field
              ..name = "seedBuilder"
              ..type = (FunctionTypeBuilder()
                    ..update(
                      (function) => function
                        ..returnType =
                            _typeReferencer.obtainReferenceForType(seedType),
                    ))
                  .build(),
          ),
        );
        builder.constructors.add(Constructor((constructor) => constructor
          ..requiredParameters.add(Parameter(
            (param) => param
              ..toThis = true
              ..name = "seedBuilder",
          ))));
      }

      // Add stubbed method overrides.
      builder.methods.addAll(
        _methodGenerator.generateMethods(
          element,
          seedValueProvided: seedType != null,
          generateKeepAlive: _isAutoDisposedNotifier(element.thisType),
        ),
      );
    });
  }

  bool _isAutoDisposedNotifier(analyzer.DartType type) {
    const typeChecker = TypeChecker.any(
      [
        TypeChecker.fromRuntime(AutoDisposeNotifier),
        TypeChecker.fromRuntime(AutoDisposeAsyncNotifier),
        TypeChecker.fromRuntime(AutoDisposeStreamNotifier),
      ],
    );
    return typeChecker.isSuperTypeOf(type);
  }

  Set<FakeType> _generateFakeTypes(ClassElement classElement) {
    final publicMethods = classElement.methods.where((method) => method.isPublic);
    final returnTypes = publicMethods.map((method) => method.returnType).toSet();
    return _fakeTypeCodeBuilder.generateFakeTypes(returnTypes);
  }

  List<Class>? _generateFakeClasses(Set<FakeType> fakeTypes) {
    final fakes = fakeTypes.where((fakeType) => fakeType.fakeTypeName != null);
    return fakes.isNotEmpty
        ? fakes
            .map((type) => _fakeTypeCodeBuilder.buildFakeClass(type))
            .whereType<Class>()
            .toList()
        : null;
  }
}
