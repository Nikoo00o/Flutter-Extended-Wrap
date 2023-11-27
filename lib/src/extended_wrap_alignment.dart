import 'package:flutter/material.dart';

/// Contains the default options of [WrapAlignment],
/// but also additionally [spaceCenter] and [spaceCenterOrAround]
/// which can be used to align the children of an [ExtendedWrap] in the runs!
enum ExtendedWrapAlignment {
  /// Place the objects as close to the start of the axis as possible like [WrapAlignment.start]
  start,

  /// Place the objects as close to the end of the axis as possible like [WrapAlignment.end]
  end,

  /// Place the objects as close to the middle of the axis as possible like [WrapAlignment.center]
  ///
  /// The free space will be put at the edges of the run
  center,

  /// Place the free space evenly between the objects like [WrapAlignment.spaceBetween]
  spaceBetween,

  /// Place the free space evenly between the objects as well as half of that
  /// space before and after the first and last objects like [WrapAlignment.spaceAround]
  spaceAround,

  /// Place the free space evenly between the objects as well as before and
  /// after the first and last objects like [WrapAlignment.spaceEvenly]
  spaceEvenly,

  /// Put all of the free space at the center of the run and put the same amount of children at both sides
  spaceCenter,

  /// If all children fit onto the first run with free space remaining, then this will put the free space at the
  /// center with half of the children on both sides like [spaceCenter] does.
  ///
  /// But if some children would be put on the second run, then each run receives half of the children and the free
  /// space on both runs is put around the children elements instead like [center] does!
  spaceCenterOrAround,
}
