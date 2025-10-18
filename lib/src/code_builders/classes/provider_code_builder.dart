import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:mirage/src/code_builders/classes/class_code_builder.dart';
import 'package:mirage/src/models/errors.dart';

class ProviderCodeBuilder with ClassCodeBuilderUtils {
  final ClassCodeBuilderDelegate notifierDelegate;
  final ClassCodeBuilderDelegate familyDelegate;

  const ProviderCodeBuilder(this.notifierDelegate, this.familyDelegate,);

  List<Class> generate(DartType type) {
    final classElement = getClassForType(type);
    final buildMethod = classElement.getMethod2("build");
    if(buildMethod == null) {
      throw InvalidTypeMockedError(type);
    }
    final isFamily = buildMethod.formalParameters.isNotEmpty;
    if(isFamily) {
      return familyDelegate.generate(type);
    } else {
      return notifierDelegate.generate(type);
    }
  }
}