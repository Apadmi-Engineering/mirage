import 'dart:core';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:mirage/src/util/method_builder_utils.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'method_builder_utils_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DartType>(),
  MockSpec<MethodElement>(),
  MockSpec<ParameterElement>(),
])
void main() {
  group("Method builder unit tests", () {
    test("copyParameters - adds expected parameters", () {
      // Setup
      // Parameter
      final parameterFixture = MockParameterElement();
      when(parameterFixture.name).thenReturn("p1");
      when(parameterFixture.type).thenReturn(MockDartType());
      when(parameterFixture.isNamed).thenReturn(false);
      when(parameterFixture.isOptional).thenReturn(false);
      when(parameterFixture.isRequired).thenReturn(true);

      // Optional parameter
      final optionalParameterFixture = MockParameterElement();
      when(optionalParameterFixture.name).thenReturn("p2");
      when(optionalParameterFixture.type).thenReturn(MockDartType());
      when(optionalParameterFixture.isNamed).thenReturn(true);
      when(optionalParameterFixture.isOptional).thenReturn(true);
      when(optionalParameterFixture.isRequired).thenReturn(false);

      final mockElement = MockMethodElement();
      when(mockElement.parameters)
          .thenReturn([parameterFixture, optionalParameterFixture]);

      final sut = MethodBuilder();

      // Run test
      sut.copyParameters(
        method: mockElement,
        obtainReferenceForType: (_) => const Reference("String"),
      );

      // Verify
      expect(
        sut,
        isA<MethodBuilder>()
            .having(
              (it) => it.requiredParameters.length,
              "Expected required parameter count",
              1,
            )
            .having(
              (it) => it.requiredParameters.first.name,
              "Expected first required parameter",
              "p1",
            )
            .having(
              (it) => it.optionalParameters.length,
              "Expected optional parameter count",
              1,
            )
            .having(
              (it) => it.optionalParameters.first.name,
              "Expected first optional parameter",
              "p2",
            ),
      );
    });
  });
}
