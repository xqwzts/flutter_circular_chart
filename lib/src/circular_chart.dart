import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/src/animated_circular_chart.dart';
import 'package:flutter_circular_chart/src/entry.dart';
import 'package:flutter_circular_chart/src/stack.dart';
import 'package:flutter_circular_chart/src/tween.dart';

class CircularChart {
  static const double _kStackWidthFraction = 0.75;

  CircularChart(
    this.stacks,
    this.chartType, {
    this.edgeStyle = SegmentEdgeStyle.flat,
  });

  final List<CircularChartStack>? stacks;
  final CircularChartType? chartType;
  final SegmentEdgeStyle? edgeStyle;

  factory CircularChart.empty({required CircularChartType chartType}) {
    return new CircularChart(<CircularChartStack>[], chartType);
  }

  factory CircularChart.fromData({
    required Size size,
    required List<CircularStackEntry> data,
    required CircularChartType chartType,
    required bool percentageValues,
    required double startAngle,
    Map<String, int>? stackRanks,
    Map<String, int>? entryRanks,
    double? holeRadius,
    SegmentEdgeStyle? edgeStyle,
  }) {
    final double _holeRadius = holeRadius ?? size.width / (2 + data.length);
    final double stackDistance =
        (size.width / 2 - _holeRadius) / (2 + data.length);
    final double stackWidth = stackDistance * _kStackWidthFraction;
    final double startRadius = stackDistance + _holeRadius;

    List<CircularChartStack> stacks = new List<CircularChartStack>.generate(
      data.length,
      (i) => new CircularChartStack.fromData(
            stackRanks![data[i].rankKey] ?? i,
            data[i].entries,
            entryRanks!,
            percentageValues,
            startRadius + i * stackDistance,
            stackWidth,
            startAngle,
          ),
    );

    return new CircularChart(stacks, chartType, edgeStyle: edgeStyle);
  }
}

class CircularChartTween extends Tween<CircularChart> {
  CircularChartTween(CircularChart begin, CircularChart end)
      : _stacksTween =
            new MergeTween<CircularChartStack>(begin.stacks, end.stacks),
        super(begin: begin, end: end);

  final MergeTween<CircularChartStack> _stacksTween;

  @override
  CircularChart lerp(double t) => new CircularChart(
        _stacksTween.lerp(t),
        begin!.chartType,
        edgeStyle: end!.edgeStyle,
      );
}
