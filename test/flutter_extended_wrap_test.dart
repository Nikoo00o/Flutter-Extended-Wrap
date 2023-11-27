import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_extended_wrap/flutter_extended_wrap.dart';

void main() {
  test('test max children count per run', () {
    const ExtendedWrap extendedWrap =
        ExtendedWrap(childSizeInDirection: 50, spacing: 10, minFreeSpacePerRun: 100, children: <Widget>[]);
    int manyMaxChildren = extendedWrap.getMaxChildrenCountPerRun(500);
    expect(manyMaxChildren, 6, reason: "should be 6");
    manyMaxChildren = extendedWrap.getMaxChildrenCountPerRun(1378);
    expect(manyMaxChildren, 21, reason: "should be 21");
    int fewMaxChildren = extendedWrap.getMaxChildrenCountPerRun(200);
    expect(fewMaxChildren, 1, reason: "should be 1");
    fewMaxChildren = extendedWrap.getMaxChildrenCountPerRun(150);
    expect(fewMaxChildren, 1, reason: "should still be 1");
    expect(() => extendedWrap.getMaxChildrenCountPerRun(140), throwsA((Object e) => e is AssertionError));
  });
  // todo: many more tests could follow here in the future...
}
