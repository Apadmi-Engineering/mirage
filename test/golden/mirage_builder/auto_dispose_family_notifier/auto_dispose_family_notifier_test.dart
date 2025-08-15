import '../../utils/test_golden_builder.dart';

void main() {
  testGoldenBuilder(
    "MirageBuilder - generates standard AutoDisposeFamilyNotifier as expected",
    "test/golden/mirage_builder/auto_dispose_family_notifier/input.dart",
    "test/golden/mirage_builder/auto_dispose_family_notifier/input.g.dart",
    "test/golden/mirage_builder/auto_dispose_family_notifier/expected.mirage.dart",
  );
}
