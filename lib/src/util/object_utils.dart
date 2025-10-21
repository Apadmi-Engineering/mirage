extension ObjectUtils<T extends Object> on T {
  S let<S>(S Function(T it) transform) => transform(this);
}