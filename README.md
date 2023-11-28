# Flutter Extended Wrap

## Install

### pubspec.yaml

Update pubspec.yaml and add the following line to your dependencies to import the 
[package](https://pub.dev/packages/flutter_extended_wrap) from pub.dev:

```yaml
dependencies:
  flutter_extended_wrap: ^0.0.3
```

## Import

Import the package with:

```dart
import 'package:flutter_extended_wrap/flutter_extended_wrap.dart';
```

## Features

With the extended Wrap you can automatically make a default Flutter Wrap expand to its parent size and then you can 
specify how many children a Wrap should put on each run. Additionally you have some options to customize where the free 
space is put like for example placing the children on both sides with the free space in the center of the Wrap. 

### Types

```dart
class ExtendedWrap {
  const ExtendedWrap({
    super.key,
    this.direction = Axis.horizontal,
    this.extendedWrapAlignment = ExtendedWrapAlignment.center,
    this.spacing = 0.0,
    this.runSpacing = 0.0,
    this.runAlignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.clipBehavior = Clip.none,
    required this.childSizeInDirection,
    this.expandWrap = true,
    this.desiredChildrenPerRun,
    this.minFreeSpacePerRun = 0.0,
    required this.children,
  });
}


enum ExtendedWrapAlignment {
  start,
  end,
  center,
  spaceBetween,
  spaceAround,
  spaceEvenly,
  spaceCenter,
  spaceCenterOrAlignCenter,
  spaceCenterAndAround
}
```

## Usage

You can find an example on how to use different configurations of the expanded Wrap inside of the `/example` folder 
which displays the following: 

![Example](https://raw.githubusercontent.com/Nikoo00o/Flutter-Extended-Wrap/main/example/example.png)

## Changelog

[CHANGELOG.md](CHANGELOG.md)