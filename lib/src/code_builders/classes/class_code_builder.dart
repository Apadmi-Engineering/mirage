import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:mirage/src/models/errors.dart';
import 'package:source_gen/source_gen.dart';

abstract class ClassCodeBuilderDelegate {
  List<Class> generate(DartType type);
}

mixin ClassCodeBuilderUtils {
  Element getElement(DartType type) {
    final element = type.element;
    if (element == null) {
      throw ElementNotFoundError(type);
    }
    return element;
  }

  String getTypeName(DartType type) {
    final element = getElement(type);
    final typeName = element.name;
    if (typeName == null) {
      throw TypeNameNotFoundError(element, type);
    }
    return typeName;
  }

  LibraryElement getLibraryForType(DartType type) {
    final element = getElement(type);
    final library = element.library;
    if (library == null) {
      throw LibraryNotFoundError(type);
    }
    return library;
  }

  ClassElement getClassForType(DartType type) {
    final library = getLibraryForType(type);
    final classElement =
        LibraryReader(library).element.getClass(getTypeName(type));
    if (classElement == null) {
      throw ClassNotFound(type);
    }
    return classElement;
  }
}
