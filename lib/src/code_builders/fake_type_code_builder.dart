import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:mirage/src/import_finder.dart';
import 'package:mirage/src/models/fake_type.dart';
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
      null => FakeType(element, type, null, []),
      InterfaceElement(library: LibraryElement(isDartCore: true)) => FakeType(
          element,
          type,
          null,
          _getTypeParameters(type, recursionDepth + 1),
        ),
      InterfaceElement(library: LibraryElement(isDartAsync: true)) => FakeType(
          element,
          type,
          null,
          _getTypeParameters(type, recursionDepth + 1),
        ),
      EnumElement() => FakeType(element, type, null, []),
      ClassElement(isFinal: true) => FakeType(
          element,
          type,
          null,
          _getTypeParameters(type, recursionDepth + 1),
        ),
      ClassElement(isSealed: true) => FakeType(
          element,
          type,
          null,
          _getTypeParameters(type, recursionDepth + 1),
        ),
      InterfaceElement(:final name, isPublic: true) => FakeType(
          element,
          type,
          "_Fake$name",
          _getTypeParameters(type, recursionDepth + 1),
        ),
      _ => FakeType(
          element,
          type,
          null,
          _getTypeParameters(type, recursionDepth + 1),
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

  Code? getStubValue(
    FakeType fakeType,
    String methodName,
    String positionalArgs,
  ) {
    final element = fakeType.element;
    if (element == null) {
      return null;
    } else if (element case InterfaceElement(isFutureOrStream: true)) {
      return getStubValue(
          fakeType.parameterTypes!.first, methodName, positionalArgs);
    } else {
      return Code.scope((allocate) {
        final dummyInvocation =
            allocate(refer("dummyValue", "package:mockito/src/dummies.dart"));
        final typeParam = _allocateType(fakeType, allocate);
        final positionalParams =
            "this, Invocation.method(#$methodName, [$positionalArgs])";
        return "$dummyInvocation<$typeParam>($positionalParams)";
      });
    }
  }

  String _allocateType(FakeType type, String Function(Reference) allocate) {
    final parameterTypes = type.parameterTypes;
    final topLevelTypeCode = allocate(refer(
      type.originalType.element!.name!,
      _importFinder.getImportUrl(type.originalType.element!.library),
    ));
    if (parameterTypes == null || parameterTypes.isEmpty) {
      return topLevelTypeCode;
    }
    final parameterTypeCode = parameterTypes.map((type) => _allocateType(type, allocate)).join(", ");
    return "$topLevelTypeCode<$parameterTypeCode>";
  }
}

extension on InterfaceElement {
  bool get isFutureOrStream =>
      thisType.isDartAsyncStream ||
      thisType.isDartAsyncFutureOr ||
      thisType.isDartAsyncFuture;
}
