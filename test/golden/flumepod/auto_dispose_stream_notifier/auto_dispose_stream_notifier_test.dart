import '../../utils/test_golden_builder.dart';

void main() {
  testGoldenBuilder(
    "Flumepod - generates standard AutoDisposeSteamNotifier as expected",
    "test/golden/flumepod/auto_dispose_stream_notifier/input.dart",
    "test/golden/flumepod/auto_dispose_stream_notifier/input.g.dart",
    "test/golden/flumepod/auto_dispose_stream_notifier/expected.flumepod.dart",
  );
}
