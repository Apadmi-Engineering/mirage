import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart' hide Expression;
import 'package:flumepod/src/util/object_utils.dart';
import 'package:flumepod/src/util/symbol_resolver.dart';

abstract interface class MemberCopier {
  Method? copyGetter(GetterElement element);

  Field? copyField(FieldElement element);

  Method? copyMethod(MethodElement element, bool isOverride);
}

class MemberCopierImpl implements MemberCopier {
  final ResolvedLibraryResult library;

  MemberCopierImpl(this.library);

  @override
  Method? copyGetter(GetterElement element) =>
      copyGetterImplementation(element, library)?.let((implementation) {
        return Method(
          (mb) => mb
            ..name = element.name
            ..type = MethodType.getter
            ..lambda = true
            ..body = implementation,
        );
      });

  @override
  Field? copyField(FieldElement element) =>
      copyFieldImplementation(element, library)?.let((implementation) {
        return Field(
          (fb) => fb
            ..name = element.name
            ..late = element.isLate
            ..modifier = element.isFinal
                ? FieldModifier.final$
                : FieldModifier.var$
            ..assignment = implementation,
        );
      });

  @override
  Method? copyMethod(MethodElement element, bool isOverride) =>
      copyMethodImplementation(element, library)?.let((implementation) {
        return Method(
          (mb) => mb
            ..name = element.name
            ..body = implementation
            ..annotations.addAll([
              if (isOverride) CodeExpression(Code("override")),
            ]),
        );
      });

  Code? copyGetterImplementation(
    TypeParameterizedElement element,
    ResolvedLibraryResult resolvedLibrary,
  ) {
    final declaration = resolvedLibrary
        .getFragmentDeclaration(element.firstFragment)
        ?.node;
    if (declaration == null) {
      // Fields early exit here
      return null;
    }
    if (declaration is! MethodDeclaration) {
      return null;
    }
    final rawBody = declaration.body;
    final bodySource = switch (rawBody) {
      ExpressionFunctionBody(:final expression) => CodeExpression(
        Code(expression.toSource()),
      ).code,
      BlockFunctionBody(:final block) => Code(
        block.statements.whereType<ReturnStatement>().firstOrNull?.toSource() ??
            "// Found nothing",
      ),
      _ => Code(rawBody.toSource()),
    };
    return bodySource;
  }

  Code? copyFieldImplementation(
    FieldElement element,
    ResolvedLibraryResult resolvedLibrary,
  ) {
    final declaration = resolvedLibrary
        .getFragmentDeclaration(element.firstFragment)
        ?.node;
    if (declaration == null) {
      return null;
    }
    if (declaration is! VariableDeclaration) {
      return null;
    }
    final rawBody = declaration.initializer;
    if (rawBody == null) {
      return Code("");
    }
    final allocator = SymbolResolver();
    declaration.accept(allocator);
    final references = allocator.consumeReferences();
    return Code.scope((allocate) {
      String bodySource = rawBody.toSource();
      allocate(
        refer("Ref", "package:riverpod_annotation/riverpod_annotation.dart"),
      );
      for (final reference in references) {
        bodySource = bodySource.replaceAll(
          reference.symbol ?? "",
          allocate(reference),
        );
      }
      return bodySource;
    });
  }

  Code? copyMethodImplementation(
    MethodElement element,
    ResolvedLibraryResult resolvedLibrary,
  ) {
    final declaration = resolvedLibrary
        .getFragmentDeclaration(element.firstFragment)
        ?.node;
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
        bodySource = bodySource.replaceAll(
          reference.symbol ?? "",
          allocate(reference),
        );
      }
      return bodySource;
    });
  }
}
