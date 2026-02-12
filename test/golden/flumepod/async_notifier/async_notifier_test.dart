import '../../utils/test_golden_builder.dart';

void main() {
  testGoldenBuilder(
    "Flumepod - generates standard AsyncNotifier as expected",
    "test/golden/flumepod/async_notifier/input.dart",
    "test/golden/flumepod/async_notifier/input.g.dart",
    "test/golden/flumepod/async_notifier/expected.flumepod.dart",
  );
}
