import 'dart:html';

class Time{
  static num _currentTime = 0.0;
  static num get currentTime => _currentTime;
  static set currentTime(num time) {
    _deltaTime = time - _currentTime;
    _currentTime = time;
  }

  ///delta time since last rendered frame
  static num _deltaTime;
  static num get deltaTime => _deltaTime;

  ///Last time calculated frame
  static num _lastTime = 0.0;
  static num get lastTime => _lastTime;

  static num _speedFactor = 1.0;
  static num get speedFactor => _speedFactor;
  static set speedFactor(num time) {
    _speedFactor = time;
  }

  static num _computedFps = 0.0;
  static int fps = 0;

  ///Display the animation's FPS in the element.
  static void showFps(Element element) {

    if (element == null) return;

    fps++;

    if (_currentTime - _lastTime >= 1000) {

      _computedFps = fps * 1000.0 / (_currentTime - _lastTime);

      element.text = "${_computedFps.toStringAsFixed(2)} fps";

      //reset
      _lastTime = _currentTime;
      fps = 0;
    }
  }
}