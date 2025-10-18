import 'package:mirage/mirage.dart';
import 'package:mirage_example/src/notifiers/notifier/notifier.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test/scaffolding.dart';

import 'notifier_test.mirage.dart';

@GenerateMirage(providerTypesToMock: {DummySource})
void main() async {
  test("Test", () async {
    // Setup
    final container = ProviderContainer.test(overrides: [
      dummySourceProvider(6).overrideWith(
        () => MockDummySource(() async => 36),
      )
    ]);

    // Run test
    await container.read(dummyProvider(6).future);

    // Verify
    final mockDummySource = container.read(dummySourceProvider(6).notifier) as MockDummySource;
    verify(mockDummySource.someSideEffect()).called(1);
  });
}
