First off, thank you for taking the time to contribute! 🙌

# Tree Hygiene

We are using [GitFlow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) with feature branches.

# Versioning

This project uses semantic versioning with version 1.0 being reserved for a possible public pub.dev release in future. As such, treat increments in the "minor version" as breaking changes (i.e. 0.X.0).

We are following the convention set out in the main Flutter SDK repository when it comes to what counts as a breaking change. The primary take away is that any change that breaks the current set of unit tests is considered a breaking change.

# Testing

This project is currently tested in a couple of ways to take both a fine-grained and holistic approach.

* Unit tests - Located in `test/unit`.
* Golden tests - Located in `test/golden`, these take Dart code as an input and verify it against a reference output.

If you are having an issue in a package that consumes this package, I would recommend contributing another golden test scenario that replicates your requirement.

## Running tests

Due to the use of the `dart:mirrors` package, unit tests cannot be executed under Flutter (which disables introspection for performance). As such, you'll want to run the unit tests with Dart:

```shell
dart test test/unit
```

As implied above, the golden tests need to use `build_runner` in order to verify the output of the code generator. Conveniently, `build_runner` provides a wrapper to orchestrate this, just use the following command.

```shell
dart run build_runner test test/golden
```