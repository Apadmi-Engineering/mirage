## 1.0.0-dev.2

* Upgrades dependencies.
* Minimum Dart SDK version is now `3.11.0`.

## 1.0.0-dev.1

* Fixes an issue where generic type arguments weren't correctly resolved in generated notifiers. [#14](https://github.com/Apadmi-Engineering/mirage/issues/14).
* Updates `CONTRIBUTING.md`.

## 1.0.0-dev.0

* Adds support for Riverpod version 3.X.

## 0.4.1

* Fixes an issue where implementations of sealed types were being generated, leading to compilation errors

## 0.4.0

* Refactors fake type generation to remove `MetaType` in favour of `Element`.

## 0.3.0

* Re-writes package using the `code_builder` package for a opinionated, type-safe API.
* Improves handling of imports by using aliases 
* Add example project.

## 0.2.0

* Adds support for generating mocks of Notifiers with parameters (a.k.a. families).

## 0.1.1

* **fix:** Fixes version name.

## 0.1.0

* **feat:** Initial version to generate mocks of notifiers without parameters.
