import 'dart:async';
import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'dart:typed_data';
import 'dart:math' as Math;

import 'package:webgl/src/context.dart';
import 'package:webgl/src/interaction/interactionnable.dart';
import 'package:webgl/src/time/time.dart';

class Interaction {

  final CanvasElement canvas;

  TouchesManager _touchesManager;

  //Debug div
  Element elementDebugInfoText;
  Element elementFPSText;

  //Interaction with keyboard
  List<bool> _currentlyPressedKeys;

  bool dragging = false;
  bool mouseDown = false;
  bool isMiddleMouseButton = false;

  int currentX = 0;
  int currentY = 0;
  double deltaX = 0.0;
  double deltaY = 0.0;

  num scaleFactor = 3.0;

  List<Interactionable> _interactionables = new List<Interactionable>();

  ///Mouse
  StreamController<MouseEvent> _onMouseDownController = new StreamController<MouseEvent>.broadcast();
  Stream<MouseEvent> get onMouseDown => _onMouseDownController.stream;

  StreamController<MouseEvent> _onMouseUpController = new StreamController<MouseEvent>.broadcast();
  Stream<MouseEvent> get onMouseUp => _onMouseDownController.stream;

  /// Touch
  StreamController<TouchEvent> _onTouchStartController = new StreamController<TouchEvent>.broadcast();
  Stream<TouchEvent> get onTouchStart => _onTouchStartController.stream;

  StreamController<TouchEvent> _onTouchEndController = new StreamController<TouchEvent>.broadcast();
  Stream<TouchEvent> get onTouchEnd => _onTouchEndController.stream;

  ///
  StreamController _onDragController = new StreamController<dynamic>.broadcast();
  Stream<dynamic> get onDrag => _onDragController.stream;

  StreamController _onResizeController = new StreamController<dynamic>.broadcast();
  Stream<dynamic> get onResize => _onResizeController.stream;

  Interaction(this.canvas) {
    _touchesManager = new TouchesManager();
    _initEvents();
  }

  void _initEvents() {
    _currentlyPressedKeys = new List<bool>(128);
    for (int i = 0; i < 128; i++) _currentlyPressedKeys[i] = false;

    // Todo (jpu) : externalise this
    elementDebugInfoText = querySelector("#debugInfosText");
    elementFPSText = querySelector("#fps");

    if(elementFPSText != null) elementFPSText.style.display = 'block';

    onResize.listen((dynamic event){
      Context.resizeCanvas();
    });

    window.onResize.listen(_onWindowResize);

    window.onKeyUp.listen(_onKeyUp);
    window.onKeyDown.listen(_onKeyDown);

    canvas.onMouseDown.listen(_onMouseDown);
    canvas.onMouseMove.listen(_onMouseMove);
    canvas.onMouseUp.listen(_onMouseUp);
    canvas.onMouseWheel.listen(_onMouseWheel);

    canvas.onTouchStart.listen(_onTouchStart);
    canvas.onTouchMove.listen(_onTouchMove);
    canvas.onTouchEnd.listen(_onTouchEnd);
    canvas.onTouchLeave.listen(_onTouchLeave);
    canvas.onTouchCancel.listen(_onTouchCancel);
    canvas.onTouchEnter.listen(_onTouchEnter);
  }

  void addInteractable(Interactionable interactionable){
    if(interactionable != null) {
      _interactionables.add(interactionable);
    }
  }

  ///
  /// Window
  ///

  void _onWindowResize(Event event) {
    _onResizeController.add(event);
  }

  ///
  /// Keyboard
  ///

  void _onKeyDown(KeyboardEvent event) {
    if (KeyCode.UP == event.keyCode || KeyCode.DOWN == event.keyCode) {
      if ((elementDebugInfoText != null)) {
        elementDebugInfoText.text =
            "Camera Position: ${Context.mainCamera.translation}";
      }
    } else {}
    _currentlyPressedKeys[event.keyCode] = true;
  }

  void _onKeyUp(KeyboardEvent event) {
    if ((event.keyCode > 0) && (event.keyCode < 128))
      _currentlyPressedKeys[event.keyCode] = false;
  }

  void update() {
    _handleKeys();
    Time.showFps(elementFPSText);
  }

  void _handleKeys() {
    if (_currentlyPressedKeys[KeyCode.UP]) {
      // Key Up
      Context.mainCamera.translate(new Vector3(0.0, 0.0, 0.1));
    }
    if (_currentlyPressedKeys[KeyCode.DOWN]) {
      // Key Down
      Context.mainCamera.translate(new Vector3(0.0, 0.0, -0.1));
    }
    if (_currentlyPressedKeys[KeyCode.LEFT]) {
      // Key Up
      Context.mainCamera.translate(new Vector3(-0.1, 0.0, 0.0));
    }
    if (_currentlyPressedKeys[KeyCode.RIGHT]) {
      // Key Down
      Context.mainCamera.translate(new Vector3(0.1, 0.0, 0.0));
    }
  }

  ///
  /// Mouse
  ///

