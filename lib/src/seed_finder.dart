import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:mirage/src/models/errors.dart';

class SeedFinder {
  DartType? getNonVoidSeedType(ClassElement clazz) {
    final buildMethod = clazz.methods.firstWhere(
      (method) => method.name == "build",
      orElse: () => throw InvalidTypeMockedError(clazz.thisType),
    );
    final returnsVoid = switch (buildMethod.returnType) {
      VoidType() => true,
      ParameterizedType(isDartAsyncFuture: true, typeArguments: [VoidType()]) =>
        true,
      ParameterizedType(
        isDartAsyncFutureOr: true,
        typeArguments: [VoidType()]
      ) =>
        true,
      ParameterizedType(isDartAsyncStream: true, typeArguments: [VoidType()]) =>
        true,
      _ => false,
    };
    if (returnsVoid) {
      return null;
    }
    return buildMethod.returnType;
  }
}
