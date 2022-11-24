import 'dart:collection';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class Shape {
  late Color color;
  late double height;
  late double width;

  Shape(this.color, this.height, this.width);

  Shape.initial() {
    color = Colors.black;
    height = 150.0;
    width = 150.0;
  }

  Shape.copy(Shape shape) : this(shape.color, shape.height, shape.width);
}

abstract class ICommand {
  void execute();
  void undo();
}

class RandomisePropertiesCommand implements ICommand {
  final Originator originator;
  late final IMemento _backup;

  RandomisePropertiesCommand(this.originator) {
    _backup = originator.createMemento();
  }

  @override
  void execute() {
    final shape = originator.state;

    shape.color = Color.fromRGBO(
      random.integer(255),
      random.integer(255),
      random.integer(255),
      1.0,
    );
    shape.height = random.integer(150, min: 50).toDouble();
    shape.width = random.integer(150, min: 50).toDouble();
  }

  @override
  void undo() {
    originator.restore(_backup);
  }
}

class CommandHistory {
  final ListQueue<ICommand> _commandList = ListQueue<ICommand>();

  bool get isEmpty => _commandList.isEmpty;

  void add(ICommand command) {
    _commandList.add(command);
  }

  void undo() {
    if (_commandList.isNotEmpty) {
      final command = _commandList.removeLast();
      command.undo();
    }
  }
}

abstract class IMemento {
  Shape getState();
}

class Memento extends IMemento {
  late final Shape _state;

  Memento(Shape shape) {
    _state = Shape.copy(shape);
  }

  @override
  Shape getState() {
    return _state;
  }
}

class Originator {
  late Shape state;

  Originator() {
    state = Shape.initial();
  }

  IMemento createMemento() {
    return Memento(state);
  }

  void restore(IMemento memento) {
    state = memento.getState();
  }
}
