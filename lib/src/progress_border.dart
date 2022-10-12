import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

extension RadiusPlus on Radius {
  Radius deflate(double delta) {
    return Radius.elliptical(x - delta, y - delta);
  }

  Radius inflate(double delta) {
    return Radius.elliptical(x + delta, y + delta);
  }
}

/// Draw part of border by progress
class ProgressBorder extends BoxBorder {
  const ProgressBorder({
    this.top = BorderSide.none,
    this.right = BorderSide.none,
    this.bottom = BorderSide.none,
    this.left = BorderSide.none,
    this.progress,
  });

  const ProgressBorder.fromBorderSide(
    BorderSide side, [
    this.progress,
  ])  : top = side,
        right = side,
        bottom = side,
        left = side;

  const ProgressBorder.symmetric({
    BorderSide vertical = BorderSide.none,
    BorderSide horizontal = BorderSide.none,
    this.progress,
  })  : left = vertical,
        top = horizontal,
        right = vertical,
        bottom = horizontal;

  factory ProgressBorder.all({
    Color color = const Color(0xFF000000),
    double width = 1.0,
    BorderStyle style = BorderStyle.solid,
    double? progress,
  }) {
    final BorderSide side =
        BorderSide(color: color, width: width, style: style);
    return ProgressBorder.fromBorderSide(side, progress);
  }

  static ProgressBorder merge(ProgressBorder a, ProgressBorder b) {
    assert(BorderSide.canMerge(a.top, b.top));
    assert(BorderSide.canMerge(a.right, b.right));
    assert(BorderSide.canMerge(a.bottom, b.bottom));
    assert(BorderSide.canMerge(a.left, b.left));
    return ProgressBorder(
      top: BorderSide.merge(a.top, b.top),
      right: BorderSide.merge(a.right, b.right),
      bottom: BorderSide.merge(a.bottom, b.bottom),
      left: BorderSide.merge(a.left, b.left),
      progress: a.progress,
    );
  }

  @override
  final BorderSide top;

  /// The right side of this border.
  final BorderSide right;

  @override
  final BorderSide bottom;

  /// The left side of this border.
  final BorderSide left;

