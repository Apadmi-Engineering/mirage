import 'package:mockito/mockito.dart';

extension InlineStubbing<T> on T {
  void stubReturn<S>(S Function(T) invocation, S stub) =>
      when(invocation(this)).thenReturn(stub);
}

class Lazy<T> {
  T? _instance;
  final T Function() _create;
  
  Lazy(this._create);
  
  T call() {
    _instance ??= _create();
    return _instance!;
  }
}