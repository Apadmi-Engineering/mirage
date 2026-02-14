First off, thank you for taking the time to contribute! 🙌

# Tree Hygiene

We are using [GitFlow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) with feature branches.

# Versioning

This project uses semantic versioning, read [here](https://semver.org/) for more info. 

We are following the convention set out in the main Flutter SDK repository when it comes to what counts as a breaking change. The primary take away is that any change that breaks the current set of unit tests is considered a breaking change.

# Testing

This project is currently tested in a few ways to take both a fine-grained and holistic approach.

* Unit tests - Located in `test/unit`.
* Integration tests - Located in `test/integration`, these tests utilise the `build_test` package for code resolution and in-memory builds.
* Golden tests - Located in `test/golden`, these take Dart code as an input and verify it against a reference output.

Running these all these tests locally before submission is recommended to catch any regressions.

## Running tests

Included in the project, there are a number of pre-configured test run configurations for Intellij (& Android Studio). Using these run configurations has the benefit of being able to use IDE tooling for debugging tests.

Alternatively, instructions for running the tests via command line follow. Due to the use of the `dart:mirrors` package, unit tests cannot be executed under Flutter (which disables introspection for performance). As such, you'll want to run the unit tests with Dart:

```shell
dart test test/unit
```

As implied above, the integration/golden tests need to utilise `build_runner` in order to use in-memory builds. Conveniently, `build_runner` provides a wrapper to orchestrate this, just use the following commands.

```shell
dart run build_runner test -- test/integration
dart run build_runner test -- test/golden
```