  final double? progress;

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.fromLTRB(
      left.width,
      top.width,
      right.width,
      bottom.width,
    );
  }

  @override
  bool get isUniform => _colorIsUniform && _widthIsUniform && _styleIsUniform;

  bool get _colorIsUniform {
    final Color topColor = top.color;
    return right.color == topColor &&
        bottom.color == topColor &&
        left.color == topColor;
  }

  bool get _widthIsUniform {
    final double topWidth = top.width;
    return right.width == topWidth &&
        bottom.width == topWidth &&
        left.width == topWidth;
  }

  bool get _styleIsUniform {
    final BorderStyle topStyle = top.style;
    return right.style == topStyle &&
        bottom.style == topStyle &&
        left.style == topStyle;
  }

  @override
  ProgressBorder? add(ShapeBorder other, {bool reversed = false}) {
    if (other is ProgressBorder &&
        BorderSide.canMerge(top, other.top) &&
        BorderSide.canMerge(right, other.right) &&
        BorderSide.canMerge(bottom, other.bottom) &&
        BorderSide.canMerge(left, other.left)) {
      return ProgressBorder.merge(this, other);
    }
    return null;
  }

  @override
  ProgressBorder scale(double t) {
    return ProgressBorder(
      top: top.scale(t),
      right: right.scale(t),
      bottom: bottom.scale(t),
      left: left.scale(t),
      progress: progress,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is ProgressBorder) return ProgressBorder.lerp(a, this, t);
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is ProgressBorder) return ProgressBorder.lerp(this, b, t);
    return super.lerpTo(b, t);
  }

  static ProgressBorder? lerp(ProgressBorder? a, ProgressBorder? b, double t) {
    if (a == null && b == null) return null;
    if (a == null) return b!.scale(t);
    if (b == null) return a.scale(1.0 - t);
    return ProgressBorder(
      top: BorderSide.lerp(a.top, b.top, t),
      right: BorderSide.lerp(a.right, b.right, t),
      bottom: BorderSide.lerp(a.bottom, b.bottom, t),
      left: BorderSide.lerp(a.left, b.left, t),
      progress: a.progress,
    );
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    if (isUniform) {
      switch (top.style) {
        case BorderStyle.none:
          return;
        case BorderStyle.solid:
          switch (shape) {
            case BoxShape.circle:
              assert(borderRadius == null,
                  'A borderRadius can only be given for rectangular boxes.');
              _paintUniformBorderWithCircle(canvas, rect, top, progress ?? 1);
              break;
            case BoxShape.rectangle:
              if (borderRadius != null) {
                _paintUniformBorderWithRadius(
                  canvas,
                  rect,
                  top,
                  borderRadius,
                  progress ?? 1,
                );
                return;
              }
              _paintUniformBorderWithRectangle(
                canvas,
                rect,
                top,
                progress ?? 1,
              );
              break;
          }
          return;
      }
    }

    assert(() {
      if (borderRadius != null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
              'A borderRadius can only be given for a uniform Border.'),
          ErrorDescription('The following is not uniform:'),
          if (!_colorIsUniform) ErrorDescription('BorderSide.color'),
          if (!_widthIsUniform) ErrorDescription('BorderSide.width'),
          if (!_styleIsUniform) ErrorDescription('BorderSide.style'),
        ]);
      }
      return true;
    }());
    assert(() {
      if (shape != BoxShape.rectangle) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
              'A Border can only be drawn as a circle if it is uniform'),
          ErrorDescription('The following is not uniform:'),
          if (!_colorIsUniform) ErrorDescription('BorderSide.color'),
          if (!_widthIsUniform) ErrorDescription('BorderSide.width'),
          if (!_styleIsUniform) ErrorDescription('BorderSide.style'),
        ]);
      }
      return true;
    }());

    // TODO(shirne) for Ununiform
    paintBorder(
      canvas,
      rect,
      top: top,
      right: right,
      bottom: bottom,
      left: left,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is ProgressBorder &&
        other.top == top &&
        other.right == right &&
        other.bottom == bottom &&
        other.left == left &&
        other.progress == progress;
  }

  @override
  int get hashCode => Object.hash(top, right, bottom, left, progress);

  @override
  String toString() {
    if (isUniform) {
      return '${objectRuntimeType(this, 'ProgressBorder')}.all($top)';
    }
    final List<String> arguments = <String>[
      if (top != BorderSide.none) 'top: $top',
      if (right != BorderSide.none) 'right: $right',
      if (bottom != BorderSide.none) 'bottom: $bottom',
      if (left != BorderSide.none) 'left: $left',
    ];
    return '${objectRuntimeType(this, 'ProgressBorder')}(${arguments.join(", ")})';
  }

  static void _paintUniformBorderWithRadius(
    Canvas canvas,
    Rect rect,
    BorderSide side,
    BorderRadius borderRadius,
    double progress,
  ) {
    assert(side.style != BorderStyle.none);
    final Paint paint = Paint()..color = side.color;
    final RRect outer = borderRadius.toRRect(rect);
    final double halfWidth = side.width / 2;
    if (halfWidth <= 0.0) {
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.0;
      canvas.drawRRect(outer, paint);
    } else {
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = side.width;
      _paint(
        canvas,
        Path()
          ..moveTo(rect.left + rect.width / 2, rect.top + halfWidth)
          ..relativeLineTo(
              rect.width / 2 - borderRadius.topRight.x - halfWidth, 0)
          ..relativeArcToPoint(
              Offset(borderRadius.topRight.x, borderRadius.topRight.y),
              radius: borderRadius.topRight.deflate(halfWidth / 2),
              rotation: 90)
          ..relativeLineTo(
              0,
              rect.height -
                  borderRadius.topRight.y -
                  borderRadius.bottomRight.y -
                  side.width)
          ..relativeArcToPoint(
              Offset(-borderRadius.bottomRight.x, borderRadius.bottomRight.y),
              radius: borderRadius.bottomRight.deflate(halfWidth / 2),
              rotation: 90)
          ..relativeLineTo(
              side.width +
                  borderRadius.bottomRight.x +
                  borderRadius.bottomLeft.x -
                  rect.width,
              0)
          ..relativeArcToPoint(
              Offset(-borderRadius.bottomLeft.x, -borderRadius.bottomLeft.y),
              radius: borderRadius.bottomLeft.deflate(halfWidth / 2),
              rotation: 90)
          ..relativeLineTo(
              0,
              side.width +
                  borderRadius.bottomLeft.y +
                  borderRadius.topLeft.y -
                  rect.height)
          ..relativeArcToPoint(
              Offset(borderRadius.topLeft.x, -borderRadius.topLeft.y),
              radius: borderRadius.topLeft.deflate(halfWidth / 2),
              rotation: 90)
          ..close(),
        paint,
        progress,
      );
    }
  }

  static void _paintUniformBorderWithCircle(
    Canvas canvas,
    Rect rect,
    BorderSide side,
    double progress,
  ) {
    assert(side.style != BorderStyle.none);
    final double width = side.width;
    final Paint paint = side.toPaint();
    final double radius = (rect.shortestSide - width) / 2.0;
    final size = rect.shortestSide;

    final left = rect.left + (rect.width - rect.shortestSide) / 2;
    final top = rect.top + (rect.height - rect.shortestSide) / 2;
    _paint(
      canvas,
      Path()
        ..moveTo(left + size / 2, top + width / 2)
        ..relativeArcToPoint(Offset(0, size - width),
            radius: Radius.circular(radius), rotation: 180)
        ..relativeArcToPoint(Offset(0, width - size),
            radius: Radius.circular(radius), rotation: 180),
      paint,
      progress,
    );
  }

  static void _paintUniformBorderWithRectangle(
    Canvas canvas,
    Rect rect,
    BorderSide side,
    double progress,
  ) {
    assert(side.style != BorderStyle.none);
    final double halfWidth = side.width / 2;
    final Paint paint = side.toPaint();

    _paint(
      canvas,
      Path()
        ..moveTo(rect.left + rect.width / 2, rect.top + halfWidth)
        ..relativeLineTo(rect.width / 2 - halfWidth, 0)
        ..relativeLineTo(0, rect.height - side.width)
        ..relativeLineTo(side.width - rect.width, 0)
        ..relativeLineTo(0, side.width - rect.height)
        ..close(),
      paint,
      progress,
    );
  }

  static void _paint(
    Canvas canvas,
    Path path,
    Paint paint,
    double progress,
  ) {
    final metrics = path
        //.transform(matrix.storage)
        .computeMetrics(forceClosed: true)
        .toList();
    _paintMetrics(canvas, metrics, paint, progress);
  }

  // TODO(shirne) cache metrics?
  static void _paintMetrics(
    Canvas canvas,
    List<ui.PathMetric> metrics,
    Paint paint,
    double progress,
  ) {
    final total = metrics.fold<double>(0, (v, e) => v + e.length);

    double target = total * progress;
    paint.strokeJoin = ui.StrokeJoin.miter;
    paint.strokeCap = ui.StrokeCap.round;

    final iterator = metrics.toList();

    for (final m in iterator) {
      if (target <= 0) break;

      if (target >= m.length) {
        canvas.drawPath(m.extractPath(0, m.length), paint);
        target -= m.length;
      } else {
        canvas.drawPath(m.extractPath(0, target), paint);
      }
    }
  }
}
