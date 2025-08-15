import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifier.g.dart';

@Riverpod(keepAlive: true)
class DummySource extends _$DummySource {
  @override
  Future<int> build(int param) async {
    return param * param;
  }

  Future<void> someSideEffect() async {}
}

@riverpod
class DummyNotifier extends _$DummyNotifier {
  @override
  Future<int> build(int param) async {
    await ref.read(dummySourceProvider(param).notifier).someSideEffect();
    return ref.watch(dummySourceProvider(param).future);
  }
}