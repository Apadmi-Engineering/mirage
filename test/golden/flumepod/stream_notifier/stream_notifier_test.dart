import '../../utils/test_golden_builder.dart';

void main() {
  testGoldenBuilder(
    "Flumepod - generates standard SteamNotifier as expected",
    "test/golden/flumepod/stream_notifier/input.dart",
    "test/golden/flumepod/stream_notifier/input.g.dart",
    "test/golden/flumepod/stream_notifier/expected.flumepod.dart",
  );
}
