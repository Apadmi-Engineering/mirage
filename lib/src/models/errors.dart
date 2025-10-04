import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/type.dart';

class InvalidTypeMockedError extends Error {
  DartType invalidType;

  InvalidTypeMockedError(this.invalidType);

  @override
  String toString() => "Cannot mock $invalidType, must be a Notifier";
}

class LibraryNotFoundError extends Error {
  DartType type;

  LibraryNotFoundError(this.type);

  @override
  String toString() => "Library not found for ${type.getDisplayString()}";
}

class ElementNotFoundError extends Error {
  DartType type;

  ElementNotFoundError(this.type);

  @override
  String toString() =>
      "Unable to extract element for type, ${type.getDisplayString()}";
}

class TypeNameNotFoundError extends Error {
  Element2 element;
  final DartType type;

  TypeNameNotFoundError(
    this.element,
    this.type,
  );

  @override
  String toString() =>
      "Element, ${element.displayString2()} for type ${type.getDisplayString()}, has no name";
}

class ClassNotFound extends Error {
  final DartType type;

  ClassNotFound(this.type);

  @override
  String toString() =>
      "Unable to find class for type, ${type.getDisplayString()}";
}

class ProviderSupertypeNotFound extends Error {
  final DartType type;

  ProviderSupertypeNotFound(this.type);

  @override
  String toString() =>
      "Unable to find super-type of notifier, ${type.getDisplayString()}, "
      "this is needed to figure out what base Notifier should be extended";
}

class AnnotationNotFoundException implements Exception {}