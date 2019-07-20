import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/src/tween.dart';

class CircularChartSegment extends MergeTweenable<CircularChartSegment> {
  CircularChartSegment(this.rank, this.sweepAngle, this.color, this.strokeWidth);

  final int rank;
  final double sweepAngle;
  final Color color;
  final double strokeWidth;

  @override
  CircularChartSegment get empty => new CircularChartSegment(rank, 0.0, color, strokeWidth);

  @override
  bool operator <(CircularChartSegment other) => rank < other.rank;

  @override
  Tween<CircularChartSegment> tweenTo(CircularChartSegment other) =>
      new CircularChartSegmentTween(this, other);

  static CircularChartSegment lerp(
      CircularChartSegment begin, CircularChartSegment end, double t) {
    assert(begin.rank == end.rank);

    return new CircularChartSegment(
      begin.rank,
      lerpDouble(begin.sweepAngle, end.sweepAngle, t),
      Color.lerp(begin.color, end.color, t),
      begin.strokeWidth
    );
  }
}

class CircularChartSegmentTween extends Tween<CircularChartSegment> {
  CircularChartSegmentTween(
      CircularChartSegment begin, CircularChartSegment end)
      : super(begin: begin, end: end) {
    assert(begin.rank == end.rank);
  }

  @override
  CircularChartSegment lerp(double t) =>
      CircularChartSegment.lerp(begin, end, t);
}
