import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:code_builder/code_builder.dart';

class SymbolResolver extends RecursiveAstVisitor {
  static const _coreLibraryScheme = "dart";

  final Set<Reference> _references = {};

  @override
  visitNamedType(NamedType node) {
    final element = node.element2;
    if (element == null) {
      return;
    }
    final (name, uri) = (element.name3, element.library2?.uri);
    if (name == null || uri == null || uri.scheme == _coreLibraryScheme) {
      return super.visitNamedType(node);
    }
    _references.add(Reference(name, uri.toString()));
    return super.visitNamedType(node);
  }

  Set<Reference> consumeReferences() {
    final finalisedReferences = _references.toSet();
    _references.clear();
    return finalisedReferences;
  }
}
