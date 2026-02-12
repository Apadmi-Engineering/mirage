import '../../utils/test_golden_builder.dart';

void main() {
  testGoldenBuilder(
    "Flumepod - generates standard FamilySteamNotifier as expected",
    "test/golden/flumepod/family_stream_notifier/input.dart",
    "test/golden/flumepod/family_stream_notifier/input.g.dart",
    "test/golden/flumepod/family_stream_notifier/expected.flumepod.dart",
  );
}
