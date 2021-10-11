import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/src/circular_chart.dart';
import 'package:flutter_circular_chart/src/entry.dart';
import 'package:flutter_circular_chart/src/painter.dart';

// The default chart tween animation duration.
const Duration _kDuration = const Duration(milliseconds: 300);
// The default angle the chart is oriented at.
const double _kStartAngle = -90.0;

enum CircularChartType {
  Pie,
  Radial,
}

/// Determines how the ends of a chart's segments should be drawn.
enum SegmentEdgeStyle {
  /// Segments begin and end with a flat edge.
  flat,

  /// Segments begin and end with a semi-circle.
  round,
}

class AnimatedCircularChart extends StatefulWidget {
  AnimatedCircularChart({
    Key key,
    @required this.size,
    @required this.initialChartData,
    this.chartType = CircularChartType.Radial,
    this.duration = _kDuration,
    this.percentageValues = false,
    this.holeRadius,
    this.startAngle = _kStartAngle,
    this.holeLabel,
    this.labelStyle,
    this.edgeStyle = SegmentEdgeStyle.flat,
  })  : assert(size != null),
        super(key: key);

  /// The size of the bounding box this chart will be constrained to.
  final Size size;

  /// The data used to build the chart displayed when the widget is first placed.
  /// Each [CircularStackEntry] in the list defines an individual stack of data:
  /// For a Pie chart that corresponds to individual slices in the chart.
  /// For a Radial chart it corresponds to individual segments on the same arc.
  ///
  /// If length > 1 and [chartType] is [CircularChartType.Radial] then the stacks
  /// will be grouped together as concentric circles.
  ///
  /// If [chartType] is [CircularChartType.Pie] then length cannot be > 1.
  final List<CircularStackEntry> initialChartData;

  /// The type of chart to be rendered.
  /// Use [CircularChartType.Pie] for a circle divided into slices for each entry.
  /// Use [CircularChartType.Radial] for one or more arcs with a hole in the center.
  final CircularChartType chartType;

  /// The duration of the chart animation when [AnimatedCircularChartState.updateData]
  /// is called.
  final Duration duration;

  /// If true then the data values provided will determine what percentage of the circle
  /// this segment occupies [i.e: a value of 100 is the full circle].
  ///
  /// Otherwise the data is normalized such that the sum of all values in each stack
  /// is considered to encompass 100% of the circle.
  ///
  /// defaults to false.
  final bool percentageValues;

  /// For [CircularChartType.Radial] charts this defines the circle in the center
  /// of the canvas, around which the chart is drawn. If not provided then it will
  /// be automatically calculated to accommodate all the data.
  ///
  /// Has no effect in [CircularChartType.Pie] charts.
  final double holeRadius;

  /// The chart gets drawn and animates clockwise from [startAngle], defaulting to the
  /// top/center point or -90.0. In terms of a clock face these would be:
  /// - -90.0:  12 o'clock
  /// - 0.0:    3 o'clock
  /// - 90.0:   6 o'clock
  /// - 180.0:  9 o'clock
  final double startAngle;

  /// A label to show in the hole of a radial chart.
  ///
  /// It is used to display the value of a radial slider, and it is displayed
  /// in the center of the chart's hole.
  ///
  /// See also [labelStyle] which is used to render the label.
  final String holeLabel;

  /// The style used when rendering the [holeLabel].
  ///
  /// Defaults to the active [ThemeData]'s
  /// [ThemeData.textTheme.body2] text style.
  final TextStyle labelStyle;

  /// The type of segment edges to be drawn.
  ///
  /// Defaults to [SegmentEdgeStyle.flat].
  final SegmentEdgeStyle edgeStyle;

