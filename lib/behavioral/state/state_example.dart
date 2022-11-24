import 'package:flutter/material.dart';

import 'state.dart';

class StateExample extends StatefulWidget {
  const StateExample({super.key});

  @override
  State createState() => _StateExampleState();
}

class _StateExampleState extends State<StateExample> {
  final StateContext _stateContext = StateContext();

  Future<void> _changeState() async {
    await _stateContext.nextState();
  }

  @override
  void dispose() {
    _stateContext.dispose();
    super.dispose();
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
              TextButton(
                onPressed: _changeState,
                child: const Text("Load names"),
              ),
              const SizedBox(height: 32.0),
              StreamBuilder<IState>(
                initialData: NoResultsState(),
                stream: _stateContext.outState,
                builder: (context, snapshot) => snapshot.data!.render(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
