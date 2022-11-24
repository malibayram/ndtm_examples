import 'package:flutter/material.dart';

import 'command.dart';

class CommandExample extends StatefulWidget {
  const CommandExample({super.key});

  @override
  State createState() => _CommandExampleState();
}

class _CommandExampleState extends State<CommandExample> {
  final CommandHistory _commandHistory = CommandHistory();
  final Shape _shape = Shape.initial();

  void _changeColor() {
    final command = ChangeColorCommand(_shape);
    _executeCommand(command);
  }

  void _changeHeight() {
    final command = ChangeHeightCommand(_shape);
    _executeCommand(command);
  }

  void _changeWidth() {
    final command = ChangeWidthCommand(_shape);
    _executeCommand(command);
  }

  void _executeCommand(Command command) {
    setState(() {
      command.execute();
      _commandHistory.add(command);
    });
  }

  void _undo() {
    setState(() {
      _commandHistory.undo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: const ScrollBehavior(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: <Widget>[
              Container(
                height: _shape.height,
                width: _shape.width,
                decoration: BoxDecoration(
                  color: _shape.color,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: _changeColor,
                child: const Text('Change color'),
              ),
              TextButton(
                onPressed: _changeHeight,
                child: const Text('Change height'),
              ),
              TextButton(
                onPressed: _changeWidth,
                child: const Text('Change width'),
              ),
              const Divider(),
              TextButton(
                onPressed: _commandHistory.isEmpty ? null : _undo,
                child: const Text('Undo'),
              ),
              const SizedBox(height: 24.0),
              Column(
                children: <Widget>[
                  Text(
                    'Command history:',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const SizedBox(width: 8.0),
                  for (final command in _commandHistory.commandHistoryList)
                    Text(command),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
