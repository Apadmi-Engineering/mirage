import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';

extension MethodBuilderUtils on MethodBuilder {
  void copyParameters({
    required MethodElement method,
    required Reference Function(DartType type) obtainReferenceForType,
  }) =>
      this
        ..requiredParameters.addAll(
          method.parameters.where((param) => param.isRequired).map(
                (parameter) => Parameter(
                  (builder) => builder
                    ..name = parameter.name
                    ..named = parameter.isNamed
                    ..type = obtainReferenceForType(parameter.type),
                ),
              ),
        )
        ..optionalParameters.addAll(
          method.parameters.where((param) => param.isOptional).map(
                (parameter) => Parameter(
                  (builder) => builder
                    ..name = parameter.name
                    ..named = parameter.isNamed
                    ..type = obtainReferenceForType(parameter.type),
                ),
              ),
        );
}
