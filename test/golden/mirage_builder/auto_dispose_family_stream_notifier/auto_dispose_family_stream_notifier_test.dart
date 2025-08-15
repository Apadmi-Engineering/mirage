import '../../utils/test_golden_builder.dart';

void main() {
  testGoldenBuilder(
    "MirageBuilder - generates standard AutoDisposeFamilySteamNotifier as expected",
    "test/golden/mirage_builder/auto_dispose_family_stream_notifier/input.dart",
    "test/golden/mirage_builder/auto_dispose_family_stream_notifier/input.g.dart",
    "test/golden/mirage_builder/auto_dispose_family_stream_notifier/expected.mirage.dart",
  );
}
