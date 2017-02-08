class Time{
  static num _lastTime = 0.0;
  static num _deltaTime;
  static num get deltaTime => _deltaTime;

  static num _currentTime;
  static num get currentTime => _currentTime;
  static set currentTime(num value) {
    _currentTime = value;
    _deltaTime = _currentTime - _lastTime;
    _lastTime = _currentTime;
  }
}