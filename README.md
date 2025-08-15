<p align="center">
    <img src="./assets/mark.png" height=100 width=404>
</p>

A generator for creating [mockito](https://pub.dev/packages/mockito) mocks of [Riverpod](https://riverpod.dev/) notifiers for use in unit testing.

## Why is this needed?

Three parts of a good unit test are:

- **Setup**  - Create the context for your unit test by stubbing dependencies.
- **Act** - Interact with your `sut` (System Under Test) in some way.
- **Verify** - Assert the results of **act** either by checking outputs or 
expecting interactions with other entities.

Riverpod's core unit test offering makes the above cumbersome and error-prone when 
using Notifiers. That's where this package comes in, it attempts to be a solution 
to generate Mockito mocks of Riverpod Notifiers in a way that allows for...

- Stubbing
- Argument matchers
- Verifications

## How do I install it?

Flutter’s pub package manager supports dependencies sourced directly from Git repos with various options to reference specific commits.
```
dependencies:
  some_dependency:
    git:
      url: git@github.com:Apadmi-Engineering/Mirage.git
      ref: <Optional, commit ref/tag/branch HEAD>
```

## How do I use it?

Hopefully in a manner similar to normal usage of Mockito.

Add the `@GenerateMirage` annotation on the `main` method in your unit test file, 
this annotation takes a single argument, `providerTypesToMock`. The value should 
be a `Set` of `Type`s that are providers.

For example...

`my_notifier.dart`
```dart
class MyNotifier extends _$MyNotifier {
    @override
    FutureOr<State> build() async {
        return state;
    }

    void performSideEffect(Object someArg) async {
        // Do something
    }
}
```

Generating a mock of `MyNotifier` in a unit test would look like...

`my_other_notifier_test.dart`
```dart
@GenerateMirage(providerTypesToMock: {MyNotifier})
void main() async {

    test("My test", () async {
        // Override provider with mock instance.
        final container = createContainer(
            overrides: [
                myNotifierProvider.overrideWith(MockMyNotifier(() => initialState))
            ]
        );

        // To stub (with arg matchers).
        final myNotifier = container.read(myNotifierProvider.notifier) as MockMyNotifier;
        when(myNotifier.performSideEffect(any)).thenAnswer((_) async {});

        // Test something here.

        // Verify (with arg matchers).
        verify(myNotifier.performSideEffect(any)).called(1);
    });
}
```

Mocks are generated in the usual way with `dart run build_runner build`, or if you're 😎, `dart run build_runner watch`.

## Considerations

### Stubbing and verifications

You'll need to obtain the instance of your mocked provider through the provider container (as in the above example) to ensure you are stubbing and verifying upon the *same instance*.

### Argument matchers

To use argument matchers such as `any`, `anyNamed`; you'll need to obtain the instance of your notifier by reading the provider container and then casting it as the mock class.

```dart
container.read(myNotifier.notifier) as MockMyNotifier
```

This is because Mockitos argument matchers are nullable, however the parameters contained in the interface of your notifier probably aren't. Mirage solves this by making all parameters in mock classes nullable. However, when you read your notifier from the provider container, you read it "as" the original interface. Hence, the need to cast it as the mocked version (because it is).

## Problems

If something isn't working, preferably report it [here](https://github.com/Apadmi-Engineering/mirage/issues). Contributions are welcome!