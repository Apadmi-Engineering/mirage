import '../../utils/test_golden_builder.dart';

void main() {
  testGoldenBuilder(
    "MirageBuilder - generates standard SteamNotifier as expected",
    "test/golden/mirage_builder/stream_notifier/input.dart",
    "test/golden/mirage_builder/stream_notifier/input.g.dart",
    "test/golden/mirage_builder/stream_notifier/expected.mirage.dart",
  );
}
