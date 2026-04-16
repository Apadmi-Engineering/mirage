import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart' hide RecordType;
import 'package:flumepod/src/import_finder.dart';
import 'package:flumepod/src/models/fake_type.dart';
import 'package:source_gen/source_gen.dart';

class FakeTypeCodeBuilder {
  final LibraryReader _libraryReader;
  final ImportFinder _importFinder;

  const FakeTypeCodeBuilder(this._libraryReader, this._importFinder);

  Class? buildFakeClass(FakeType fakeType) {
    final originalElement = fakeType.originalType.element;
    if (originalElement == null) {
      return null;
    }
    final originalImport = _libraryReader.pathToElement(originalElement);
    final originalName = originalElement.name;
    if (originalName == null) {
      return null;
    }
    if (fakeType.fakeTypeName == null) {
      return null;
    }
    return Class(
      (classBuilder) => classBuilder
        ..name = fakeType.fakeTypeName
        ..extend = refer("SmartFake", "package:mockito/mockito.dart")
        ..implements.add(refer(originalName, originalImport.toString()))
        ..constructors.add(
          Constructor(
            (constructorBuilder) => constructorBuilder
              ..requiredParameters.add(
                Parameter(
                  (parameterBuilder) => parameterBuilder
                    ..name = "parent"
                    ..type = refer("Object")
                    ..toSuper = true,
                ),
              )
              ..requiredParameters.add(
                Parameter(
                  (parameterBuilder) => parameterBuilder
                    ..name = "parentInvocation"
                    ..type = refer("Invocation")
                    ..toSuper = true,
                ),
              ),
          ),
        ),
    );
  }

  Set<FakeType> generateFakeTypes(Set<DartType> types) =>
      types.map((type) => _generateFakeType(type)).toSet();

  FakeType _generateFakeType(DartType type, [int recursionDepth = 0]) {
    if (recursionDepth > 5) {
      throw StateError("Can't mock recursive types! Offending type "
          "${type.getDisplayString()}");
    }
    final element = type.element;
    return switch (element) {
      _ when type is RecordType =>
          RecordFakeType(element, type, null,
              namedFields: _getNamedFields(type, recursionDepth + 1),
              positionalFields: _getPositionalFields(type, recursionDepth + 1)),
      null => FakeType(element, type, null),
      InterfaceElement(library: LibraryElement(isDartCore: true)) =>
          FakeType(
            element,
            type,
            null,
            parameterTypes: _getTypeParameters(type, recursionDepth + 1),
          ),
      InterfaceElement(library: LibraryElement(isDartAsync: true)) =>
          FakeType(
            element,
            type,
            null,
            parameterTypes: _getTypeParameters(type, recursionDepth + 1),
          ),
      EnumElement() => FakeType(element, type, null),
      ClassElement(isFinal: true) =>
          FakeType(
            element,
            type,
            null,
            parameterTypes: _getTypeParameters(type, recursionDepth + 1),
          ),
      ClassElement(isSealed: true) =>
          FakeType(
            element,
            type,
            null,
            parameterTypes: _getTypeParameters(type, recursionDepth + 1),
          ),
      InterfaceElement(:final name, isPublic: true) =>
          FakeType(
            element,
            type,
            "_Fake$name",
            parameterTypes: _getTypeParameters(type, recursionDepth + 1),
          ),
      _ =>
          FakeType(
            element,
            type,
            null,
            parameterTypes: _getTypeParameters(type, recursionDepth + 1),
          ),
    };
  }

  List<FakeType>? _getTypeParameters(DartType type, [int recursionDepth = 0]) {
    final localType = type;
    if (localType is! ParameterizedType) {
      return null;
    }
    return localType.typeArguments
        .map(
          (typeParameter) => _generateFakeType(typeParameter, recursionDepth),
        )
        .toList();
  }

  List<FakeType>? _getPositionalFields(DartType type,
      [int recursionDepth = 0]) {
    final localType = type;
    if (localType is! RecordType) {
      return null;
    }
    return localType.positionalFields.map((positionalField) =>
        _generateFakeType(positionalField.type, recursionDepth)).toList();
  }

  Map<String, FakeType>? _getNamedFields(DartType type,
      [int recursionDepth = 0]) {
    final localType = type;
    if (localType is! RecordType) {
      return null;
    }
    return Map.fromEntries(localType.namedFields.map((namedField) =>
        MapEntry(namedField.name,
          _generateFakeType(namedField.type, recursionDepth),),),);
  }

  Code? getMethodStubValue(
    FakeType fakeType,
    String methodName,
    String positionalArgs,
  ) {
    final element = fakeType.element;
    if (element == null && fakeType is! RecordFakeType) {
      return null;
    } else if (element case InterfaceElement(isFutureOrStream: true)) {
      return getMethodStubValue(
          fakeType.parameterTypes!.first, methodName, positionalArgs);
    } else {
      return Code.scope((allocate) {
        final dummyInvocation =
            allocate(refer("dummyValue", "package:mockito/src/dummies.dart"));
        final typeParam = fakeType.allocateType(allocate, _importFinder);
        final positionalParams =
            "this, Invocation.method(#$methodName, [$positionalArgs])";
        return "$dummyInvocation<$typeParam>($positionalParams)";
      });
    }
  }

  Code? getGetterStubValue(
    FakeType fakeType,
    String methodName,
  ) {
    final element = fakeType.element;
    if (element == null && fakeType is! RecordFakeType) {
      return null;
    } else {
      return Code.scope((allocate) {
        final dummyInvocation =
            allocate(refer("dummyValue", "package:mockito/src/dummies.dart"));
        final typeParam = fakeType.allocateType(allocate, _importFinder);
        final positionalParams =
            "this, Invocation.getter(#$methodName)";
        return "$dummyInvocation<$typeParam>($positionalParams)";
      });
    }
  }
}

extension on InterfaceElement {
  bool get isFutureOrStream =>
      thisType.isDartAsyncStream ||
      thisType.isDartAsyncFutureOr ||
      thisType.isDartAsyncFuture;
}
