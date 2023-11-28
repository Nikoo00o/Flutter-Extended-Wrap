import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extended_wrap/flutter_extended_wrap.dart';

void main() => runApp(const App());

class CustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => <PointerDeviceKind>{
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        scrollBehavior: CustomScrollBehavior(),
        home: Scaffold(body: _buildBody()));
  }

  Widget _buildBody() {
    final ScrollController controller =
        ScrollController(); // don't do this (bad practice)
    return Scrollbar(
      thumbVisibility: true,
      controller: controller,
      child: SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildWrapExamples(),
        ),
      ),
    );
  }

  List<Widget> _buildWrapExamples() {
    return <Widget>[
      ExtendedWrap(
        childSizeInDirection: 40,
        spacing: 10,
        extendedWrapAlignment: ExtendedWrapAlignment.spaceCenterOrAlignCenter,
        expandWrap: true,
        children: _createChildren(40, 40, Colors.blue, 8),
      ),
      ExtendedWrap(
        childSizeInDirection: 40,
        spacing: 10,
        extendedWrapAlignment: ExtendedWrapAlignment.spaceCenterOrAlignCenter,
        expandWrap: true,
        children: _createChildren(40, 40, Colors.red, 7),
      ),
      ExtendedWrap(
        childSizeInDirection: 40,
        spacing: 10,
        extendedWrapAlignment: ExtendedWrapAlignment.spaceCenter,
        minFreeSpacePerRun: 40,
        expandWrap: true,
        children: _createChildren(40, 40, Colors.green, 8),
      ),
      ExtendedWrap(
        childSizeInDirection: 40,
        spacing: 10,
        extendedWrapAlignment: ExtendedWrapAlignment.spaceCenter,
        expandWrap: true,
        children: _createChildren(40, 40, Colors.purple, 13),
      ),
      ExtendedWrap(
        childSizeInDirection: 40,
        spacing: 10,
        extendedWrapAlignment: ExtendedWrapAlignment.spaceCenter,
        expandWrap: true,
        desiredChildrenPerRun: 4,
        children: _createChildren(40, 40, Colors.orange, 8),
      ),
      ExtendedWrap(
        childSizeInDirection: 40,
        spacing: 10,
        extendedWrapAlignment: ExtendedWrapAlignment.start,
        expandWrap: true,
        desiredChildrenPerRun: 4,
        children: _createChildren(40, 40, Colors.blueGrey, 8),
      ),
      ExtendedWrap(
        childSizeInDirection: 40,
        spacing: 10,
        extendedWrapAlignment: ExtendedWrapAlignment.end,
        expandWrap: true,
        desiredChildrenPerRun: 6,
        children: _createChildren(40, 40, Colors.cyan, 7),
      ),
      ExtendedWrap(
        childSizeInDirection: 40,
        spacing: 10,
        extendedWrapAlignment: ExtendedWrapAlignment.center,
        expandWrap: true,
        children: _createChildren(40, 40, Colors.brown, 6),
      ),
      const SizedBox(height: 10),
      ExtendedWrap(
        childSizeInDirection: 40,
        spacing: 10,
        extendedWrapAlignment: ExtendedWrapAlignment.spaceAround,
        expandWrap: true,
        desiredChildrenPerRun: 4,
        children: _createChildren(40, 40, Colors.pink, 8),
      ),
      ExtendedWrap(
        childSizeInDirection: 40,
        spacing: 10,
        runSpacing: 5,
        extendedWrapAlignment: ExtendedWrapAlignment.spaceEvenly,
        expandWrap: true,
        desiredChildrenPerRun: 4,
        children: _createChildren(40, 40, Colors.lime, 8),
      ),
      ExtendedWrap(
        childSizeInDirection: 40,
        spacing: 10,
        runSpacing: 5,
        extendedWrapAlignment: ExtendedWrapAlignment.spaceBetween,
        expandWrap: true,
        desiredChildrenPerRun: 4,
        children: _createChildren(40, 40, Colors.deepOrange, 8),
      ),
    ];
  }

  List<Widget> _createChildren(double width, double height,
      MaterialColor initialColor, int elementCount) {
    return List<Widget>.generate(elementCount, (int index) {
      return Container(
        width: width,
        height: height,
        color: initialColor[100 * (index % 9 + 1)],
      );
    });
  }
}