  /// The state from the closest instance of this class that encloses the given context.
  ///
  /// This method is typically used by [AnimatedCircularChart] item widgets that insert or
  /// remove items in response to user input.
  ///
  /// ```dart
  /// AnimatedCircularChartState animatedCircularChart = AnimatedCircularChart.of(context);
  /// ```
  static AnimatedCircularChartState of(BuildContext context,
      {bool nullOk: false}) {
    assert(context != null);
    assert(nullOk != null);

    final AnimatedCircularChartState result = context
        .findAncestorStateOfType<AnimatedCircularChartState>();

    if (nullOk || result != null) return result;

    throw new FlutterError(
        'AnimatedCircularChart.of() called with a context that does not contain a AnimatedCircularChart.\n'
        'No AnimatedCircularChart ancestor could be found starting from the context that was passed to AnimatedCircularChart.of(). '
        'This can happen when the context provided is from the same StatefulWidget that '
        'built the AnimatedCircularChart.\n'
        'The context used was:\n'
        '  $context');
  }

  @override
  AnimatedCircularChartState createState() => new AnimatedCircularChartState();
}

/// The state for a circular chart that animates when its data is updated.
///
/// When the chart data changes with [updateData] an animation begins running.
///
/// An app that needs to update its data in response to an event
/// can refer to the [AnimatedCircularChart]'s state with a global key:
///
/// ```dart
/// GlobalKey<AnimatedCircularChartState> chartKey = new GlobalKey<AnimatedCircularChartState>();
/// ...
/// new AnimatedCircularChart(key: chartKey, ...);
/// ...
/// chartKey.currentState.updateData(newData);
/// ```
class AnimatedCircularChartState extends State<AnimatedCircularChart>
    with TickerProviderStateMixin {
  CircularChartTween _tween;
  AnimationController _animation;
  final Map<String, int> _stackRanks = <String, int>{};
  final Map<String, int> _entryRanks = <String, int>{};
  final TextPainter _labelPainter = new TextPainter();

  @override
  void initState() {
    super.initState();
    _animation = new AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _assignRanks(widget.initialChartData);

    _tween = new CircularChartTween(
      new CircularChart.empty(chartType: widget.chartType),
      new CircularChart.fromData(
        size: widget.size,
        data: widget.initialChartData,
        chartType: widget.chartType,
        stackRanks: _stackRanks,
        entryRanks: _entryRanks,
        percentageValues: widget.percentageValues,
        holeRadius: widget.holeRadius,
        startAngle: widget.startAngle,
        edgeStyle: widget.edgeStyle,
      ),
    );
    _animation.forward();
  }

  @override
  void didUpdateWidget(AnimatedCircularChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.holeLabel != widget.holeLabel ||
        oldWidget.labelStyle != widget.labelStyle) {
      _updateLabelPainter();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateLabelPainter();
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  void _assignRanks(List<CircularStackEntry> data) {
    for (CircularStackEntry stackEntry in data) {
      _stackRanks.putIfAbsent(stackEntry.rankKey, () => _stackRanks.length);
      for (CircularSegmentEntry entry in stackEntry.entries) {
        _entryRanks.putIfAbsent(entry.rankKey, () => _entryRanks.length);
      }
    }
  }

  void _updateLabelPainter() {
    if (widget.holeLabel != null) {
      TextStyle _labelStyle =
          widget.labelStyle ?? Theme.of(context).textTheme.body2;
      _labelPainter
        ..text = new TextSpan(style: _labelStyle, text: widget.holeLabel)
        ..textDirection = Directionality.of(context)
        ..textScaleFactor = MediaQuery.of(context).textScaleFactor
        ..layout();
    } else {
      _labelPainter.text = null;
    }
  }

  /// Update the data this chart represents and start an animation that will tween
  /// between the old data and this one.
  void updateData(List<CircularStackEntry> data) {
    _assignRanks(data);

    setState(() {
      _tween = new CircularChartTween(
        _tween.evaluate(_animation),
        new CircularChart.fromData(
          size: widget.size,
          data: data,
          chartType: widget.chartType,
          stackRanks: _stackRanks,
          entryRanks: _entryRanks,
          percentageValues: widget.percentageValues,
          holeRadius: widget.holeRadius,
          startAngle: widget.startAngle,
          edgeStyle: widget.edgeStyle,
        ),
      );
      _animation.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      size: widget.size,
      painter: new AnimatedCircularChartPainter(
        _tween.animate(_animation),
        widget.holeLabel != null ? _labelPainter : null,
      ),
    );
  }
}