  void _onMouseDown(MouseEvent event) {
    int screenX = event.client.x.toInt();
    int screenY = event.client.y.toInt();
    updateMouseInfos(screenX, screenY);

    _interactionables.forEach((i)=> i.onMouseDown(screenX, screenY));

    dragging = false;
    mouseDown = true;
    isMiddleMouseButton = event.button == 1;

    _onMouseDownController.add(event);
  }

  void _onMouseMove(MouseEvent event) {
    int screenX = event.client.x.toInt();
    int screenY = event.client.y.toInt();
    updateMouseInfos(screenX, screenY);

    _interactionables.forEach((i)=> i.onMouseMove(deltaX, deltaY, isMiddleMouseButton));

    if(mouseDown) {
      dragging = true;
      _onDragController.add(null);
    }else{
      dragging = false;
    }
  }

  void _onMouseUp(MouseEvent event) {
    int screenX = event.client.x.toInt();
    int screenY = event.client.y.toInt();
    updateMouseInfos(screenX, screenY);

    _interactionables.forEach((i)=> i.onMouseUp(screenX, screenY));

    dragging = false;
    mouseDown = false;
    isMiddleMouseButton = false;

    _onMouseUpController.add(event);
  }

  void _onMouseWheel(WheelEvent event){
    num deltaY = -event.deltaY;
    deltaY = Math.max(-1, Math.min(1, deltaY))/ 50;
    _interactionables.forEach((i)=> i.onMouseWheel(deltaY));
  }
    
  /// Determine how far we have moved since the last mouse move event.
  void updateMouseInfos(int screenX, int screenY) {
    deltaX = (currentX - screenX) / scaleFactor;
    deltaY = (currentY - screenY) / scaleFactor;
    currentX = screenX;
    currentY = screenY;
  }

  String getMouseInfos(){
    return 'currentX : $currentX | currentY : $currentY | deltaX : $deltaX | deltaY : $deltaY | ';
  }

  ///
  /// Touch
  ///

  void showTouchEventInfos(TouchEvent event){
    _touchesManager.update(event);
    print(_touchesManager.getDebugInfos(''));
    // Todo (jpu) : show this in a div with fps
  }

  void _onTouchStart(TouchEvent event) {
    _touchesManager.update(event);

    if(_touchesManager.touchLength > 1){
      _interactionables.forEach((i)=> i.onTouchStart(null, null));
    }else {
      int screenX = _touchesManager[0].client.x.toInt();
      int screenY = _touchesManager[0].client.y.toInt();
      updateMouseInfos(screenX, screenY);

      _interactionables.forEach((i)=> i.onTouchStart(screenX, screenY));
    }

    dragging = false;
    mouseDown = true;
    _onTouchStartController.add(event);
  }

  void _onTouchMove(TouchEvent event) {
    _touchesManager.update(event);

    if(event.targetTouches.length > 1){
      _interactionables.forEach((i)=> i.onTouchMove(null, null, scaleChange : _touchesManager.scaleChange));
//      //position with center of 2 first touches
//      int screenX = (_touchesManager[0].client.x.toInt() + _touchesManager[1].client.x.toInt())~/2;
//      int screenY = (_touchesManager[0].client.y.toInt() + _touchesManager[1].client.y.toInt())~/2;
//      updateMouseInfos(screenX, screenY);
//      cameraController?.updateCameraPosition(mainCamera, deltaX, deltaY, CameraControllerMode.pan);
    }else {
      int screenX = _touchesManager[0].client.x.toInt();
      int screenY = _touchesManager[0].client.y.toInt();
      updateMouseInfos(screenX, screenY);

      _interactionables.forEach((i)=> i.onTouchMove(deltaX, deltaY));
    }

    if (mouseDown) {
      dragging = true;
      _onDragController.add(null);
    } else {
      dragging = false;
    }
  }

  void _onTouchEnd(TouchEvent event) {
    int screenX = _touchesManager[0].client.x.toInt();
    int screenY = _touchesManager[0].client.y.toInt();
    updateMouseInfos(screenX, screenY);
    _interactionables.forEach((i)=> i.onTouchEnd(screenX, screenY));

    dragging = false;
    mouseDown = false;

    _onTouchEndController.add(event);
  }

  void _onTouchLeave(TouchEvent event) {
    print('Interaction._onTouchLeave');
  }

  void _onTouchCancel(TouchEvent event) {
    print('Interaction._onTouchCancel');
  }

  void _onTouchEnter(TouchEvent event) {
    print('Interaction._onTouchEnter');
  }

  ///
  /// Debug
  ///

  void debugInfo(num posX, num posY, num posZ) {
    var colorPicked = new Uint8List(4);
    //Todo : readPixels doesn't work in dartium...
//    gl.readPixels(posX.toInt(), posY.toInt(), 1, 1, RenderingContext.RGBA, RenderingContext.UNSIGNED_BYTE, colorPicked);
    elementDebugInfoText?.text = '[$posX, $posY, $posZ] : $colorPicked';
  }
}

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
