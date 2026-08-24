import 'package:flumepod/flumepod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import './model.dart';

part 'input.g.dart';

@Flumepod(providerTypesToMock: {TestNotifier})
void main() {}

@Riverpod(keepAlive: true)
class TestNotifier extends _$TestNotifier {
  // Custom model to catch regression of #21.
  @override
  String build(Model param) {
    return "Dummy string";
  }

  void _privateMethod() {

  }

  String someMethod() {
    return "A different string";
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
