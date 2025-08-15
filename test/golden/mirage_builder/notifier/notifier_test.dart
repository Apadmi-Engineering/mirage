import '../../utils/test_golden_builder.dart';

void main() {
  testGoldenBuilder(
    "MirageBuilder - generates standard Notifier as expected",
    "test/golden/mirage_builder/notifier/input.dart",
    "test/golden/mirage_builder/notifier/input.g.dart",
    "test/golden/mirage_builder/notifier/expected.mirage.dart",
  );
}
