import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/type.dart' as analyzer;
import 'package:analyzer/dart/element/type_system.dart';
import 'package:code_builder/code_builder.dart';
import 'package:mirage/src/import_finder.dart';
import 'package:mirage/src/type_referencer.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../util/stubbing_utils.dart';
import 'type_referencer_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ImportFinder>(),
  MockSpec<TypeSystem>(),
  MockSpec<InterfaceElement2>(),
  MockSpec<analyzer.InterfaceType>(),
  MockSpec<analyzer.DartType>(),
  MockSpec<analyzer.VoidType>(),
  MockSpec<analyzer.RecordType>(),
  MockSpec<analyzer.RecordTypePositionalField>(),
  MockSpec<analyzer.RecordTypeNamedField>(),
])
Future<void> main() async {
  group("Type referencer unit tests", () {
    final mockImportFinder = MockImportFinder();
    final mockTypeSystem = MockTypeSystem();
    late TypeReferencer sut;

    setUp(() {
      reset(mockImportFinder);
      reset(mockTypeSystem);
      sut = TypeReferencer(mockImportFinder, mockTypeSystem);
    });

    test("obtainReferenceForType - void type - returns void reference", () {
      // Setup
      final dartTypeFixture = MockVoidType();

      // Run test
      final result = sut.obtainReferenceForType(dartTypeFixture);

      // Verify
      expect(
        result,
        isA<TypeReference>()
            .having((it) => it.symbol, "expected type", "void")
            .having((it) => it.url, "expected import", null),
      );
    });

    test("obtainReferenceForType - record type - returns record reference", () {
      // Setup
      final fieldTypeFixture = MockDartType()
        ..stubReturn((it) => it.getDisplayString(), "String")
        ..stubReturn((it) => it.element3, MockInterfaceElement2());
      final positionalFieldFixture = MockRecordTypePositionalField()
        ..stubReturn((it) => it.type, fieldTypeFixture);
      final namedFieldFixture = MockRecordTypeNamedField()
        ..stubReturn((it) => it.name, "p0")
        ..stubReturn((it) => it.type, fieldTypeFixture);
      final dartTypeFixture = MockRecordType()
        ..stubReturn((it) => it.positionalFields, [positionalFieldFixture])
        ..stubReturn((it) => it.namedFields, [namedFieldFixture]);

      when(mockImportFinder.getImportUrl(any)).thenReturn("dart:core");

      // Run test
      final result = sut.obtainReferenceForType(dartTypeFixture);

      // Verify
      expect(
        result,
        isA<RecordType>()
            .having(
              (it) => it.positionalFieldTypes,
              "expected positional types",
              contains(
                isA<Reference>(),
              ),
            )
            .having(
              (it) => it.namedFieldTypes.length,
              "expected named types",
              1,
            ),
      );
    });

    test(
        "obtainReferenceForType - non-parameterised interface type - returns TypeReference",
        () {
      // Setup
      when(mockImportFinder.getImportUrl(any))
          .thenReturn("package:consumer/consumer.dart");
      final interfaceElementFixture = MockInterfaceElement2()
        ..stubReturn((it) => it.name3, "MyClass");
      final dartTypeFixture = MockInterfaceType()
        ..stubReturn((it) => it.element3, interfaceElementFixture);

      // Run test
      final result = sut.obtainReferenceForType(dartTypeFixture);

      // Verify
      expect(
        result,
        isA<TypeReference>()
            .having((it) => it.symbol, "expected symbol", "MyClass")
            .having(
              (it) => it.url,
              "expected import",
              "package:consumer/consumer.dart",
            )
            .having(
              (it) => it.isNullable,
              "expected nullability",
              false,
            )
            .having(
          (it) => it.types,
          "expected type parameters",
          [],
        ),
      );
    });

    test(
        "obtainReferenceForType - parameterised interface type - returns TypeReference",
        () {
      // Setup
      when(mockImportFinder.getImportUrl(any))
          .thenReturn("package:consumer/consumer.dart");
      final parameterTypeFixture = MockVoidType();
      final interfaceElementFixture = MockInterfaceElement2()
        ..stubReturn((it) => it.name3, "MyClass")
        ..stubReturn((it) => it.typeParameters2, parameterTypeFixture);
      final dartTypeFixture = MockInterfaceType()
        ..stubReturn((it) => it.element3, interfaceElementFixture)
        ..stubReturn((it) => it.typeArguments, [parameterTypeFixture]);

      // Run test
      final result = sut.obtainReferenceForType(dartTypeFixture);

      // Verify
      expect(
        result,
        isA<TypeReference>()
            .having((it) => it.symbol, "expected symbol", "MyClass")
            .having(
              (it) => it.url,
              "expected import",
              "package:consumer/consumer.dart",
            )
            .having(
              (it) => it.isNullable,
              "expected nullability",
              false,
            )
            .having(
              (it) => it.types,
              "expected type parameters",
              contains(
                isA<TypeReference>(),
              ),
            ),
      );
    });

    test("obtainReferenceForType - generic type - returns Reference", () {
      // Setup
      when(mockImportFinder.getImportUrl(any))
          .thenReturn("package:consumer/consumer.dart");
      final dartTypeFixture = MockDartType()
        ..stubReturn((it) => it.getDisplayString(), "UnknownType");

      // Run test
      final result = sut.obtainReferenceForType(dartTypeFixture);

      // Verify
      expect(
        result,
        isA<Reference>()
            .having((it) => it.symbol, "expected symbol", "UnknownType")
            .having(
              (it) => it.url,
              "expected import",
              "package:consumer/consumer.dart",
            ),
      );
    });
  });
}
