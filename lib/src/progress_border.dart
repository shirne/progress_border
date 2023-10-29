import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

extension RadiusPlus on Radius {
  Radius deflate(double delta) {
    return Radius.elliptical((x - delta).clamp(0, double.infinity),
        (y - delta).clamp(0, double.infinity));
  }

  Radius inflate(double delta) {
    return Radius.elliptical((x + delta).clamp(0, double.infinity),
        (y + delta).clamp(0, double.infinity));
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
    this.backgroundColor,
    this.backgroundBorder,
  });

  const ProgressBorder.fromBorderSide(
    BorderSide side, [
    this.progress,
    this.backgroundColor,
    this.backgroundBorder,
  ])  : top = side,
        right = side,
        bottom = side,
        left = side;

  const ProgressBorder.symmetric({
    BorderSide vertical = BorderSide.none,
    BorderSide horizontal = BorderSide.none,
    this.progress,
    this.backgroundColor,
    this.backgroundBorder,
  })  : left = vertical,
        top = horizontal,
        right = vertical,
        bottom = horizontal;

  factory ProgressBorder.all({
    Color color = const Color(0xFF000000),
    double width = 1.0,
    BorderStyle style = BorderStyle.solid,
    double strokeAlign = -1,
    double? progress,
    Color? backgroundColor,
    Border? backgroundBorder,
  }) {
    final BorderSide side = BorderSide(
      color: color,
      width: width,
      style: style,
      strokeAlign: strokeAlign,
    );

    return ProgressBorder.fromBorderSide(
      side,
      progress,
      backgroundColor,
      backgroundBorder,
    );
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
      backgroundColor: a.backgroundColor ?? b.backgroundColor,
      backgroundBorder: a.backgroundBorder == null
          ? b.backgroundBorder
          : b.backgroundBorder == null
              ? a.backgroundBorder
              : Border.merge(a.backgroundBorder!, b.backgroundBorder!),
    );
  }

  /// paint a complete border under the progress border.
  final Border? backgroundBorder;

  /// paint the backgroundBorder use same path
  final Color? backgroundColor;

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
  bool get isUniform =>
      _colorIsUniform &&
      _widthIsUniform &&
      _styleIsUniform &&
      _strokeAlignIsUniform;

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

  bool get _strokeAlignIsUniform {
    final double topStrokeAlign = top.strokeAlign;
    return right.strokeAlign == topStrokeAlign &&
        bottom.strokeAlign == topStrokeAlign &&
        left.strokeAlign == topStrokeAlign;
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
      backgroundColor: backgroundColor,
      backgroundBorder: backgroundBorder?.scale(t),
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
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      backgroundBorder: Border.lerp(a.backgroundBorder, b.backgroundBorder, t),
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
    backgroundBorder?.paint(
      canvas,
      rect,
      textDirection: textDirection,
      shape: shape,
      borderRadius: borderRadius,
    );

    if (isUniform) {
      Path? path;
      Paint paint = top.toPaint()
        ..strokeCap = ui.StrokeCap.round
        ..strokeJoin = ui.StrokeJoin.round;
      switch (top.style) {
        case BorderStyle.none:
          return;
        case BorderStyle.solid:
          switch (shape) {
            case BoxShape.circle:
              assert(
                borderRadius == null,
                'A borderRadius can only be given for rectangular boxes.',
              );
              path = _getUniformBorderWithCirclePath(rect, top);
              break;
            case BoxShape.rectangle:
              if (borderRadius != null && borderRadius != BorderRadius.zero) {
                path = _getUniformBorderWithRadiusPath(
                  rect,
                  top,
                  borderRadius,
                );
              } else {
                paint.strokeJoin = ui.StrokeJoin.miter;
                path = _getUniformBorderWithRectanglePath(
                  rect,
                  top,
                );
              }
              break;
          }
      }

      final metrics = path.computeMetrics(forceClosed: true).toList();

      if (backgroundColor != null) {
        _paintMetrics(
          canvas,
          metrics,
          paint..color = backgroundColor!,
          1,
        );
      }

      _paintMetrics(canvas, metrics, paint..color = top.color, progress ?? 1);
      return;
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
          if (!_strokeAlignIsUniform)
            ErrorDescription('BorderSide.strokeAlign'),
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
        other.progress == progress &&
        other.backgroundColor == backgroundColor &&
        other.backgroundBorder == backgroundBorder;
  }

  @override
  int get hashCode => Object.hash(
        top,
        right,
        bottom,
        left,
        progress,
        backgroundColor,
        backgroundBorder,
      );

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

  static Path _getUniformBorderWithRadiusPath(
    Rect rect,
    BorderSide side,
    BorderRadius borderRadius,
  ) {
    assert(side.style != BorderStyle.none);

    if (side.strokeAlign > BorderSide.strokeAlignInside) {
      rect = rect.inflate(
        side.width * (side.strokeAlign - BorderSide.strokeAlignInside) / 2,
      );
    }

    final double halfWidth = side.width / 2;
    final double deflate = halfWidth * side.strokeAlign;

    final topLeft = borderRadius.topLeft.inflate(deflate);
    final topRight = borderRadius.topRight.inflate(deflate);
    final bottomLeft = borderRadius.bottomLeft.inflate(deflate);
    final bottomRight = borderRadius.bottomRight.inflate(deflate);

    return Path()
      ..moveTo(rect.left + rect.width / 2, rect.top + halfWidth)
      ..relativeLineTo(rect.width / 2 - topRight.x - halfWidth, 0)
      ..relativeArcToPoint(Offset(topRight.x, topRight.y),
          radius: topRight, rotation: 90)
      ..relativeLineTo(0, rect.height - topRight.y - bottomRight.y - side.width)
      ..relativeArcToPoint(Offset(-bottomRight.x, bottomRight.y),
          radius: bottomRight, rotation: 90)
      ..relativeLineTo(
          side.width + bottomRight.x + bottomLeft.x - rect.width, 0)
      ..relativeArcToPoint(Offset(-bottomLeft.x, -bottomLeft.y),
          radius: bottomLeft, rotation: 90)
      ..relativeLineTo(0, side.width + bottomLeft.y + topLeft.y - rect.height)
      ..relativeArcToPoint(Offset(topLeft.x, -topLeft.y),
          radius: topLeft, rotation: 90)
      ..close();
  }

  static Path _getUniformBorderWithCirclePath(
    Rect rect,
    BorderSide side,
  ) {
    assert(side.style != BorderStyle.none);
    if (side.strokeAlign > BorderSide.strokeAlignInside) {
      rect = rect.inflate(
        side.width * (side.strokeAlign - BorderSide.strokeAlignInside) / 2,
      );
    }

    final double width = side.width;

    final double radius = (rect.shortestSide - width) / 2.0;
    final size = rect.shortestSide;

    final left = rect.left + (rect.width - rect.shortestSide) / 2;
    final top = rect.top + (rect.height - rect.shortestSide) / 2;

    return Path()
      ..moveTo(left + size / 2, top + width / 2)
      ..relativeArcToPoint(Offset(0, size - width),
          radius: Radius.circular(radius), rotation: 180)
      ..relativeArcToPoint(Offset(0, width - size),
          radius: Radius.circular(radius), rotation: 180)
      ..close();
  }

  static Path _getUniformBorderWithRectanglePath(
    Rect rect,
    BorderSide side,
  ) {
    assert(side.style != BorderStyle.none);
    if (side.strokeAlign > BorderSide.strokeAlignInside) {
      rect = rect.inflate(
        side.width * (side.strokeAlign - BorderSide.strokeAlignInside) / 2,
      );
    }
    final double halfWidth = side.width / 2;

    return Path()
      ..moveTo(rect.left + rect.width / 2, rect.top + halfWidth)
      ..relativeLineTo(rect.width / 2 - halfWidth, 0)
      ..relativeLineTo(0, rect.height - side.width)
      ..relativeLineTo(side.width - rect.width, 0)
      ..relativeLineTo(0, side.width - rect.height)
      ..close();
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
