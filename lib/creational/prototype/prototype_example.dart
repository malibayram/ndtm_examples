import 'package:flutter/material.dart';

import 'prototype.dart';

class PrototypeExample extends StatefulWidget {
  const PrototypeExample({super.key});

  @override
  State createState() => _PrototypeExampleState();
}

class _PrototypeExampleState extends State<PrototypeExample> {
  final Shape _circle = Circle.initial();
  final Shape _rectangle = Rectangle.initial();

  Shape? _circleClone;
  Shape? _rectangleClone;

  void _randomiseCircleProperties() {
    setState(() {
      _circle.randomiseProperties();
    });
  }

  void _cloneCircle() {
    setState(() {
      _circleClone = _circle.clone();
    });
  }

  void _randomiseRectangleProperties() {
    setState(() {
      _rectangle.randomiseProperties();
    });
  }

  void _cloneRectangle() {
    setState(() {
      _rectangleClone = _rectangle.clone();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: const ScrollBehavior(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 32.0,
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 32.0),
              const Text(
                "Circle",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              _circle.render(),
              const SizedBox(height: 16.0),
              if (_circleClone != null)
                Column(
                  children: <Widget>[
                    const Text(
                      "Circle Clone",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    _circleClone!.render(),
                    const SizedBox(height: 16.0),
                  ],
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _randomiseCircleProperties,
                    child: const Text("Randomise Properties"),
                  ),
                  ElevatedButton(
                    onPressed: _cloneCircle,
                    child: const Text("Clone"),
                  ),
                ],
              ),
              const SizedBox(height: 32.0),
              const Divider(),
              const SizedBox(height: 32.0),
              const Text(
                "Rectangle",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              _rectangle.render(),
              const SizedBox(height: 16.0),
              if (_rectangleClone != null)
                Column(
                  children: <Widget>[
                    const Text(
                      "Rectangle Clone",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    _rectangleClone!.render(),
                    const SizedBox(height: 16.0),
                  ],
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _randomiseRectangleProperties,
                    child: const Text("Randomise Properties"),
                  ),
                  ElevatedButton(
                    onPressed: _cloneRectangle,
                    child: const Text("Clone"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
