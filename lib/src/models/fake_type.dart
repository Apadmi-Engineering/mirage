import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:flumepod/src/import_finder.dart';
import 'package:flumepod/src/util/object_utils.dart';

class FakeType {
  final Element? element;
  final DartType originalType;
  final String? fakeTypeName;
  final List<FakeType>? parameterTypes;

  const FakeType(
    this.element,
    this.originalType,
    this.fakeTypeName, {
    this.parameterTypes,
  });

  @override
  String toString() =>
      "FakeType(element: $element, parameterTypes: $parameterTypes, "
      "fakeTypeName: $fakeTypeName, originalType: $originalType"
      ")";

  String allocateType(String Function(Reference) allocate, ImportFinder importFinder) {
    final parameterTypes = this.parameterTypes;
    final topLevelTypeCode = allocate(refer(
      originalType.element!.name!,
      importFinder.getImportUrl(originalType.element!.library),
    ));
    if (parameterTypes == null || parameterTypes.isEmpty) {
      return topLevelTypeCode;
    }
    final parameterTypeCode = parameterTypes.map((type) => allocateType(allocate, importFinder)).join(", ");
    return "$topLevelTypeCode<$parameterTypeCode>";
  }
}

class RecordFakeType extends FakeType {
  final List<FakeType>? positionalFields;
  final Map<String, FakeType>? namedFields;

  RecordFakeType(
    super.element,
    super.originalType,
    super.fakeTypeName, {
    this.positionalFields,
    this.namedFields,
  });

  @override
  String toString() =>
      "RecordFakeType(element: $element, parameterTypes: $parameterTypes, "
      "fakeTypeName: $fakeTypeName, originalType: $originalType, "
      "namedFields: $namedFields, positionalFields: $positionalFields"
      ")";

  @override
  String allocateType(String Function(Reference) allocate, ImportFinder importFinder) {
    final (localPositionalFields, localNamedFields) = (positionalFields, namedFields);
    if(localPositionalFields == null && localNamedFields == null) {
      return "()";
    }
    final positionalFieldsCode = localPositionalFields?.map(
        (field) => field.allocateType(allocate, importFinder)
    ).join(",") ?? "";
    final namedFieldsCode = localNamedFields?.entries.map(
        (entry) => "${entry.value.allocateType(allocate, importFinder)} ${entry.key}"
    ).join(",") ?? "";
    final fieldsCode = [
      ?positionalFieldsCode.takeIf(positionalFieldsCode.isNotEmpty),
      ?namedFieldsCode.takeIf(namedFieldsCode.isNotEmpty),
    ].join(",");
    return "($fieldsCode)";
  }
}
