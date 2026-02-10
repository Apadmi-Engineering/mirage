import 'dart:io';

import 'package:build_test/build_test.dart';
import 'package:flumepod/src/builder.dart';
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
        final readerWriter = TestReaderWriter(rootPackage: "flumepod");
        await readerWriter.testing.loadIsolateSources();
        await testBuilder(
          FlumepodBuilder(),
          {
            "flumepod|test/input.dart": inputSource,
            "flumepod|test/input.g.dart": generatedSource,
            "flumepod|test/input.flumepod.dart": expectedSource,
          },
          generateFor: {"flumepod|test/input.dart"},
          outputs: {
            "flumepod|test/input.flumepod.dart": expectedSource,
          },
          readerWriter: readerWriter,
        );
      },
    );
