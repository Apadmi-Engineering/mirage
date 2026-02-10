import 'package:flumepod/flumepod.dart';
import 'package:flumepod_example/src/notifiers/notifier/notifier.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test/test.dart';

import 'notifier_test.flumepod.dart';

@Flumepod(providerTypesToMock: {DummySource})
void main() async {
  test("Test", () async {
    // Setup
    final container = ProviderContainer.test(overrides: [
      dummySourceProvider(6).overrideWith(
        () => MockDummySource(() async => 36),
      )
    ]);

    // Run test
    final result = await container.read(dummyProvider(6).future);

    // Verify
    expect(result, 36);
    final mockDummySource = container.read(dummySourceProvider(6).notifier) as MockDummySource;
    verify(mockDummySource.someSideEffect()).called(1);
  });
}
