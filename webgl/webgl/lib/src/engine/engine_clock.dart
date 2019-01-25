
class EngineClock{
  num _currentTime = 0.0;
  num get currentTime => _currentTime;
  set currentTime(num time) {
    _deltaTime = time - _currentTime;
    _currentTime = time;
  }

  ///delta time since last rendered frame
  num _deltaTime;
  num get deltaTime => _deltaTime;

  ///Last time calculated frame
  num _lastTime = 0.0;
  num get lastTime => _lastTime;

  num _speedFactor = 1.0;
  num get speedFactor => _speedFactor;
  set speedFactor(num time) {
    _speedFactor = time;
  }

  num _computedFps = 0.0;
  int _fps = 0;

  EngineClock();

  num computeFps() {
    _fps++;

    if (_currentTime - _lastTime >= 1000) {

      _computedFps = _fps * 1000.0 / (_currentTime - _lastTime);

      //reset data
      _lastTime = _currentTime;
      _fps = 0;
    }

    return _computedFps;
  }
}