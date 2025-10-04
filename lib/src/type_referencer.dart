import 'package:analyzer/dart/element/type_system.dart';
import 'package:code_builder/code_builder.dart';
import 'package:mirage/src/import_finder.dart';
import 'package:analyzer/dart/element/type.dart' as analyzer;

class TypeReferencer {
  final ImportFinder _importFinder;
  final TypeSystem _typeSystem;

  const TypeReferencer(this._importFinder, this._typeSystem);

  Reference obtainReferenceForType(
    analyzer.DartType type, [
    bool forceNullable = false,
  ]) {
    if (type is analyzer.VoidType ||
        type is analyzer.InvalidType ||
        type is analyzer.NeverType) {
      return TypeReference((builder) => builder.symbol = "void");
    } else if (type is analyzer.RecordType) {
      return RecordType(
        (builder) => builder
          ..positionalFieldTypes.addAll(
            type.positionalFields.map(
              (field) => obtainReferenceForType(field.type),
            ),
          )
          ..namedFieldTypes.addAll({
            for (final field in type.namedFields)
              field.name: obtainReferenceForType(field.type),
          })
          ..isNullable = forceNullable || _typeSystem.isNullable(type),
      );
    } else if (type is analyzer.InterfaceType) {
      return TypeReference(
        (builder) => builder
          ..symbol = type.element.name
          ..isNullable = forceNullable || _typeSystem.isNullable(type)
          ..url = _importFinder.getImportUrl(type.element3)
          ..types.addAll(type.typeArguments.map(obtainReferenceForType)),
      );
    }
    return refer(
      type.getDisplayString(),
      _importFinder.getImportUrl(type.element3),
    );
  }
}
