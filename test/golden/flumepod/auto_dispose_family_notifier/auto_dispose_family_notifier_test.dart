import '../../utils/test_golden_builder.dart';

void main() {
  testGoldenBuilder(
    "Flumepod - generates standard AutoDisposeFamilyNotifier as expected",
    "test/golden/flumepod/auto_dispose_family_notifier/input.dart",
    "test/golden/flumepod/auto_dispose_family_notifier/input.g.dart",
    "test/golden/flumepod/auto_dispose_family_notifier/expected.flumepod.dart",
  );
}
