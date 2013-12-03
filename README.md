# Dart Widgets
### A set of reusable Polymer Components for Dart applications

[![Build Status](https://drone.io/github.com/dart-lang/widget.dart/status.png)](https://drone.io/github.com/dart-lang/widget.dart/latest)

## Polymer.dart

**Dart Widgets** leverages the [Polymer](https://www.dartlang.org/polymer-dart/) Dart project. **Polymer** is in development.

## Conventions

* All components live in `lib/components`
* Components has a class name `FooWidget` with a corresponding element name `foo-widget`.
    * File names correspond to Dart convention: `foo.[dart|html]`

## Running in Dartium

* At the moment, a Chrome flag must be set to enable some features
    * <chrome://flags/#enable-experimental-web-platform-features>
    * Needed for Chrome 31. Not sure when this will be mainstreamed.
    * Used for `::content` style selectors in:
        * Tab

## Versioning

Our goal is to follow [Semantic Versioning](http://semver.org/).

_Note: we have not released v1 (yet)._

## Authors
 * [Kevin Moore](https://github.com/kevmoo) ([@kevmoo](http://twitter.com/kevmoo))
 * _You? File bugs. Fork and Fix bugs._
