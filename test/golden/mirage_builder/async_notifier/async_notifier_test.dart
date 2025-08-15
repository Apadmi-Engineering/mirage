import '../../utils/test_golden_builder.dart';

void main() {
  testGoldenBuilder(
    "MirageBuilder - generates standard AsyncNotifier as expected",
    "test/golden/mirage_builder/async_notifier/input.dart",
    "test/golden/mirage_builder/async_notifier/input.g.dart",
    "test/golden/mirage_builder/async_notifier/expected.mirage.dart",
  );
}
