import 'dart:io';

import 'package:build_test/build_test.dart';
import 'package:mirage/src/builder.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

@isTest
void testGoldenBuilder(
  String description,
  String inputPath,
  String generatedPartPath,
  String expectedPath,
) =>
    test(
      description,
      () async {
        final inputSource = await (File(inputPath).readAsString());
        final generatedSource = await (File(generatedPartPath).readAsString());
        final expectedSource = await (File(expectedPath).readAsString());
        final readerWriter = TestReaderWriter(rootPackage: "mirage");
        await readerWriter.testing.loadIsolateSources();
        await testBuilder(
          MirageBuilder(),
          {
            "mirage|test/input.dart": inputSource,
            "mirage|test/input.g.dart": generatedSource,
            "mirage|test/input.mirage.dart": expectedSource,
          },
          generateFor: {"mirage|test/input.dart"},
          outputs: {
            "mirage|test/input.mirage.dart": expectedSource,
          },
          readerWriter: readerWriter,
        );
      },
    );
