import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:mirage/mirage.dart';
import 'package:mirage/src/models/errors.dart';
import 'package:riverpod/riverpod.dart';
import 'package:source_gen/source_gen.dart';

class LibraryValidator {
  static const _annotationTypeChecker = TypeChecker.typeNamed(GenerateMirage, inPackage: "mirage");

  final LibraryElement2 library;

  const LibraryValidator(this.library);

  Set<DartType> validate() {
    final annotatedEntrypoint = _findAnnotatedEntrypoint();
    if (annotatedEntrypoint == null) {
      throw AnnotationNotFoundException();
    }
    return _validateMockedTypes(annotatedEntrypoint);
  }

  Set<DartType> _validateMockedTypes(AnnotatedElement element) {
    final typesReader = element.annotation.read("providerTypesToMock");
    final types = typesReader.setValue;
    final dartTypes = types.map((type) => type.toTypeValue()).toSet();
    for (final type in dartTypes) {
      if (type == null) {
        throw Exception("Cannot parse type $type");
      }
      final classElement = type.element3;
      if (classElement is! ClassElement2) {
        throw InvalidTypeMockedError(type);
      }
      final ref = classElement.lookUpGetter2(name: "ref", library: library);
      if (ref == null) {
        throw InvalidTypeMockedError(type);
      }
      const refTypeChecker = TypeChecker.typeNamed(Ref, inPackage: "riverpod");
      if (!refTypeChecker.isAssignableFromType(ref.returnType)) {
        throw InvalidTypeMockedError(type);
      }
    }
    return dartTypes.whereType<DartType>().toSet();
  }

  AnnotatedElement? _findAnnotatedEntrypoint() {
    final annotatedElements =
        LibraryReader(library).annotatedWith(_annotationTypeChecker);
    if (annotatedElements.isEmpty) {
      return null;
    }
    return annotatedElements.cast<AnnotatedElement?>().firstWhere(
          (element) => element?.element.id == library.entryPoint2?.id,
          orElse: () => null,
        );
  }
}
