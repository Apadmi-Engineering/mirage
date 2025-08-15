import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:mirage/src/code_builders/fake_type_code_builder.dart';
import 'package:mirage/src/models/fake_type.dart';
import 'package:mirage/src/type_referencer.dart';
import 'package:mirage/src/util/block_builder_utils.dart';
import 'package:mirage/src/util/method_builder_utils.dart';

class MethodCodeBuilder {
  static const _keepAliveInsert =
      """// keepAlive() used so mock instance with stubbed/real calls isn't disposed.
      ref.keepAlive();""";

  final FakeTypeCodeBuilder _fakeTypeGenerator;
  final TypeReferencer _typeReferencer;

  const MethodCodeBuilder(
    this._fakeTypeGenerator,
    this._typeReferencer,
  );

  List<Method> generateMethods(
    ClassElement classElement, {
    bool seedValueProvided = true,
    bool generateKeepAlive = false,
  }) {
    final methodElements = classElement.methods;
    final returnTypes =
        methodElements.map((method) => method.returnType).toSet();
    final fakedTypes = _fakeTypeGenerator.generateFakeTypes(returnTypes);
    return methodElements
        .map((methodElement) => switch (methodElement.name) {
              "build" => generateBuildMethod(
                  methodElement, seedValueProvided, generateKeepAlive),
              _ => generateMethod(methodElement, fakedTypes),
            })
        .whereType<Method>()
        .toList();
  }

  Method generateBuildMethod(
    MethodElement method,
    bool seedValueProvided,
    bool generateKeepAlive,
  ) {
    final isFuture = method.returnType.isDartAsyncFuture ||
        method.returnType.isDartAsyncFutureOr;
    final isStream = method.returnType.isDartAsyncStream;
    final positionalArgs =
        method.parameters.where((p) => p.isPositional).toList();
    final positionalArgsCode = positionalArgs.map((arg) => arg.name).join(", ");
    return Method(
      (methodBuilder) {
        methodBuilder
          ..name = "build"
          ..body = Block((blockBuilder) {
            if (generateKeepAlive) {
              blockBuilder.addStaticCode(_keepAliveInsert);
            }
            if (isStream) {
              blockBuilder.addStaticCode("yield* ");
            } else {
              blockBuilder.addStaticCode("return ");
            }
            blockBuilder.addStaticCode(
              "noSuchMethod(Invocation.method(#build, [$positionalArgsCode])",
            );
            if (seedValueProvided) {
              blockBuilder.addStaticCode(
                ", returnValueForMissingStub: seedBuilder()",
              );
            }
            blockBuilder.addStaticCode(",);");
          })
          ..copyParameters(
            method: method,
            obtainReferenceForType: (type) =>
                _typeReferencer.obtainReferenceForType(type, true),
          )
          ..annotations.add(const CodeExpression(Code("override")))
          ..returns = _typeReferencer.obtainReferenceForType(method.returnType);
        if (isFuture) {
          methodBuilder.modifier = MethodModifier.async;
        } else if (isStream) {
          methodBuilder.modifier = MethodModifier.asyncStar;
        }
      },
    );
  }

  Method? generateMethod(
    MethodElement method,
    Set<FakeType> fakeTypes,
  ) {
    if (!method.isPublic) {
      return null;
    }
    final isFuture = method.returnType.isDartAsyncFuture ||
        method.returnType.isDartAsyncFutureOr;
    final isStream = method.returnType.isDartAsyncStream;
    final positionalArgs =
        method.parameters.where((p) => p.isPositional).toList();
    final positionalArgsCode = positionalArgs.map((arg) => arg.name).join(", ");
    final returnType = method.returnType;
    final fakedReturnType = fakeTypes.cast<FakeType?>().firstWhere(
          (fakeType) => fakeType?.originalType == returnType,
          orElse: () => null,
        );

    final stubValue = fakedReturnType != null
        ? _fakeTypeGenerator.getStubValue(
            fakedReturnType, method.name, positionalArgsCode)
        : null;
    return Method(
      (methodBuilder) {
        methodBuilder
          ..name = method.name
          ..body = Block((blockBuilder) {
            if (isStream) {
              blockBuilder.addStaticCode("yield* ");
            } else {
              blockBuilder.addStaticCode("return ");
            }
            blockBuilder.addStaticCode(
              "noSuchMethod(Invocation.method(#${method.name}, [$positionalArgsCode])",
            );
            if (stubValue != null) {
              blockBuilder.addStaticCode(", returnValueForMissingStub: ");
              blockBuilder.addCode(stubValue);
              blockBuilder.addStaticCode(", returnValue: ");
              blockBuilder.addCode(stubValue);
            }
            blockBuilder.addStaticCode(",);");
          })
          ..copyParameters(
            method: method,
            obtainReferenceForType: (type) =>
                _typeReferencer.obtainReferenceForType(type, true),
          )
          ..annotations.add(const CodeExpression(Code("override")))
          ..returns = _typeReferencer.obtainReferenceForType(method.returnType);
        if (isFuture) {
          methodBuilder.modifier = MethodModifier.async;
        } else if (isStream) {
          methodBuilder.modifier = MethodModifier.asyncStar;
        }
      },
    );
  }
}
