import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

void main() {
  runApp(new MaterialApp(
    home: new AnimatedPieChartExample(),
  ));
}

final List<List<CircularStackEntry>> _quarterlyProfitPieData = [
  <CircularStackEntry>[
    new CircularStackEntry(
      <CircularSegmentEntry>[
        new CircularSegmentEntry(500.0, Colors.red[200], rankKey: 'Q1'),
        new CircularSegmentEntry(1000.0, Colors.green[200], rankKey: 'Q2'),
        new CircularSegmentEntry(2000.0, Colors.blue[200], rankKey: 'Q3'),
        new CircularSegmentEntry(1000.0, Colors.yellow[200], rankKey: 'Q4'),
      ],
      rankKey: 'Quarterly Profits',
    ),
  ],
  <CircularStackEntry>[
    new CircularStackEntry(
      <CircularSegmentEntry>[
        new CircularSegmentEntry(1500.0, Colors.red[200], rankKey: 'Q1'),
        new CircularSegmentEntry(750.0, Colors.green[200], rankKey: 'Q2'),
        new CircularSegmentEntry(2000.0, Colors.blue[200], rankKey: 'Q3'),
        new CircularSegmentEntry(1000.0, Colors.yellow[200], rankKey: 'Q4'),
      ],
      rankKey: 'Quarterly Profits',
    ),
  ],
  <CircularStackEntry>[
    new CircularStackEntry(
      <CircularSegmentEntry>[
        new CircularSegmentEntry(1800.0, Colors.red[200], rankKey: 'Q1'),
        new CircularSegmentEntry(2900.0, Colors.green[200], rankKey: 'Q2'),
        new CircularSegmentEntry(4000.0, Colors.blue[200], rankKey: 'Q3'),
        new CircularSegmentEntry(7000.0, Colors.yellow[200], rankKey: 'Q4'),
      ],
      rankKey: 'Quarterly Profits',
    ),
  ],
];

class AnimatedPieChartExample extends StatefulWidget {
  @override
  _AnimatedPieChartExampleState createState() =>
      new _AnimatedPieChartExampleState();
}

class _AnimatedPieChartExampleState extends State<AnimatedPieChartExample> {
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();
  final _chartSize = const Size(300.0, 300.0);
  int sampleIndex = 0;

  void _cycleSamples() {
    setState(() {
      sampleIndex++;
      List<CircularStackEntry> data = _quarterlyProfitPieData[sampleIndex % 3];
      _chartKey.currentState!.updateData(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Quarterly Profit'),
      ),
      body: new Center(
        child: new AnimatedCircularChart(
          key: _chartKey,
          size: _chartSize,
          initialChartData: _quarterlyProfitPieData[0],
          chartType: CircularChartType.Pie,
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.refresh),
        onPressed: _cycleSamples,
      ),
    );
  }
}
