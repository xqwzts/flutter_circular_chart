import 'package:flutter/animation.dart';

abstract class MergeTweenable<T> {
  T get empty;

  Tween<T> tweenTo(T other);

  bool operator <(T other);
}

class MergeTween<T extends MergeTweenable<T>> extends Tween<List<T>> {
  MergeTween(List<T> begin, List<T> end) : super(begin: begin, end: end) {
    final bMax = begin.length;
    final eMax = end.length;
    var b = 0;
    var e = 0;
    while (b + e < bMax + eMax) {
      if (b < bMax && (e == eMax || begin[b] < end[e])) {
        _tweens.add(begin[b].tweenTo(begin[b].empty));
        b++;
      } else if (e < eMax && (b == bMax || end[e] < begin[b])) {
        _tweens.add(end[e].empty.tweenTo(end[e]));
        e++;
      } else {
        _tweens.add(begin[b].tweenTo(end[e]));
        b++;
        e++;
      }
    }
  }

  final _tweens = <Tween<T>>[];

  @override
  List<T> lerp(double t) => new List.generate(
        _tweens.length,
        (i) => _tweens[i].lerp(t),
      );
}
