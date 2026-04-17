extension ObjectUtils<T extends Object> on T {
  T? takeIf(bool predicate) => switch(predicate) {
    true => this,
    false => null,
  };

  S let<S>(S Function(T it) transform) => transform(this);
}