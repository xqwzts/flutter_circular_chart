import 'dart:ui';

/// Data object defining a segment in a circular chart.
///
/// In radial charts a [CircularSegmentEntry] corresponds to an arc segment of
/// the current ring, for pie charts it is an individual slice.
///
/// The portion of the stack this segment will occupy is calculated from the given
/// [value], what proportion of a stack this corresponds to depends on the [percentageValues]
/// property of the chart.
class CircularSegmentEntry {
  const CircularSegmentEntry(this.value, this.color, {this.rankKey});

  /// The value of this data point, defines the sweep angle of the arc
  /// that is drawn. If the chart being drawn has [percentageValues] set to false
  /// then this segment is drawn in proportion to the total value of all segments
  /// in the stack. Otherwise the value is considered the exact percentage of the
  /// stack that this segment occupies.
  final double value;

  /// The color drawn in the stack for this segment.
  final Color color;

  /// An optional String key, used when animating charts to preserve semantics when
  /// transitioning between data points.
  final String rankKey;

  String toString() {
    return '$rankKey: $value $color';
  }
}

/// Data object defining a stack in a circular chart.
///
/// Each [CircularStackEntry] corresponds to a complete circle in the chart.
/// For radial charts that is one of the rings, for pie charts it is the whole pie.
///
/// A stack is composed of [entries], a List containing 1 or more [CircularSegmentEntries]
/// and an optional [rankKey] String.
class CircularStackEntry {
  const CircularStackEntry(this.entries, {this.rankKey});

  /// List of [CircularSegmentEntry]s that make up this stack.
  final List<CircularSegmentEntry> entries;

  /// An optional String key, used when animating charts to preserve semantics when
  /// transitioning between data points.
  final String rankKey;
}
