import 'dart:ui';

class CircularSegmentEntry {
  const CircularSegmentEntry(this.value, this.color, {this.rankKey});

  final double value;
  final Color color;
  final String rankKey;

  String toString() {
    return '$rankKey: $value $color';
  }
}

class CircularStackEntry {
  const CircularStackEntry(this.entries, {this.rankKey});

  final List<CircularSegmentEntry> entries;
  final String rankKey;
}
