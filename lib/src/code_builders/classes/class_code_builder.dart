import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:mirage/src/models/errors.dart';
import 'package:source_gen/source_gen.dart';

abstract class ClassCodeBuilderDelegate {
  List<Class> generate(DartType type);
}

mixin ClassCodeBuilderUtils {
  Element2 getElement(DartType type) {
    final element = type.element3;
    if (element == null) {
      throw ElementNotFoundError(type);
    }
    return element;
  }

  String getTypeName(DartType type) {
    final element = getElement(type);
    final typeName = element.name3;
    if (typeName == null) {
      throw TypeNameNotFoundError(element, type);
    }
    return typeName;
  }

  LibraryElement2 getLibraryForType(DartType type) {
    final element = getElement(type);
    final library = element.library2;
    if (library == null) {
      throw LibraryNotFoundError(type);
    }
    return library;
  }

  ClassElement2 getClassForType(DartType type) {
    final library = getLibraryForType(type);
    final classElement =
        LibraryReader(library).element.getClass2(getTypeName(type));
    if (classElement == null) {
      throw ClassNotFound(type);
    }
    return classElement;
  }
}
