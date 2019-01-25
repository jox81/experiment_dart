import 'dart:html';

/// 3 Touches sont pris sur chrome android
class TouchesManager{
  TouchEvent _lastTouchEvent;
  Touch operator [](int index) => _lastTouchEvent?.targetTouches[index];

  int get touchLength => _lastTouchEvent.targetTouches.length;

  num _startDistance;
  num get startDistance => _startDistance;

  num get currentDistance => _lastTouchEvent?.targetTouches[0].client.distanceTo(_lastTouchEvent?.targetTouches[1].client);

  num _scaleChange;
  num get scaleChange => _scaleChange;

  TouchesManager();

  void update(TouchEvent event){
    event.targetTouches;

    if( event.targetTouches.length > 0){
      Touch firstTouch = event.targetTouches[0];

      if(event.targetTouches.length > 1) {
        for (var i = 1; i < event.targetTouches.length; ++i) {
          Touch otherTouch = event.targetTouches[i];
          if(_startDistance == null){
            _startDistance = otherTouch.client.distanceTo(firstTouch.client);
          }
          num currentDistance = otherTouch.client.distanceTo(firstTouch.client);
          _scaleChange = currentDistance/_startDistance;
        }
      }else{
        _startDistance = null;
      }
    }

    _lastTouchEvent = event;
  }

  StringBuffer _stringBuffer = new StringBuffer();
  String getDebugInfos(String name){
    void _wrapBufferText(String infos) {
      _stringBuffer.write('<p>');
      _stringBuffer.write(infos);
      _stringBuffer.write('</p>');
    }

    _stringBuffer.clear();

    _wrapBufferText('$name : ${touchLength}');

    if(touchLength > 0){
      Touch firstTouch = this[0];

      _wrapBufferText('touch 0 : (${firstTouch.client.x},${firstTouch.client.y})');

      if(touchLength > 1) {
        for (var i = 1; i < touchLength; ++i) {
          Touch otherTouch = this[i];
          _wrapBufferText('otherTouch $i : (${otherTouch.client.x},${otherTouch.client.y}) > ${this[i].client.distanceTo(this[0].client)}');
          _wrapBufferText('startDistance : ${startDistance}');
          _wrapBufferText('scaleChange : ${scaleChange}');
        }
      }
    }

    return _stringBuffer.toString();
  }
}