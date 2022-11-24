import 'package:flutter/material.dart';

enum ShapeType {
  Circle,
  Square,
}

abstract class IPositionedShape {
  Widget render(double x, double y);
}

class Circle implements IPositionedShape {
  final Color color;
  final double diameter;

  const Circle({required this.color, required this.diameter});

  @override
  Widget render(double x, double y) {
    return Positioned(
      left: x,
      bottom: y,
      child: Container(
        height: diameter,
        width: diameter,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class Square implements IPositionedShape {
  final Color color;
  final double width;

  const Square({required this.color, required this.width});

  double get height => width;

  @override
  Widget render(double x, double y) {
    return Positioned(
      left: x,
      bottom: y,
      child: Container(
        height: height,
        width: width,
        color: color,
      ),
    );
  }
}

class ShapeFactory {
  const ShapeFactory();

  IPositionedShape createShape(ShapeType shapeType) {
    switch (shapeType) {
      case ShapeType.Circle:
        return Circle(
          color: Colors.red.withOpacity(0.2),
          diameter: 10.0,
        );
      case ShapeType.Square:
        return Square(
          color: Colors.blue.withOpacity(0.2),
          width: 10.0,
        );
      default:
        throw Exception("Shape type '$shapeType' is not supported.");
    }
  }
}

class ShapeFlyweightFactory {
  final ShapeFactory shapeFactory;
  final Map<ShapeType, IPositionedShape> shapesMap = {};

  ShapeFlyweightFactory({required this.shapeFactory});

  IPositionedShape getShape(ShapeType shapeType) {
    if (!shapesMap.containsKey(shapeType)) {
      shapesMap[shapeType] = shapeFactory.createShape(shapeType);
    }

    return shapesMap[shapeType]!;
  }

  int getShapeInstancesCount() {
    return shapesMap.length;
  }
}
