import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element2.dart';
import 'package:code_builder/code_builder.dart' hide Expression;
import 'package:mirage/src/util/object_utils.dart';

class FieldCopier {
  Method? copyGetter(GetterElement element) =>
      _copyGetterImplementation(element)?.let((implementation) {
        return Method((mb) => mb
          ..name = element.name3
          ..type = MethodType.getter
          ..lambda = true
          ..body = implementation);
      });

  Field? copyField(FieldElement2 element) =>
      _copyFieldImplementation(element)?.let((implementation) {
        return Field((fb) => fb
          ..name = element.name3
          ..late = element.isLate
          ..modifier =
              element.isFinal ? FieldModifier.final$ : FieldModifier.var$
          ..assignment = implementation);
      });

  Code? _copyGetterImplementation(TypeParameterizedElement2 element) {
    final library =
        element.session?.getParsedLibraryByElement2(element.library2);
    if (library is! ParsedLibraryResult) {
      return null;
    }
    final declaration =
        library.getFragmentDeclaration(element.firstFragment)?.node;
    if (declaration == null) {
      // Fields early exit here
      return null;
    }
    if (declaration is! MethodDeclaration) {
      return null;
    }
    final rawBody = declaration.body;
    final bodySource = switch (rawBody) {
      ExpressionFunctionBody(:final expression) =>
        CodeExpression(Code(expression.toSource())).code,
      BlockFunctionBody(:final block) => Code(block.statements
              .whereType<ReturnStatement>()
              .firstOrNull
              ?.toSource() ??
          "// Found nothing"),
      _ => Code(rawBody.toSource()),
    };
    return bodySource;
  }

  Code? _copyFieldImplementation(FieldElement2 element) {
    final library =
        element.session?.getParsedLibraryByElement2(element.library2);
    if (library is! ParsedLibraryResult) {
      return null;
    }
    final declaration =
        library.getFragmentDeclaration(element.firstFragment)?.node;
    if (declaration == null) {
      return null;
    }
    if (declaration is! VariableDeclaration) {
      return null;
    }
    final rawBody = declaration.initializer;
    return Code(rawBody?.toSource() ?? "");
  }
}
