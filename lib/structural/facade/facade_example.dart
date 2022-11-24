import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'facade.dart';

class FacadeExample extends StatefulWidget {
  const FacadeExample({super.key});

  @override
  State createState() => _FacadeExampleState();
}

class _FacadeExampleState extends State<FacadeExample> {
  final _smartHomeFacade = SmartHomeFacade();
  final _smartHomeState = SmartHomeState();

  bool _homeCinemaModeOn = false;
  bool _gamingModeOn = false;
  bool _streamingModeOn = false;

  bool get _isAnyModeOn =>
      _homeCinemaModeOn || _gamingModeOn || _streamingModeOn;

  void _changeHomeCinemaMode(bool activated) {
    if (activated) {
      _smartHomeFacade.startMovie(_smartHomeState, 'Movie title');
    } else {
      _smartHomeFacade.stopMovie(_smartHomeState);
    }

    setState(() {
      _homeCinemaModeOn = activated;
    });
  }

  void _changeGamingMode(bool activated) {
    if (activated) {
      _smartHomeFacade.startGaming(_smartHomeState);
    } else {
      _smartHomeFacade.stopGaming(_smartHomeState);
    }

    setState(() {
      _gamingModeOn = activated;
    });
  }

  void _changeStreamingMode(bool activated) {
    if (activated) {
      _smartHomeFacade.startStreaming(_smartHomeState);
    } else {
      _smartHomeFacade.stopStreaming(_smartHomeState);
    }

    setState(() {
      _streamingModeOn = activated;
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
              SwitchListTile(
                value: _homeCinemaModeOn,
                onChanged: !_isAnyModeOn || _homeCinemaModeOn
                    ? _changeHomeCinemaMode
                    : null,
                title: const Text("Home cinema mode"),
              ),
              SwitchListTile(
                value: _gamingModeOn,
                onChanged:
                    !_isAnyModeOn || _gamingModeOn ? _changeGamingMode : null,
                title: const Text("Gaming mode"),
              ),
              SwitchListTile(
                value: _streamingModeOn,
                onChanged: !_isAnyModeOn || _streamingModeOn
                    ? _changeStreamingMode
                    : null,
                title: const Text("Streaming mode"),
              ),
              const SizedBox(height: 48 * 2),
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.tv,
                        size: 48,
                        color: _smartHomeState.tvOn ? Colors.green : Colors.red,
                      ),
                      Icon(
                        FontAwesomeIcons.film,
                        size: 48,
                        color: _smartHomeState.netflixConnected
                            ? Colors.green
                            : Colors.red,
                      ),
                      Icon(
                        FontAwesomeIcons.playstation,
                        size: 48,
                        color: _smartHomeState.gamingConsoleOn
                            ? Colors.green
                            : Colors.red,
                      ),
                    ],
                  ),
                  const SizedBox(height: 48.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.lightbulb,
                        size: 48,
                        color: _smartHomeState.lightsOn
                            ? Colors.green
                            : Colors.red,
                      ),
                      Icon(
                        FontAwesomeIcons.video,
                        size: 48,
                        color: _smartHomeState.streamingCameraOn
                            ? Colors.green
                            : Colors.red,
                      ),
                      Icon(
                        FontAwesomeIcons.audible,
                        size: 48,
                        color: _smartHomeState.audioSystemOn
                            ? Colors.green
                            : Colors.red,
                      ),
                    ],
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
