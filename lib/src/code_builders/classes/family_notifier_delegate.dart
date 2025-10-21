import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/type.dart' as analyzer;
import 'package:code_builder/code_builder.dart';
import 'package:mirage/src/code_builders/class_member_copier.dart';
import 'package:mirage/src/code_builders/classes/class_code_builder.dart';
import 'package:mirage/src/code_builders/fake_type_code_builder.dart';
import 'package:mirage/src/code_builders/method_code_builder.dart';
import 'package:mirage/src/import_finder.dart';
import 'package:mirage/src/models/errors.dart';
import 'package:mirage/src/models/fake_type.dart';
import 'package:mirage/src/seed_finder.dart';
import 'package:mirage/src/type_referencer.dart';

class FamilyNotifierDelegate
    with ClassCodeBuilderUtils
    implements ClassCodeBuilderDelegate {
  final FakeTypeCodeBuilder _fakeTypeCodeBuilder;
  final ImportFinder _importFinder;
  final MethodCodeBuilder _methodGenerator;
  final SeedFinder _seedFinder;
  final TypeReferencer _typeReferencer;

  const FamilyNotifierDelegate(
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

    final notifier = _getNotifierClass(classElement, fakeTypes);
    final fakedClasses = _generateFakeClasses(fakeTypes) ?? [];
    return fakedClasses + [notifier];
  }

  Class _getNotifierClass(ClassElement2 element, Set<FakeType> fakeTypes) {
    return Class((classBuilder) {
      final typeName = getTypeName(element.thisType);
      final superType = element.supertype?.element3.supertype;
      if (superType == null) {
        throw ProviderSupertypeNotFound(element.thisType);
      }
      // Class signature
      classBuilder
        ..name = "Mock$typeName"
        ..docs.add("// Super-type = ${element.supertype?.element3.name3}")
        ..docs.add("// Mirage generated mock of class [$typeName].")
        ..extend = _typeReferencer.obtainReferenceForType(superType)
        ..mixins.add(refer("Mock", "package:mockito/mockito.dart"))
        ..implements.add(refer(typeName, _importFinder.getImportUrl(element)));

      for (final GetterElement getter in element.supertype?.getters ?? []) {
        final fieldCopier = FieldCopier();
        final copiedGetter = fieldCopier.copyGetter(getter);
        if(copiedGetter != null) {
          classBuilder.methods.add(copiedGetter);
        }
      }

      for (final FieldElement2 field in element.supertype?.element3.fields2 ?? []) {
        final fieldCopier = FieldCopier();
        final copiedField = fieldCopier.copyField(field);
        if(copiedField != null) {
          classBuilder.fields.add(copiedField);
        }
      }

      // Add seeded constructor
      final seedType = _seedFinder.getNonVoidSeedType(element);
      if (seedType != null) {
        classBuilder.fields.add(
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
        classBuilder.constructors.add(Constructor((constructor) => constructor
          ..requiredParameters.add(Parameter(
            (param) => param
              ..toThis = true
              ..name = "seedBuilder",
          ))));
      }
      // Add stubbed method overrides.
      classBuilder.methods.addAll(
        _methodGenerator.generateMethods(
          element,
          seedValueProvided: seedType != null,
          // TODO: Figure out how to detect auto-dispose notifiers
          generateKeepAlive: true,
        ),
      );
    });
  }

  Set<FakeType> _generateFakeTypes(ClassElement2 classElement) {
    final publicMethods = classElement.methods2.where((method) => method.isPublic);
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
