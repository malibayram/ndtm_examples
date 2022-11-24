class AudioApi {
  bool turnSpeakersOn() {
    return true;
  }

  bool turnSpeakersOff() {
    return false;
  }
}

class CameraApi {
  bool turnCameraOn() {
    return true;
  }

  bool turnCameraOff() {
    return false;
  }
}

class NetflixApi {
  bool connect() {
    return true;
  }

  bool disconnect() {
    return false;
  }

  void play(String title) {
    // ignore: avoid_print
    print("'$title' has started started playing on Netflix.");
  }
}

class PlaystationApi {
  bool turnOn() {
    return true;
  }

  bool turnOff() {
    return false;
  }
}

class SmartHomeApi {
  bool turnLightsOn() {
    return true;
  }

  bool turnLightsOff() {
    return false;
  }
}

class TvApi {
  bool turnOn() {
    return true;
  }

  bool turnOff() {
    return false;
  }
}

class SmartHomeState {
  bool tvOn = false;
  bool audioSystemOn = false;
  bool netflixConnected = false;
  bool gamingConsoleOn = false;
  bool streamingCameraOn = false;
  bool lightsOn = true;
}

class GamingFacade {
  final _playstationApi = PlaystationApi();
  final _cameraApi = CameraApi();

  void startGaming(SmartHomeState smartHomeState) {
    smartHomeState.gamingConsoleOn = _playstationApi.turnOn();
  }

  void stopGaming(SmartHomeState smartHomeState) {
    smartHomeState.gamingConsoleOn = _playstationApi.turnOff();
  }

  void startStreaming(SmartHomeState smartHomeState) {
    smartHomeState.streamingCameraOn = _cameraApi.turnCameraOn();
    startGaming(smartHomeState);
  }

  void stopStreaming(SmartHomeState smartHomeState) {
    smartHomeState.streamingCameraOn = _cameraApi.turnCameraOff();
    stopGaming(smartHomeState);
  }
}

class SmartHomeFacade {
  final _gamingFacade = GamingFacade();
  final _tvApi = TvApi();
  final _audioApi = AudioApi();
  final _netflixApi = NetflixApi();
  final _smartHomeApi = SmartHomeApi();

  void startMovie(SmartHomeState smartHomeState, String movieTitle) {
    smartHomeState.lightsOn = _smartHomeApi.turnLightsOff();
    smartHomeState.tvOn = _tvApi.turnOn();
    smartHomeState.audioSystemOn = _audioApi.turnSpeakersOn();
    smartHomeState.netflixConnected = _netflixApi.connect();
    _netflixApi.play(movieTitle);
  }

  void stopMovie(SmartHomeState smartHomeState) {
    smartHomeState.netflixConnected = _netflixApi.disconnect();
    smartHomeState.tvOn = _tvApi.turnOff();
    smartHomeState.audioSystemOn = _audioApi.turnSpeakersOff();
    smartHomeState.lightsOn = _smartHomeApi.turnLightsOn();
  }

  void startGaming(SmartHomeState smartHomeState) {
    smartHomeState.lightsOn = _smartHomeApi.turnLightsOff();
    smartHomeState.tvOn = _tvApi.turnOn();
    _gamingFacade.startGaming(smartHomeState);
  }

  void stopGaming(SmartHomeState smartHomeState) {
    _gamingFacade.stopGaming(smartHomeState);
    smartHomeState.tvOn = _tvApi.turnOff();
    smartHomeState.lightsOn = _smartHomeApi.turnLightsOn();
  }

  void startStreaming(SmartHomeState smartHomeState) {
    smartHomeState.lightsOn = _smartHomeApi.turnLightsOn();
    smartHomeState.tvOn = _tvApi.turnOn();
    _gamingFacade.startStreaming(smartHomeState);
  }

  void stopStreaming(SmartHomeState smartHomeState) {
    _gamingFacade.stopStreaming(smartHomeState);
    smartHomeState.tvOn = _tvApi.turnOff();
    smartHomeState.lightsOn = _smartHomeApi.turnLightsOn();
  }
}
