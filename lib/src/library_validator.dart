import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:mirage/mirage.dart';
import 'package:mirage/src/models/errors.dart';
import 'package:riverpod/riverpod.dart';
import 'package:source_gen/source_gen.dart';

class LibraryValidator {
  static const _annotationTypeChecker = TypeChecker.fromRuntime(GenerateMirage);

  final LibraryElement library;

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
      final classElement = type.element;
      if (classElement is! ClassElement) {
        throw InvalidTypeMockedError(type);
      }
      final ref = classElement.lookUpInheritedConcreteGetter("ref", library);
      if (ref == null) {
        throw InvalidTypeMockedError(type);
      }
      const refTypeChecker = TypeChecker.fromRuntime(Ref);
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
          (element) => element?.element.id == library.entryPoint?.id,
          orElse: () => null,
        );
  }
}
