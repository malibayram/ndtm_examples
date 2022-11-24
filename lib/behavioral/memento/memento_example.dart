import 'package:flutter/material.dart';

import 'memento.dart';

class MementoExample extends StatefulWidget {
  const MementoExample({super.key});

  @override
  State createState() => _MementoExampleState();
}

class _MementoExampleState extends State<MementoExample> {
  final _commandHistory = CommandHistory();
  final _originator = Originator();

  void _randomiseProperties() {
    final command = RandomisePropertiesCommand(_originator);
    _executeCommand(command);
  }

  void _executeCommand(ICommand command) {
    command.execute();
    _commandHistory.add(command);

    setState(() {});
  }

  void _undo() {
    _commandHistory.undo();

    setState(() {});
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
                height: _originator.state.height,
                width: _originator.state.width,
                decoration: BoxDecoration(
                  color: _originator.state.color,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              const SizedBox(height: 24.0),
              TextButton(
                onPressed: _randomiseProperties,
                child: const Text('Randomise properties'),
              ),
              const Divider(),
              TextButton(
                onPressed: _undo,
                child: const Text('Undo'),
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }
}
