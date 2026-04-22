/// An annotation to direct Flumepod to create mocks of notifier classes.
///
/// When executing the code generation, Flumepod will generate mock classes
/// with the name `Mock{className}` in `{fileName}.flumepod.dart`. You can
/// then override the provider in the `ProviderContainer` during testing.
///
/// Generated classes implement the base interface however parameters in
/// methods are nullable, this allows one to use mockito's argument matchers.
/// One consideration when doing this is to make sure you cast the instance
/// of the notifier as the mocked interface when reading it from the
/// `ProviderContainer` as follows...
///
/// ```dart
/// final mockNotifier = container.read(myNotifier.notifier)
///   as MockMyNotifier;
/// ```
class Flumepod {
  /// A set of notifier type references to mock.
  ///
  /// For instance, `@Flumepod(providerTypesToMock: {MyNotifier})`
  final Set<Type> providerTypesToMock;

  const Flumepod({required this.providerTypesToMock});
}
