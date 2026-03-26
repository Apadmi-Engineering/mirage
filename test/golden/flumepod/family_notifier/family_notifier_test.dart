import 'dart:io';

import '../../utils/test_golden_builder.dart';

void main() async {
  testGoldenBuilder(
    "Flumepod - generates standard FamilyNotifier as expected",
    "test/golden/flumepod/family_notifier/input.dart",
    "test/golden/flumepod/family_notifier/input.g.dart",
    "test/golden/flumepod/family_notifier/expected.flumepod.dart",
    additionalSources: {
      "flumepod|test/model.dart": await File(
        "test/golden/flumepod/family_notifier/model.dart",
      ).readAsString(),
    },
  );
}
