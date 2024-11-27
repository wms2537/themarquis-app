import 'package:flutter/material.dart';

class AngledSubmitShape extends ShapeBorder {
  final Color _color;

  const AngledSubmitShape(this._color);
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();

    path.moveTo(rect.left + rect.width * 0.03, rect.top);
    path.lineTo(rect.right - rect.width * 0.03, rect.top);
    path.lineTo(rect.right, rect.top + rect.height / 2);
    path.lineTo(rect.right - rect.width * 0.03, rect.bottom);
    path.lineTo(rect.left + rect.width * 0.03, rect.bottom);
    path.lineTo(rect.left, rect.top + rect.height / 2);
    path.lineTo(rect.left + rect.width * 0.03, rect.top);
    path.close();

    return path;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();

    path.moveTo(rect.left + rect.width * 0.03, rect.top);
    path.lineTo(rect.right - rect.width * 0.03, rect.top);
    path.lineTo(rect.right, rect.top + rect.height / 2);
    path.lineTo(rect.right - rect.width * 0.03, rect.bottom);
    path.lineTo(rect.left + rect.width * 0.03, rect.bottom);
    path.lineTo(rect.left, rect.top + rect.height / 2);
    path.lineTo(rect.left + rect.width * 0.03, rect.top);
    path.close();

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final path = Path();

    path.moveTo(rect.left + rect.width * 0.11, rect.top + rect.height * 0.35);
    path.lineTo(rect.left + rect.width * 0.09, rect.top + rect.height * 0.65);

    path.moveTo(rect.left + rect.width * 0.14, rect.top + rect.height * 0.35);
    path.lineTo(rect.left + rect.width * 0.12, rect.top + rect.height * 0.65);

    path.moveTo(rect.left + rect.width * 0.17, rect.top + rect.height * 0.35);
    path.lineTo(rect.left + rect.width * 0.15, rect.top + rect.height * 0.65);

    final paint = Paint();
    paint.strokeWidth = 2;
    paint.color = _color;
    paint.style = PaintingStyle.stroke;
    canvas.drawPath(path, paint);

    path.moveTo(rect.left + rect.width * 0.25, rect.top + rect.height * 0.39);
    path.lineTo(rect.left + rect.width * 0.25, rect.top + rect.height * 0.60);
    path.lineTo(rect.left + rect.width * 0.265, rect.top + rect.height * 0.5);
    path.lineTo(rect.left + rect.width * 0.251, rect.top + rect.height * 0.39);

    paint.style = PaintingStyle.fill;
    canvas.drawPath(path, paint);

    path.moveTo(rect.right - rect.width * 0.11, rect.top + rect.height * 0.35);
    path.lineTo(rect.right - rect.width * 0.09, rect.top + rect.height * 0.65);

    path.moveTo(rect.right - rect.width * 0.14, rect.top + rect.height * 0.35);
    path.lineTo(rect.right - rect.width * 0.12, rect.top + rect.height * 0.65);

    path.moveTo(rect.right - rect.width * 0.17, rect.top + rect.height * 0.35);
    path.lineTo(rect.right - rect.width * 0.15, rect.top + rect.height * 0.65);

    paint.strokeWidth = 2;
    paint.color = _color;
    paint.style = PaintingStyle.stroke;
    canvas.drawPath(path, paint);

    path.moveTo(rect.right - rect.width * 0.25, rect.top + rect.height * 0.39);
    path.lineTo(rect.right - rect.width * 0.25, rect.top + rect.height * 0.60);
    path.lineTo(rect.right - rect.width * 0.265, rect.top + rect.height * 0.5);
    path.lineTo(rect.right - rect.width * 0.25, rect.top + rect.height * 0.39);

    paint.style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  @override
  ShapeBorder scale(double t) => AngledSubmitShape(_color);
}
