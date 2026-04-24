## 1.1.0

 - **FIX**: use the generated token to push tags, and align all the other workflows ([#37](https://github.com/Apadmi-Engineering/mirage/issues/37)). ([003b45a6](https://github.com/Apadmi-Engineering/mirage/commit/003b45a65364062caf8cd44400e340de58eb99b9))
 - **FEAT**: Implement support for record return types from generated methods ([#28](https://github.com/Apadmi-Engineering/mirage/issues/28)). ([46eb0e8f](https://github.com/Apadmi-Engineering/mirage/commit/46eb0e8fc54ea84f58911a51454cb2364df5f39c))
 - **FEAT**: Implement support for getter property accessors ([#27](https://github.com/Apadmi-Engineering/mirage/issues/27)). ([d0169b69](https://github.com/Apadmi-Engineering/mirage/commit/d0169b6986608a16797aa99e19b4150a7c0e3aa4))
 - **DOCS**: Add doc-string comments to `Flumepod` annotation ([#33](https://github.com/Apadmi-Engineering/mirage/issues/33)). ([7a8fc759](https://github.com/Apadmi-Engineering/mirage/commit/7a8fc759bfb73d3eac4214432a98a661bb3514b6))

## 1.0.0

* Fixes an issue where notifier class family argument symbols weren't being resolved and prefixed with imports ([#21](https://github.com/Apadmi-Engineering/mirage/issues/21)).
* Fixes an issue where notifiers would sometimes be destroyed part way through tests ([#24](https://github.com/Apadmi-Engineering/mirage/issues/24)).
* Relaxes Dart SDK version constraint to `^3.9.0`.

## 1.0.0-dev.3

* Updates `pubspec.yaml` for publishing to pub.dev.
* Removes unwanted files from published package.

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
