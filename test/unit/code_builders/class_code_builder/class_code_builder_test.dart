import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:flumepod/src/code_builders/classes/class_code_builder.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../util/stubbing_utils.dart';
import 'class_code_builder_test.mocks.dart';

class FakeClassCodeBuilder with ClassCodeBuilderUtils {}

@GenerateNiceMocks([
  MockSpec<ClassElement>(),
  MockSpec<AnalysisSession>(),
  MockSpec<ResolvedLibraryResult>(),
])
void main() async {
  group("Class code builder utils unit tests", () {
    late FakeClassCodeBuilder sut;

    setUp(() {
      sut = FakeClassCodeBuilder();
    });

    test("getResolvedClass - upon unsuccessful result - throws", () async {
      final fakeResult = CannotResolveUriResult();
      final mockSession = MockAnalysisSession()
        ..stubAnswerAsync(
          (it) => it.getResolvedLibraryByElement(any),
          fakeResult,
        );
      final mockClass = MockClassElement()
        ..stubReturn((it) => it.session, mockSession);

      await expectLater(
        () => sut.getResolvedClass(mockClass),
        throwsStateError,
      );
    });

    test("getResolvedClass - upon success result - answers result", () async {
      final fakeResult = MockResolvedLibraryResult();
      final mockSession = MockAnalysisSession()
        ..stubAnswerAsync(
          (it) => it.getResolvedLibraryByElement(any),
          fakeResult,
        );
      final mockClass = MockClassElement()
        ..stubReturn((it) => it.session, mockSession);

      await expectLater(
        sut.getResolvedClass(mockClass),
        completion(fakeResult),
      );
    });
  });
}
