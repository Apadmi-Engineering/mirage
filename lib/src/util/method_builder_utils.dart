import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';

extension MethodBuilderUtils on MethodBuilder {
  void copyParameters({
    required MethodElement2 method,
    required Reference Function(DartType type) obtainReferenceForType,
  }) =>
      this
        ..requiredParameters.addAll(
          method.formalParameters.where((param) => param.isRequired).map(
            (parameter) {
              final parameterName = parameter.name3;
              if (parameterName == null) {
                return null;
              }
              return Parameter(
                (builder) => builder
                  ..name = parameterName
                  ..named = parameter.isNamed
                  ..type = obtainReferenceForType(parameter.type),
              );
            },
          ).nonNulls,
        )
        ..optionalParameters.addAll(
          method.formalParameters.where((param) => param.isOptional).map(
            (parameter) {
              final parameterName = parameter.name3;
              if (parameterName == null) {
                return null;
              }
              return Parameter(
                (builder) => builder
                  ..name = parameterName
                  ..named = parameter.isNamed
                  ..type = obtainReferenceForType(parameter.type),
              );
            },
          ).nonNulls,
        );
}
