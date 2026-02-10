import '../../utils/test_golden_builder.dart';

void main() {
  testGoldenBuilder(
    "Flumepod - generates standard AutoDisposeFamilyAsyncNotifier as expected",
    "test/golden/flumepod/auto_dispose_family_async_notifier/input.dart",
    "test/golden/flumepod/auto_dispose_family_async_notifier/input.g.dart",
    "test/golden/flumepod/auto_dispose_family_async_notifier/expected.flumepod.dart",
  );
}
