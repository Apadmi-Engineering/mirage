import 'package:code_builder/code_builder.dart';
import 'package:mirage/src/util/block_builder_utils.dart';
import 'package:test/test.dart';

void main() {
  group("Block builder utils unit tests", () {
    test("addStaticCode - adds expected code to statements", () {
      // Setup
      final sut = BlockBuilder();

      // Run test
      sut.addStaticCode("void main() {}");

      // Verify
      expect(
        sut.statements.build().toList(),
        isA<List<Code>>()
            .having(
              (list) => list.first.toString(),
              "Expected statement contents",
              "void main() {}",
            )
            .having(
              (list) => list.length,
              "Expected length",
              1,
            ),
      );
    });

    test("addCode - adds expected code to statements", () {
      // Setup
      final sut = BlockBuilder();

      // Run test
      sut.addCode(
          const Code("Future<void> doSomething(String param) async {}"));

      // Verify
      expect(
        sut.statements.build().toList(),
        isA<List<Code>>()
            .having(
              (list) => list.first.toString(),
              "Expected contents",
              "Future<void> doSomething(String param) async {}",
            )
            .having(
              (list) => list.length,
              "Expected length",
              1,
            ),
      );
    });
  });
}
