import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/type.dart';

class FakeType {
  final Element2? element;
  final DartType originalType;
  final String? fakeTypeName;
  final List<FakeType>? parameterTypes;

  const FakeType(
    this.element,
    this.originalType,
    this.fakeTypeName,
    this.parameterTypes,
  );

  String get interfaceName {
    final localParameterTypes = parameterTypes;
    String parameters = "";
    if (localParameterTypes != null && localParameterTypes.isNotEmpty) {
      parameters += "<";
      parameters += localParameterTypes
          .map((parameter) => parameter.interfaceName)
          .join(", ");
      parameters += ">";
    }
    return "${originalType.element3?.displayName}$parameters";
  }

  @override
  String toString() => "FakeType(element: $element, parameterTypes: $parameterTypes, fakeTypeName: $fakeTypeName, originalType: $originalType";
}