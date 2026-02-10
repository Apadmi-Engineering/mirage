import '../../utils/test_golden_builder.dart';

void main() {
  testGoldenBuilder(
    "Flumepod - generates standard FamilyNotifier as expected",
    "test/golden/flumepod/family_notifier/input.dart",
    "test/golden/flumepod/family_notifier/input.g.dart",
    "test/golden/flumepod/family_notifier/expected.flumepod.dart",
  );
}
