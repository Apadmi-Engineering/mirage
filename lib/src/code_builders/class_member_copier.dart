import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element2.dart';
import 'package:code_builder/code_builder.dart' hide Expression;
import 'package:mirage/src/util/object_utils.dart';
import 'package:mirage/src/util/symbol_resolver.dart';

abstract interface class MemberCopier {
  Method? copyGetter(GetterElement element);

  Field? copyField(FieldElement2 element);

  Method? copyMethod(MethodElement2 element, bool isOverride);
}

class MemberCopierImpl implements MemberCopier {
  final ResolvedLibraryResult library;

  MemberCopierImpl(this.library);

  @override
  Method? copyGetter(GetterElement element) =>
      copyGetterImplementation(element)?.let((implementation) {
        return Method((mb) => mb
          ..name = element.name3
          ..type = MethodType.getter
          ..lambda = true
          ..body = implementation);
      });

  @override
  Field? copyField(FieldElement2 element) =>
      copyFieldImplementation(element)?.let((implementation) {
        return Field((fb) => fb
          ..name = element.name3
          ..late = element.isLate
          ..modifier =
              element.isFinal ? FieldModifier.final$ : FieldModifier.var$
          ..assignment = implementation);
      });

  @override
  Method? copyMethod(MethodElement2 element, bool isOverride) =>
      copyMethodImplementation(element, library)?.let((implementation) {
        return Method((mb) => mb
          ..name = element.name3
          ..body = implementation
          ..annotations
              .addAll([if (isOverride) CodeExpression(Code("override"))]));
      });

  Code? copyGetterImplementation(TypeParameterizedElement2 element) {
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

  Code? copyFieldImplementation(FieldElement2 element) {
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
    return Code.scope((allocate) {
      allocate(
          refer("Ref", "package:riverpod_annotation/riverpod_annotation.dart"));
      return rawBody?.toSource() ?? "";
    });
  }

  Code? copyMethodImplementation(MethodElement2 element, ResolvedLibraryResult resolvedLibrary) {
    final declaration =
        resolvedLibrary.getFragmentDeclaration(element.firstFragment)?.node;
    if (declaration == null) {
      return null;
    }
    if (declaration is! MethodDeclaration) {
      return null;
    }
    final allocator = SymbolResolver();
    declaration.accept(allocator);
    final references = allocator.consumeReferences();
    final body = declaration.body;
    return Code.scope((allocate) {
      String bodySource = body.toSource();
      for (final reference in references) {
        bodySource = bodySource.replaceAll(reference.symbol ?? "", allocate(reference));
      }
      return bodySource;
    });
  }
}
