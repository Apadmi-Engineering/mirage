import 'package:flumepod/src/util/object_utils.dart';
import 'package:test/test.dart';

void main() {
  group("Object utils unit tests", () {
    test("takeIf - predicate holds - returns receiver", () {
      final receiver = 42;

      expect(receiver.takeIf(true), 42);
    });

    test("takeIf - predicate fails - returns null", () {
      final receiver = 42;

      expect(receiver.takeIf(false), null);
    });

    test("let - returns transformed receiver", () {
      final receiver = 42;

      expect(receiver.let((it) => it * 2), 84);
    });
  });
}