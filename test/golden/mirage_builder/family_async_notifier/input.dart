import 'package:mirage/mirage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'input.g.dart';

@GenerateMirage(providerTypesToMock: {TestNotifier})
void main() {}

@Riverpod(keepAlive: true)
class TestNotifier extends _$TestNotifier {
  @override
  FutureOr<String> build(String param) async {
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
