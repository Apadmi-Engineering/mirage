import '../../utils/test_golden_builder.dart';

void main() {
  testGoldenBuilder(
    "MirageBuilder - generates standard FamilyNotifier as expected",
    "test/golden/mirage_builder/family_notifier/input.dart",
    "test/golden/mirage_builder/family_notifier/input.g.dart",
    "test/golden/mirage_builder/family_notifier/expected.mirage.dart",
  );
}
