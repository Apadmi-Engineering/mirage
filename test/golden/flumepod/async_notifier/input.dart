import 'package:flumepod/flumepod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:convert';

part 'input.g.dart';

@Flumepod(providerTypesToMock: {TestNotifier})
void main() {}

@Riverpod(keepAlive: true)
class TestNotifier extends _$TestNotifier {
  // Use of a `dart:convert` class to catch regression of #57.
  @override
  FutureOr<(Codec, String)> build() async {
    return (Codec(), "Dummy string");
  }

  void _privateMethod() {

  }

  ({String a, String b}) someMethod() {
    return (a: "A different string", b: "A different string");
  }

  Future<int> someAsyncMethod() async {
    return 42;
  }

  void sideEffect() {
    return;
  }

  Future<void> asyncSideEffect() async {
    return;
  }
}
