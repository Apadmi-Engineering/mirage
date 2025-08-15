import 'package:mirage/mirage.dart';
import 'package:mirage_example/src/notifiers/notifier/notifier.dart';
import 'package:mockito/mockito.dart';
import 'package:test/scaffolding.dart';

import '../../utils/provider_test_utils.dart';
import 'notifier_test.mirage.dart';

@GenerateMirage(providerTypesToMock: {DummySource})
void main() async {
  test("Test", () async {
    // Setup
    final container = createContainer(overrides: [
      dummySourceProvider(6).overrideWith(
        () => MockDummySource(() async => 36),
      )
    ]);

    // Run test
    await container.read(dummyNotifierProvider(6).future);

    // Verify
    final mockDummySource = container.read(dummySourceProvider(6).notifier) as MockDummySource;
    verify(mockDummySource.someSideEffect()).called(1);
  });
}
