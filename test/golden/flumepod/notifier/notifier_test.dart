import '../../utils/test_golden_builder.dart';

void main() {
  testGoldenBuilder(
    "Flumepod - generates standard Notifier as expected",
    "test/golden/flumepod/notifier/input.dart",
    "test/golden/flumepod/notifier/input.g.dart",
    "test/golden/flumepod/notifier/expected.flumepod.dart",
  );
}
