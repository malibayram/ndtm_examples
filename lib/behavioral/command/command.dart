import 'dart:collection';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class Shape {
  late Color color;
  late double height;
  late double width;

  Shape.initial() {
    color = Colors.black;
    height = 150.0;
    width = 150.0;
  }
}

abstract class Command {
  void execute();
  String getTitle();
  void undo();
}

class ChangeColorCommand implements Command {
  final Shape shape;
  late Color previousColor;

  ChangeColorCommand(this.shape) {
    previousColor = shape.color;
  }

  @override
  void execute() {
    shape.color = Color.fromRGBO(
      random.integer(255),
      random.integer(255),
      random.integer(255),
      1.0,
    );
  }

  @override
  String getTitle() {
    return 'Change color to ${shape.color.value.toRadixString(16)}';
  }

  @override
  void undo() {
    shape.color = previousColor;
  }
}

class ChangeHeightCommand implements Command {
  final Shape shape;
  late double previousHeight;

  ChangeHeightCommand(this.shape) {
    previousHeight = shape.height;
  }

  @override
  void execute() {
    shape.height = random.integer(150, min: 50).toDouble();
  }

  @override
  String getTitle() {
    return 'Change height to ${shape.height}';
  }

  @override
  void undo() {
    shape.height = previousHeight;
  }
}

class ChangeWidthCommand implements Command {
  final Shape shape;
  late double previousWidth;

  ChangeWidthCommand(this.shape) {
    previousWidth = shape.width;
  }

  @override
  void execute() {
    shape.width = random.integer(150, min: 50).toDouble();
  }

  @override
  String getTitle() {
    return 'Change width to ${shape.width}';
  }

  @override
  void undo() {
    shape.width = previousWidth;
  }
}

class CommandHistory {
  final _commandList = ListQueue<Command>();

  bool get isEmpty => _commandList.isEmpty;
  List<String> get commandHistoryList =>
      _commandList.map((c) => c.getTitle()).toList();

  void add(Command command) {
    _commandList.add(command);
  }

  void undo() {
    if (_commandList.isNotEmpty) {
      final command = _commandList.removeLast();
      command.undo();
    }
  }
}
