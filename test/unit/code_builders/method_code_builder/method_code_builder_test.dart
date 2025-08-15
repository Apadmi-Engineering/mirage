import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:mirage/src/code_builders/fake_type_code_builder.dart';
import 'package:mirage/src/code_builders/method_code_builder.dart';
import 'package:mirage/src/type_referencer.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'method_code_builder_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DartType>(),
  MockSpec<FakeTypeCodeBuilder>(),
  MockSpec<TypeReferencer>(),
  MockSpec<MethodElement>(),
  MockSpec<ParameterElement>(),
])
void main() {
  group("Method code builder unit tests", () {
    final mockFakeTypeCodeBuilder = MockFakeTypeCodeBuilder();
    final mockTypeReferencer = MockTypeReferencer();
    late MethodCodeBuilder sut;

    setUp(() {
      reset(mockFakeTypeCodeBuilder);
      reset(mockTypeReferencer);
      sut = MethodCodeBuilder(mockFakeTypeCodeBuilder, mockTypeReferencer);
    });

    test(
        "generateBuildMethod - async, no seed, no keep alive - returns expected method",
        () {
      // Setup
      final parameterTypeFixture = MockDartType();
      final parameterFixture = MockParameterElement();
      when(parameterFixture.name).thenReturn("p1");
      when(parameterFixture.type).thenReturn(parameterTypeFixture);
      when(parameterFixture.isRequired).thenReturn(true);
      when(parameterFixture.isOptional).thenReturn(false);

      final returnTypeFixture = MockDartType();
      when(returnTypeFixture.isDartAsyncFuture).thenReturn(true);
      final methodElementFixture = MockMethodElement();
      when(methodElementFixture.returnType).thenReturn(returnTypeFixture);
      when(methodElementFixture.parameters).thenReturn([parameterFixture]);

      when(mockTypeReferencer.obtainReferenceForType(parameterTypeFixture, any))
          .thenReturn(
        const Reference("int"),
      );
      when(mockTypeReferencer.obtainReferenceForType(returnTypeFixture, any))
          .thenReturn(const Reference("Future<String>"));

      // Run test
      final result =
          sut.generateBuildMethod(methodElementFixture, false, false);

      // Verify
      expect(
        result,
        isA<Method>()
            .having(
              (it) => it.name,
              "expected name",
              "build",
            )
            .having(
              (it) => it.modifier,
              "expected modifier",
              MethodModifier.async,
            )
            .having(
              (it) => it.returns?.symbol,
              "expected return type",
              "Future<String>",
            )
            .having(
              (it) => it.annotations.first.code.toString(),
              "expected override annotation",
              "override",
            )
            .having(
              (it) => it.requiredParameters,
              "expected required parameters",
              allOf(
                hasLength(1),
                contains(
                  isA<Parameter>()
                      .having((it) => it.name, "expected name", "p1")
                      .having((it) => it.type?.symbol, "expected type", "int"),
                ),
              ),
            )
            .having(
          (it) => it.optionalParameters,
          "expected optional parameters",
          [],
        ),
      );
    });

    test(
        "generateBuildMethod - async, seeded, keep alive - returns expected method",
        () {
      // Setup
      final parameterTypeFixture = MockDartType();
      final parameterFixture = MockParameterElement();
      when(parameterFixture.name).thenReturn("p1");
      when(parameterFixture.type).thenReturn(parameterTypeFixture);
      when(parameterFixture.isRequired).thenReturn(false);
      when(parameterFixture.isOptional).thenReturn(true);

      final returnTypeFixture = MockDartType();
      when(returnTypeFixture.isDartAsyncFuture).thenReturn(true);
      final methodElementFixture = MockMethodElement();
      when(methodElementFixture.returnType).thenReturn(returnTypeFixture);
      when(methodElementFixture.parameters).thenReturn([parameterFixture]);

      when(mockTypeReferencer.obtainReferenceForType(parameterTypeFixture, any))
          .thenReturn(
        const Reference("int"),
      );
      when(mockTypeReferencer.obtainReferenceForType(returnTypeFixture, any))
          .thenReturn(const Reference("Future<String>"));

      // Run test
      final result = sut.generateBuildMethod(methodElementFixture, true, true);

      // Verify
      expect(
        result,
        isA<Method>()
            .having(
              (it) => it.name,
              "expected name",
              "build",
            )
            .having(
              (it) => it.modifier,
              "expected modifier",
              MethodModifier.async,
            )
            .having(
              (it) => it.returns?.symbol,
              "expected return type",
              "Future<String>",
            )
            .having(
              (it) => it.annotations.first.code.toString(),
              "expected override annotation",
              "override",
            )
            .having(
              (it) => it.optionalParameters,
              "expected optional parameters",
              allOf(
                hasLength(1),
                contains(
                  isA<Parameter>()
                      .having((it) => it.name, "expected name", "p1")
                      .having((it) => it.type?.symbol, "expected type", "int"),
                ),
              ),
            )
            .having(
              (it) => it.requiredParameters,
              "expected required parameters",
              [],
            )
            .having(
              (it) => it.body.toString(),
              "body contains keepAlive",
              contains("ref.keepAlive()"),
            )
            .having(
              (it) => it.body.toString(),
              "body containers seedBuilder invocation",
              contains("seedBuilder()"),
            ),
      );
    });

    test(
        "generateBuildMethod - sync, no seed, no keep alive - returns expected method",
        () {
      // Setup
      final returnTypeFixture = MockDartType();
      final methodElementFixture = MockMethodElement();
      when(methodElementFixture.returnType).thenReturn(returnTypeFixture);

      when(mockTypeReferencer.obtainReferenceForType(returnTypeFixture, any))
          .thenReturn(const Reference("Object"));

      // Run test
      final result =
          sut.generateBuildMethod(methodElementFixture, false, false);

      // Verify
      expect(
        result,
        isA<Method>()
            .having(
              (it) => it.name,
              "expected name",
              "build",
            )
            .having(
              (it) => it.modifier,
              "expected modifier",
              null,
            )
            .having(
              (it) => it.returns?.symbol,
              "expected return type",
              "Object",
            )
            .having(
              (it) => it.annotations.first.code.toString(),
              "expected override annotation",
              "override",
            ),
      );
    });

    test(
        "generateBuildMethod - stream, no seed, no keep alive - returns expected method",
        () {
      // Setup
      final returnTypeFixture = MockDartType();
      final methodElementFixture = MockMethodElement();
      when(returnTypeFixture.isDartAsyncStream).thenReturn(true);
      when(methodElementFixture.returnType).thenReturn(returnTypeFixture);

      when(mockTypeReferencer.obtainReferenceForType(returnTypeFixture, any))
          .thenReturn(const Reference("Stream<MyClass>"));

      // Run test
      final result =
          sut.generateBuildMethod(methodElementFixture, false, false);

      // Verify
      expect(
        result,
        isA<Method>()
            .having(
              (it) => it.name,
              "expected name",
              "build",
            )
            .having(
              (it) => it.modifier,
              "expected modifier",
              MethodModifier.asyncStar,
            )
            .having(
              (it) => it.returns?.symbol,
              "expected return type",
              "Stream<MyClass>",
            )
            .having(
              (it) => it.annotations.first.code.toString(),
              "expected override annotation",
              "override",
            ),
      );
    });

    test("generateMethod - private method - returns null", () {
      // Setup
      final methodElementFixture = MockMethodElement();
      when(methodElementFixture.isPublic).thenReturn(false);

      // Run test + verify
      expect(sut.generateMethod(methodElementFixture, {}), null);
    });

    test("generateMethod - generates expected sync method", () {
      // Setup
      final returnTypeFixture = MockDartType();
      final methodElementFixture = MockMethodElement();
      when(methodElementFixture.isPublic).thenReturn(true);
      when(methodElementFixture.returnType).thenReturn(returnTypeFixture);
      when(methodElementFixture.parameters).thenReturn([]);
      when(methodElementFixture.name).thenReturn("method");
      when(mockTypeReferencer.obtainReferenceForType(any, any)).thenReturn(
        const Reference("String", "dart:core"),
      );

      // Run test
      final result = sut.generateMethod(methodElementFixture, {});

      // Verify
      expect(
        result,
        isA<Method>()
            .having(
              (it) => it.name,
              "expected name",
              "method",
            )
            .having(
              (it) => it.returns?.symbol,
              "expected return type",
              "String",
            )
            .having(
              (it) => it.modifier,
              "expected modifier",
              null,
            )
            .having(
          (it) => it.requiredParameters,
          "expected required parameters",
          [],
        ).having(
          (it) => it.optionalParameters,
          "expected optional parameters",
          [],
        ).having(
          (it) => it.annotations.first.code.toString(),
          "expected override annotation",
          "override",
        ),
      );
    });

    test("generateMethod - generates expected async method", () {
      // Setup
      final returnTypeFixture = MockDartType();
      when(returnTypeFixture.isDartAsyncFuture).thenReturn(true);
      final methodElementFixture = MockMethodElement();
      when(methodElementFixture.isPublic).thenReturn(true);
      when(methodElementFixture.returnType).thenReturn(returnTypeFixture);
      when(methodElementFixture.parameters).thenReturn([]);
      when(methodElementFixture.name).thenReturn("method");
      when(mockTypeReferencer.obtainReferenceForType(any, any)).thenReturn(
        const Reference("Future<String>", "dart:core"),
      );

      // Run test
      final result = sut.generateMethod(methodElementFixture, {});

      // Verify
      expect(
        result,
        isA<Method>()
            .having(
              (it) => it.name,
              "expected name",
              "method",
            )
            .having(
              (it) => it.returns?.symbol,
              "expected return type",
              "Future<String>",
            )
            .having(
              (it) => it.modifier,
              "expected modifier",
              MethodModifier.async,
            )
            .having(
          (it) => it.requiredParameters,
          "expected required parameters",
          [],
        ).having(
          (it) => it.optionalParameters,
          "expected optional parameters",
          [],
        ).having(
          (it) => it.annotations.first.code.toString(),
          "expected override annotation",
          "override",
        ),
      );
    });

    test("generateMethod - generates expected async* method", () {
      // Setup
      final returnTypeFixture = MockDartType();
      when(returnTypeFixture.isDartAsyncStream).thenReturn(true);
      final methodElementFixture = MockMethodElement();
      when(methodElementFixture.isPublic).thenReturn(true);
      when(methodElementFixture.returnType).thenReturn(returnTypeFixture);
      when(methodElementFixture.parameters).thenReturn([]);
      when(methodElementFixture.name).thenReturn("method");
      when(mockTypeReferencer.obtainReferenceForType(any, any)).thenReturn(
        const Reference("Stream<String>", "dart:core"),
      );

      // Run test
      final result = sut.generateMethod(methodElementFixture, {});

      // Verify
      expect(
        result,
        isA<Method>()
            .having(
              (it) => it.name,
              "expected name",
              "method",
            )
            .having(
              (it) => it.returns?.symbol,
              "expected return type",
              "Stream<String>",
            )
            .having(
              (it) => it.modifier,
              "expected modifier",
              MethodModifier.asyncStar,
            )
            .having(
          (it) => it.requiredParameters,
          "expected required parameters",
          [],
        ).having(
          (it) => it.optionalParameters,
          "expected optional parameters",
          [],
        ).having(
          (it) => it.annotations.first.code.toString(),
          "expected override annotation",
          "override",
        ),
      );
    });
  });
}
