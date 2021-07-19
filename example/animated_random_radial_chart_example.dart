import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'dart:math' as Math;

import 'color_palette.dart';

void main() {
  runApp(new MaterialApp(
    home: new RandomizedRadialChartExample(),
  ));
}

class RandomizedRadialChartExample extends StatefulWidget {
  @override
  _RandomizedRadialChartExampleState createState() =>
      new _RandomizedRadialChartExampleState();
}

class _RandomizedRadialChartExampleState
    extends State<RandomizedRadialChartExample> {
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();
  final _chartSize = const Size(300.0, 300.0);
  final Math.Random random = new Math.Random();
  List<CircularStackEntry>? data;

  @override
  void initState() {
    super.initState();
    data = _generateRandomData();
  }

  double value = 50.0;

  void _randomize() {
    setState(() {
      data = _generateRandomData();
      _chartKey.currentState!.updateData(data!);
    });
  }

  List<CircularStackEntry> _generateRandomData() {
    int stackCount = random.nextInt(10);
    List<CircularStackEntry> data = new List.generate(stackCount, (i) {
      int segCount = random.nextInt(10);
      List<CircularSegmentEntry> segments =  new List.generate(segCount, (j) {
        Color? randomColor = ColorPalette.primary.random(random);
        return new CircularSegmentEntry(random.nextDouble(), randomColor);
      });
      return new CircularStackEntry(segments);
    });

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Randomized radial data'),
      ),
      body: new Center(
        child: new AnimatedCircularChart(
          key: _chartKey,
          size: _chartSize,
          initialChartData: data,
          chartType: CircularChartType.Radial,
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _randomize,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
