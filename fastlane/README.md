fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

### build_for_testing

```sh
[bundle exec] fastlane build_for_testing
```

Build for testing only, does not run tests. Project be cleaned before building!

### custom_run_tests

```sh
[bundle exec] fastlane custom_run_tests
```

Run test without cleaning project.

### build_and_test

```sh
[bundle exec] fastlane build_and_test
```

Build and run test.

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
