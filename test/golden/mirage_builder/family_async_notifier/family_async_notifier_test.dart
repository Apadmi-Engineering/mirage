import '../../utils/test_golden_builder.dart';

void main() {
  testGoldenBuilder(
    "MirageBuilder - generates standard FamilyAsyncNotifier as expected",
    "test/golden/mirage_builder/family_async_notifier/input.dart",
    "test/golden/mirage_builder/family_async_notifier/input.g.dart",
    "test/golden/mirage_builder/family_async_notifier/expected.mirage.dart",
  );
}
