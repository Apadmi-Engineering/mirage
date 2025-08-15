import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:mirage/src/code_builders/fake_type_code_builder.dart';
import 'package:mirage/src/import_finder.dart';
import 'package:mirage/src/models/fake_type.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

import '../../util/stubbing_utils.dart';
import 'fake_type_code_builder_test.mocks.dart';

part 'fixtures.dart';

@GenerateNiceMocks([
  MockSpec<DartType>(),
  MockSpec<VoidType>(),
  MockSpec<Element>(),
  MockSpec<ClassElement>(),
  MockSpec<EnumElement>(),
  MockSpec<LibraryElement>(),
  MockSpec<LibraryReader>(),
  MockSpec<ImportFinder>(),
  MockSpec<ParameterizedType>(),
  MockSpec<TypeParameterElement>(),
])
void main() {
  group("Fake type code builder unit tests", () {
    final mockLibraryReader = MockLibraryReader();
    final mockImportFinder = MockImportFinder();
    late FakeTypeCodeBuilder sut;

    setUp(() {
      reset(mockImportFinder);
      reset(mockLibraryReader);
      sut = FakeTypeCodeBuilder(mockLibraryReader, mockImportFinder);
    });

    test("generateFakeTypes - returns expected fake types", () {
      // Setup
      final Set<DartType> input = {
        _voidType(),
        _coreType(),
        _enumType(),
        _interfaceType(),
        _futureType(),
        _streamType(),
        _genericType(),
        _privateType(),
        _finalType(),
        _sealedType(),
      };

      // Run test
      final result = sut.generateFakeTypes(input);

      // Verify
      final expected = {
        FakeType(null, _voidType(), null, null),
        FakeType(_coreType().element, _coreType(), null, null),
        FakeType(_enumType().element, _enumType(), null, null),
        FakeType(
            _interfaceType().element, _interfaceType(), "_FakeMyClass", null),
        FakeType(_futureType().element, _futureType(), null, null),
        FakeType(_streamType().element, _streamType(), null, null),
        FakeType(_genericType().element, _genericType(), "_FakeOuterClass", [
          FakeType(_genericType().typeArguments.first.element,
              _genericType().typeArguments.first, "_FakeInnerClass", []),
        ]),
        FakeType(_privateType().element, _privateType(), null, []),
        FakeType(_finalType().element, _finalType(), null, []),
        FakeType(_sealedType().element, _sealedType(), null, []),
      };
      expect(
        result,
        containsAll(
          expected.map(
            (expectedFakeType) => isA<FakeType>()
                .having(
                  (it) => it.fakeTypeName,
                  "expected name",
                  expectedFakeType.fakeTypeName,
                )
                .having(
                  (it) => it.element,
                  "expected meta type",
                  expectedFakeType.element,
                ),
          ),
        ),
      );
    });

    test("buildFakeClass - with no original element - returns null", () {
      // Setup
      final dartTypeFixture = MockDartType()
        ..stubReturn((it) => it.element, null);
      final fakeType = FakeType(null, dartTypeFixture, null, null);

      // Run test & verify
      expect(sut.buildFakeClass(fakeType), null);
    });

    test("buildFakeClass - with no fake type name - returns null", () {
      // Setup
      final mockClassElement = MockClassElement();
      final dartTypeFixture = MockDartType()
        ..stubReturn(
          (it) => it.element,
          mockClassElement,
        );
      final fakeType = FakeType(mockClassElement, dartTypeFixture, null, null);

      // Run test & verify
      expect(sut.buildFakeClass(fakeType), null);
    });

    test("buildFakeClass - with fake type - returns class", () {
      // Setup
      final mockClassElement = MockClassElement()
        ..stubReturn((it) => it.name, "MyType");
      final dartTypeFixture = MockDartType()
        ..stubReturn((it) => it.element, mockClassElement);
      final fakeType =
          FakeType(mockClassElement, dartTypeFixture, "_FakeMyType", null);

      when(mockLibraryReader.pathToElement(any)).thenReturn(
        Uri.parse("package:consumer/consumer.dart"),
      );

      // Run test
      final result = sut.buildFakeClass(fakeType);

      // Verify
      expect(
        result,
        isA<Class>()
            .having((it) => it.name, "expected name", "_FakeMyType")
            .having(
              (it) => it.extend,
              "expected superclass",
              const Reference("SmartFake", "package:mockito/mockito.dart"),
            )
            .having(
              (it) => it.implements.first,
              "expected interface",
              const Reference("MyType", "package:consumer/consumer.dart"),
            ),
      );
    });
  });
}
