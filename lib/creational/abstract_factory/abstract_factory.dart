import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class IWidgetsFactory {
  String getTitle();
  IActivityIndicator createActivityIndicator();
  ISlider createSlider();
  ISwitch createSwitch();
}

class MaterialWidgetsFactory implements IWidgetsFactory {
  @override
  String getTitle() {
    return 'Android widgets';
  }

  @override
  IActivityIndicator createActivityIndicator() {
    return AndroidActivityIndicator();
  }

  @override
  ISlider createSlider() {
    return AndroidSlider();
  }

  @override
  ISwitch createSwitch() {
    return AndroidSwitch();
  }
}

class CupertinoWidgetsFactory implements IWidgetsFactory {
  @override
  String getTitle() {
    return 'iOS widgets';
  }

  @override
  IActivityIndicator createActivityIndicator() {
    return IosActivityIndicator();
  }

  @override
  ISlider createSlider() {
    return IosSlider();
  }

  @override
  ISwitch createSwitch() {
    return IosSwitch();
  }
}

abstract class IActivityIndicator {
  Widget render();
}

class AndroidActivityIndicator implements IActivityIndicator {
  @override
  Widget render() {
    return CircularProgressIndicator(
      backgroundColor: const Color(0xFFECECEC),
      valueColor: AlwaysStoppedAnimation<Color>(
        Colors.black.withOpacity(0.65),
      ),
    );
  }
}

class IosActivityIndicator implements IActivityIndicator {
  @override
  Widget render() {
    return const CupertinoActivityIndicator();
  }
}

abstract class ISlider {
  Widget render(double value, ValueSetter<double> onChanged);
}

class AndroidSlider implements ISlider {
  @override
  Widget render(double value, ValueSetter<double> onChanged) {
    return Slider(
      activeColor: Colors.black,
      inactiveColor: Colors.grey,
      max: 100.0,
      value: value,
      onChanged: onChanged,
    );
  }
}

class IosSlider implements ISlider {
  @override
  Widget render(double value, ValueSetter<double> onChanged) {
    return CupertinoSlider(
      max: 100.0,
      value: value,
      onChanged: onChanged,
    );
  }
}

abstract class ISwitch {
  Widget render({required bool value, required ValueSetter<bool> onChanged});
}

class AndroidSwitch implements ISwitch {
  @override
  Widget render({required bool value, required ValueSetter<bool> onChanged}) {
    return Switch(
      activeColor: Colors.black,
      value: value,
      onChanged: onChanged,
    );
  }
}

class IosSwitch implements ISwitch {
  @override
  Widget render({required bool value, required ValueSetter<bool> onChanged}) {
    return CupertinoSwitch(
      value: value,
      onChanged: onChanged,
    );
  }
}
