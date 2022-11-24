import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

abstract class IState {
  Future nextState(StateContext context);
  Widget render();
}

class StateContext {
  final _stateStream = StreamController<IState>();
  Sink<IState> get _inState => _stateStream.sink;
  Stream<IState> get outState => _stateStream.stream;

  late IState _currentState;

  StateContext() {
    _currentState = NoResultsState();
    _addCurrentStateToStream();
  }

  void dispose() {
    _stateStream.close();
  }

  void setState(IState state) {
    _currentState = state;
    _addCurrentStateToStream();
  }

  void _addCurrentStateToStream() {
    _inState.add(_currentState);
  }

  Future<void> nextState() async {
    await _currentState.nextState(this);

    if (_currentState is LoadingState) {
      await _currentState.nextState(this);
    }
  }
}

class ErrorState implements IState {
  @override
  Future nextState(StateContext context) async {
    context.setState(LoadingState());
  }

  @override
  Widget render() {
    return const Text(
      'Oops! Something went wrong...',
      style: TextStyle(
        color: Colors.red,
        fontSize: 24.0,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class LoadedState implements IState {
  final List<String> names;

  const LoadedState(this.names);

  @override
  Future nextState(StateContext context) async {
    context.setState(LoadingState());
  }

  @override
  Widget render() {
    return Column(
      children: names
          .map(
            (name) => Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  child: Text(name[0]),
                ),
                title: Text(name),
              ),
            ),
          )
          .toList(),
    );
  }
}

class NoResultsState implements IState {
  @override
  Future nextState(StateContext context) async {
    context.setState(LoadingState());
  }

  @override
  Widget render() {
    return const Text(
      'No Results',
      style: TextStyle(fontSize: 24.0),
      textAlign: TextAlign.center,
    );
  }
}

class LoadingState implements IState {
  final FakeApi _api = FakeApi();

  @override
  Future nextState(StateContext context) async {
    try {
      final resultList = await _api.getNames();

      if (resultList.isEmpty) {
        context.setState(NoResultsState());
      } else {
        context.setState(LoadedState(resultList));
      }
    } on Exception {
      context.setState(ErrorState());
    }
  }

  @override
  Widget render() {
    return const CircularProgressIndicator(
      backgroundColor: Colors.transparent,
      valueColor: AlwaysStoppedAnimation<Color>(
        Colors.black,
      ),
    );
  }
}

class FakeApi {
  Future<List<String>> getNames() async {
    return Future.delayed(
      const Duration(seconds: 2),
      () {
        if (random.boolean()) {
          return _getRandomNames();
        }

        throw Exception('Unexpected error');
      },
    );
  }

  List<String> _getRandomNames() {
    if (random.boolean()) {
      return [];
    }

    return [
      faker.person.name(),
      faker.person.name(),
      faker.person.name(),
    ];
  }
}
