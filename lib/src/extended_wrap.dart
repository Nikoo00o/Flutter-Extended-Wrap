import 'package:flutter/material.dart';
import 'package:flutter_extended_wrap/src/extended_wrap_alignment.dart';

/// This is a wrapper around the default [Wrap] widget which provides the additional options to expand the wrap to
/// the full size of the parent and either
///
/// align the children of each run to the left and right with free space put between them,
///
/// or align the children of each run in the center with the free space being put at the left and right,
///
/// or other alignments from [ExtendedWrapAlignment].
///
/// Additionally this [ExtendedWrap] will try to put an equal amount of children on each run which the default [Wrap]
/// does not do. You can also specify how many children should be put on each run.
///
/// Look at the additional properties [expandWrap], [extendedWrapAlignment] and [desiredChildrenPerRun].
///
/// Every [children] needs to be the size of [childSizeInDirection] in the [direction]!
// Using a custom render object would lead to better performance, but is harder to maintain
class ExtendedWrap extends StatelessWidget {
  /// The main axis for the wrap runs to place the children on.
  ///
  /// See [Wrap.direction]
  final Axis direction;

  /// How to align the children of the wrap and where to put the free space on the main axis within a run.
  ///
  /// This is also used for [Wrap.alignment].
  ///
  /// Look at [ExtendedWrapAlignment] to see the additional options that extend [WrapAlignment]. Most of these only
  /// work if [expandWrap] is true, so that the free space can be distributed!
  final ExtendedWrapAlignment extendedWrapAlignment;

  /// The space between children elements of the wrap.
  ///
  /// See [Wrap.spacing]
  final double spacing;

  /// The space between the runs of the wrap.
  ///
  /// See [Wrap.runSpacing]
  final double runSpacing;

  /// How the runs themselves should be placed in the cross axis.
  ///
  /// See [Wrap.runAlignment]
  final WrapAlignment runAlignment;

  /// How the children within a run should be aligned relative to each other in
  /// the cross axis.
  ///
  /// See [Wrap.crossAxisAlignment]
  final WrapCrossAlignment crossAxisAlignment;

  /// Determines the order to lay children out horizontally and how to interpret
  /// `start` and `end` in the horizontal direction.
  ///
  /// See [Wrap.textDirection]
  final TextDirection? textDirection;

  /// Determines the order to lay children out vertically and how to interpret
  /// `start` and `end` in the vertical direction.
  ///
  /// See [Wrap.verticalDirection]
  final VerticalDirection verticalDirection;

  /// See [Wrap.clipBehavior]
  final Clip clipBehavior;

  /// The exact size of every children element of this wrap in the axis of the direction.
  ///
  /// if the [direction] is [Axis.horizontal], then this is the width of the children.
  ///
  /// if the [direction] is [Axis.vertical], then this is the height of the children.
  final double childSizeInDirection;

  /// If the wrap should expand to fill the parent space in its [direction] axis
  final bool expandWrap;

  /// If the wrap should try to put an equal amount of children on each run.
  ///
  /// Important: if the available space would not be enough to fit [desiredChildrenPerRun] on each run, then the
  /// wrap will automatically try to use a smaller number instead.
  ///
  /// If this is null, then the special options of [extendedWrapAlignment] will only really work on the last run if
  /// it would have space for more children.
  final int? desiredChildrenPerRun;

  /// This is used to control how many children are put into each run so that this free space requirement is reached!
  ///
  /// For example when using [ExtendedWrapAlignment.center] this controls the size of the free space in the middle of
  /// each run!
  final double minFreeSpacePerRun;

  /// The elements that are put along the runs of this wrap which all have to be exactly the size of
  /// [childSizeInDirection]. These will be used for [Wrap.children]
  final List<Widget> children;

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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final Widget wrap = _buildWrap(_isHorizontal ? constraints.maxWidth : constraints.maxHeight);
      return _expandWrap(wrap);
    });
  }

  Widget _expandWrap(Widget wrap) {
    if (expandWrap) {
      return _directionSizedBox(size: double.infinity, child: wrap);
    } else {
      return wrap;
    }
  }

  Widget _buildWrap(double wrapSizeInDirection) {
    final int maxChildrenCountPerRun = getMaxChildrenCountPerRun(wrapSizeInDirection);
    final int minRunCount = getMinRunCount(maxChildrenCountPerRun);
    final (int actualChildrenPerRun, bool? additionalChildOnExistingRun) = getEqualChildrenPerRun(
      maxChildrenCountPerRun: maxChildrenCountPerRun,
      minRunCount: minRunCount,
    );
    final int actualRunCount = getActualRunCount(
      actualChildrenPerRun: actualChildrenPerRun,
      additionalChildOnExistingRun: additionalChildOnExistingRun,
    );

    final List<Widget> finalChildren = List<Widget>.empty(growable: true);
    for (int run = 0; run < actualRunCount; ++run) {
      final bool onlyOneRun = actualRunCount == 1;
      final bool isLastRun = run == actualRunCount - 1;

      late final int childrenCountOfRun;
      if (additionalChildOnExistingRun != null && isLastRun) {
        childrenCountOfRun = additionalChildOnExistingRun ? actualChildrenPerRun + 1 : 1;
      } else {
        childrenCountOfRun = actualChildrenPerRun;
      }
      final bool onlyOneChild = childrenCountOfRun == 1;

      late final double freeSpaceInRun;
      if (expandWrap == true) {
        freeSpaceInRun = getFreeSpaceInRun(wrapSizeInDirection, childrenCountOfRun) -
            _getSpacingForAlignment(onlyOneRun: onlyOneRun, onlyOneChild: onlyOneChild);
      } else {
        freeSpaceInRun = 0.0;
      }

      _buildRun(
        childrenCountOfRun: childrenCountOfRun,
        currentRun: run,
        freeSpaceInRun: freeSpaceInRun,
        onlyOneRun: onlyOneRun,
        childrenBefore: actualChildrenPerRun * run,
        finalChildren: finalChildren,
      );
    }

    return Wrap(
      direction: direction,
      alignment: _convertAlignment(extendedWrapAlignment),
      spacing: spacing,
      runSpacing: runSpacing,
      runAlignment: runAlignment,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      clipBehavior: clipBehavior,
      children: finalChildren,
    );
  }

  void _buildRun({
    required int childrenCountOfRun,
    required int currentRun,
    required double freeSpaceInRun,
    required bool onlyOneRun,
    required int childrenBefore,
    required List<Widget> finalChildren,
  }) {
    for (int child = 0; child < childrenCountOfRun; ++child) {
      final bool isFirstChildOfRun = child == 0;
      final bool isLastChildOfRun = child == childrenCountOfRun - 1;

      double freeSpaceBefore = 0.0;
      double freeSpaceAfter = 0.0;

      if (isFirstChildOfRun) {
        if (extendedWrapAlignment == ExtendedWrapAlignment.end) {
          freeSpaceBefore = freeSpaceInRun;
        } else if (_shouldPutSpaceAround(onlyOneRun: onlyOneRun)) {
          freeSpaceBefore = freeSpaceInRun / 2;
        } else if (extendedWrapAlignment == ExtendedWrapAlignment.spaceAround) {
          freeSpaceBefore = freeSpaceInRun / 2 / 2; // if there is not enough space for this, the layout will not be
          // perfectly spaced!
        }
      }

      if (_shouldPutSpaceInCenter(onlyOneRun: onlyOneRun)) {
        if (child == childrenCountOfRun / 2) {
          freeSpaceBefore = freeSpaceInRun;
        } else if (childrenCountOfRun == 1) {
          freeSpaceBefore = freeSpaceInRun / 2; // special case if only one child
          freeSpaceAfter = freeSpaceInRun / 2;
        }
      }

      if (isLastChildOfRun) {
        if (extendedWrapAlignment == ExtendedWrapAlignment.start) {
          freeSpaceAfter = freeSpaceInRun; // if only 1 child, then its first and last!
        } else if (_shouldPutSpaceAround(onlyOneRun: onlyOneRun)) {
          freeSpaceAfter = freeSpaceInRun / 2;
        } else if (extendedWrapAlignment == ExtendedWrapAlignment.spaceAround) {
          freeSpaceAfter = freeSpaceInRun / 2 / 2;
        }
      }

      // alignments between children
      if (extendedWrapAlignment == ExtendedWrapAlignment.spaceBetween) {
        if (isFirstChildOfRun == false) {
          freeSpaceBefore = freeSpaceInRun / (childrenCountOfRun - 1) - spacing;
        }
      } else if (extendedWrapAlignment == ExtendedWrapAlignment.spaceAround) {
        if (isFirstChildOfRun == false) {
          freeSpaceBefore = freeSpaceInRun / 2 / (childrenCountOfRun - 1) - spacing;
        }
      } else if (extendedWrapAlignment == ExtendedWrapAlignment.spaceEvenly) {
        // also includes before and after children
        final double spaceToUse = freeSpaceBefore = freeSpaceInRun / (childrenCountOfRun - 1 + 2) - spacing;
        freeSpaceBefore = spaceToUse;
        if (isLastChildOfRun) {
          freeSpaceAfter = spaceToUse;
        }
      }

      if (freeSpaceBefore > 0.001) {
        finalChildren.add(_directionSizedBox(size: freeSpaceBefore));
      }
      finalChildren.add(_wrapChild(childrenBefore + child));
      if (freeSpaceAfter > 0.001) {
        finalChildren.add(_directionSizedBox(size: freeSpaceAfter));
      }
    }
  }

  /// Returns the number of [children] of [childSizeInDirection] that can fit on one run with the [spacing] and the
  /// [minFreeSpacePerRun]
  int getMaxChildrenCountPerRun(double wrapSizeInDirection) {
    double availableSpace = wrapSizeInDirection - minFreeSpacePerRun;
    if (availableSpace <= 0.001) {
      assert(availableSpace > 0.001, "min free space per run is too big and will be ignored in release");
      availableSpace = wrapSizeInDirection;
    }
    int childrenPerRun = availableSpace ~/ (childSizeInDirection + spacing);
    while (childrenPerRun * spacing + (childrenPerRun + 1) * childSizeInDirection <= availableSpace) {
      childrenPerRun += 1;
    }

    if (childrenPerRun <= 0) {
      assert(childrenPerRun > 0, "extended wrap does not have enough space for at least one child on each run");
      return 1;
    }
    return childrenPerRun;
  }

  /// Returns the number of runs that are needed to fit all [children].
  ///
  /// [maxChildrenCountPerRun] should be [getMaxChildrenCountPerRun]
  int getMinRunCount(int maxChildrenCountPerRun) => (_childrenCount / maxChildrenCountPerRun).ceil();

  /// Returns the amount of children that are desired to be put into each run (not equally distributed yet) which
  /// will not be bigger than [maxChildrenCountPerRun] and [_childrenCount].
  ///
  /// [maxChildrenCountPerRun] should be [getMaxChildrenCountPerRun]
  int _clampDesiredChildrenPerRun(int maxChildrenCountPerRun) {
    int desiredChildrenPerRun = this.desiredChildrenPerRun ?? 99999999999;
    if (desiredChildrenPerRun > maxChildrenCountPerRun) {
      desiredChildrenPerRun = maxChildrenCountPerRun;
    }
    if (desiredChildrenPerRun > _childrenCount) {
      desiredChildrenPerRun = _childrenCount;
    }
    return desiredChildrenPerRun;
  }

  /// Returns the equally distributed amount of children that should be put into each run.
  ///
  /// Important: if the [_childrenCount] is a higher prime number (or if the [ExtendedWrapAlignment.spaceCenter]
  /// [extendedWrapAlignment] is used and the [_childrenCount] can not be divided through an even number), this will
  /// return true as the second part and the last run will contain an additional element.
  /// If this returns false, then a new additional run is needed to contain an additional element!
  /// Otherwise the second part is returned as null
  ///
  /// [maxChildrenCountPerRun] should be [getMaxChildrenCountPerRun] and [minRunCount] should be [getMinRunCount]
  ///
  /// [childrenCountOverride] can be [_childrenCount] which is used when this method calls itself.
  (int, bool?) getEqualChildrenPerRun({
    required int maxChildrenCountPerRun,
    required int minRunCount,
    int? childrenCountOverride,
  }) {
    final int clampedChildrenPerRun = _clampDesiredChildrenPerRun(maxChildrenCountPerRun);
    final int childrenCount = childrenCountOverride ?? _childrenCount;
    final bool wasPrime = childrenCountOverride != null;
    final bool isSpaceCenter = extendedWrapAlignment == ExtendedWrapAlignment.spaceCenter ||
        (extendedWrapAlignment == ExtendedWrapAlignment.spaceCenterOrAround && minRunCount == 1);
    if (clampedChildrenPerRun == 1 || childrenCount == 3) {
      return (1, null); // special case if only one child can fit on each run, or if there are
      // only 3 children
    }
    for (int desiredChildrenPerRun = clampedChildrenPerRun; desiredChildrenPerRun > 1; desiredChildrenPerRun--) {
      if (childrenCount % desiredChildrenPerRun == 0 && (isSpaceCenter == false || desiredChildrenPerRun.isEven)) {
        final bool lastLineHasSpaceForElement =
            desiredChildrenPerRun <= maxChildrenCountPerRun - 1 && isSpaceCenter == false;
        return (desiredChildrenPerRun, wasPrime ? lastLineHasSpaceForElement : null); // try a lower amount of
        // children per run until it is a divisor of the children count, but don't return 1!
      }
    }

    return getEqualChildrenPerRun(
      maxChildrenCountPerRun: clampedChildrenPerRun,
      minRunCount: minRunCount,
      childrenCountOverride: childrenCount - 1,
    ); //if children count is a higher prime number, use a lower children count
  }

  /// Returns the number of runs that are needed to fit all [children] if each run receives [getEqualChildrenPerRun]
  /// children.
  ///
  /// [actualChildrenPerRun] and [additionalChildOnExistingRun] should be from [getEqualChildrenPerRun]
  int getActualRunCount({required int actualChildrenPerRun, required bool? additionalChildOnExistingRun}) {
    int count = _childrenCount ~/ actualChildrenPerRun;
    if (additionalChildOnExistingRun == false) {
      count += 1;
    }
    return count;
  }

  /// Returns the available space in the run of [wrapSizeInDirection] size with [childrenAmount] children
  double getFreeSpaceInRun(double wrapSizeInDirection, int childrenAmount) {
    final double requiredSpace = (childrenAmount - 1) * spacing + childrenAmount * childSizeInDirection;
    return wrapSizeInDirection - requiredSpace;
  }

  WrapAlignment _convertAlignment(ExtendedWrapAlignment extendedWrapAlignment) => switch (extendedWrapAlignment) {
    ExtendedWrapAlignment.start => WrapAlignment.start,
    ExtendedWrapAlignment.end => WrapAlignment.end,
    ExtendedWrapAlignment.center => WrapAlignment.center,
    ExtendedWrapAlignment.spaceBetween => WrapAlignment.spaceBetween,
    ExtendedWrapAlignment.spaceAround => WrapAlignment.spaceAround,
    ExtendedWrapAlignment.spaceEvenly => WrapAlignment.spaceEvenly,
    ExtendedWrapAlignment.spaceCenter => WrapAlignment.spaceAround,
    ExtendedWrapAlignment.spaceCenterOrAround => WrapAlignment.spaceAround,
  };

  /// Checks the alignment for free space placement
  bool _shouldPutSpaceAround({required bool onlyOneRun}) =>
      extendedWrapAlignment == ExtendedWrapAlignment.center ||
          (extendedWrapAlignment == ExtendedWrapAlignment.spaceCenterOrAround && onlyOneRun == false);

  /// Checks the alignment for free space placement
  bool _shouldPutSpaceInCenter({required bool onlyOneRun}) =>
      extendedWrapAlignment == ExtendedWrapAlignment.spaceCenter ||
          (extendedWrapAlignment == ExtendedWrapAlignment.spaceCenterOrAround && onlyOneRun);

  /// Checks the alignment to see which spacing must be substracted from the free space, because the wrap will
  /// automatically add it
  double _getSpacingForAlignment({required bool onlyOneRun, required bool onlyOneChild}) {
    switch (extendedWrapAlignment) {
      case ExtendedWrapAlignment.start:
      case ExtendedWrapAlignment.end:
        return spacing;
      case ExtendedWrapAlignment.spaceCenter:
        return onlyOneChild? spacing * 2 : spacing;
      case ExtendedWrapAlignment.center:
      case ExtendedWrapAlignment.spaceBetween:
      case ExtendedWrapAlignment.spaceAround:
      case ExtendedWrapAlignment.spaceEvenly:
        return spacing * 2;
      case ExtendedWrapAlignment.spaceCenterOrAround:
        return onlyOneRun == false ? spacing * 2 : spacing;
    }
  }

  /// Wraps the original child of [children] at [index] with a SizedBox so that it has the correct size in the
  /// [direction]
  Widget _wrapChild(int index) {
    if (index >= children.length) {
      assert(index < children.length, "index is bigger than length of children");
      return const SizedBox();
    }
    return _directionSizedBox(size: childSizeInDirection, child: children.elementAt(index));
  }

  Widget _directionSizedBox({required double size, Widget? child}) {
    return SizedBox(
      width: _isHorizontal ? size : null,
      height: _isHorizontal ? null : size,
      child: child,
    );
  }

  /// Main axis direction of the wrap
  bool get _isHorizontal => direction == Axis.horizontal;

  /// Total number of the original children
  int get _childrenCount => children.length;
}
