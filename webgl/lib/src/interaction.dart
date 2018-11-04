import 'dart:async';
import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'dart:typed_data';
import 'dart:math' as Math;

import 'package:webgl/src/camera/camera.dart';
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/time/time.dart';

abstract class Interactable{
  Interaction get interaction;
  CameraPerspective get mainCamera;
  CanvasElement get canvas;

  /// called this in CTOR
  void initInteraction();
}

class Interaction {

  final Interactable _interactable;

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

  CameraPerspective get mainCamera => _interactable.mainCamera;
  CameraController get cameraController => _interactable.mainCamera?.cameraController;

  StreamController<MouseEvent> _onMouseDownController = new StreamController<MouseEvent>.broadcast();
  Stream<MouseEvent> get onMouseDown => _onMouseDownController.stream;

  StreamController<MouseEvent> _onMouseUpController = new StreamController<MouseEvent>.broadcast();
  Stream<MouseEvent> get onMouseUp => _onMouseDownController.stream;


  StreamController<TouchEvent> _onTouchStartController = new StreamController<TouchEvent>.broadcast();
  Stream<TouchEvent> get onTouchStart => _onTouchStartController.stream;

  StreamController<TouchEvent> _onTouchEndController = new StreamController<TouchEvent>.broadcast();
  Stream<TouchEvent> get onTouchEnd => _onTouchEndController.stream;

  StreamController _onDragController = new StreamController<dynamic>.broadcast();
  Stream<dynamic> get onDrag => _onDragController.stream;

  StreamController _onResizeController = new StreamController<dynamic>.broadcast();
  Stream<dynamic> get onResize => _onResizeController.stream;

  Interaction(this._interactable) {
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

    window.onResize.listen(_onWindowResize);

    window.onKeyUp.listen(_onKeyUp);
    window.onKeyDown.listen(_onKeyDown);

    _interactable.canvas.onMouseDown.listen(_onMouseDown);
    _interactable.canvas.onMouseMove.listen(_onMouseMove);
    _interactable.canvas.onMouseUp.listen(_onMouseUp);
    _interactable.canvas.onMouseWheel.listen(_onMouseWheel);

    _interactable.canvas.onTouchStart.listen(_onTouchStart);
    _interactable.canvas.onTouchMove.listen(_onTouchMove);
    _interactable.canvas.onTouchEnd.listen(_onTouchEnd);
    _interactable.canvas.onTouchLeave.listen(_onTouchLeave);
    _interactable.canvas.onTouchCancel.listen(_onTouchCancel);
    _interactable.canvas.onTouchEnter.listen(_onTouchEnter);
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
            "Camera Position: ${mainCamera.translation}";
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
      mainCamera.translate(new Vector3(0.0, 0.0, 0.1));
    }
    if (_currentlyPressedKeys[KeyCode.DOWN]) {
      // Key Down
      mainCamera.translate(new Vector3(0.0, 0.0, -0.1));
    }
    if (_currentlyPressedKeys[KeyCode.LEFT]) {
      // Key Up
      mainCamera.translate(new Vector3(-0.1, 0.0, 0.0));
    }
    if (_currentlyPressedKeys[KeyCode.RIGHT]) {
      // Key Down
      mainCamera.translate(new Vector3(0.1, 0.0, 0.0));
    }
  }

  ///
  /// Mouse
  ///

  void _onMouseDown(MouseEvent event) {
    int screenX = event.client.x.toInt();
    int screenY = event.client.y.toInt();
    updateMouseInfos(screenX, screenY);

    cameraController?.beginOrbit(mainCamera, screenX, screenY);

    dragging = false;
    mouseDown = true;
    isMiddleMouseButton = event.button == 1;

    _onMouseDownController.add(event);

  }

  void _onMouseMove(MouseEvent event) {
    int screenX = event.client.x.toInt();
    int screenY = event.client.y.toInt();
    updateMouseInfos(screenX, screenY);

    cameraController?.updateCameraPosition(mainCamera, deltaX, deltaY, isMiddleMouseButton ? 1:0);//!! hack : dart doesn't seem to recognize middle mouse button dragging !!

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

    cameraController?.endOrbit(mainCamera);

    dragging = false;
    mouseDown = false;
    isMiddleMouseButton = false;

    _onMouseUpController.add(event);
  }

  void _onMouseWheel(WheelEvent event){
    num deltaY = -event.deltaY;
    deltaY = Math.max(-1, Math.min(1, deltaY))/ 50;
    cameraController?.updateCameraFov(mainCamera, deltaY);
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

  double _startFov;

  void showTouchEventInfos(TouchEvent event){
    _touchesManager.update(event);
    print(_touchesManager.getDebugInfos(''));
    // Todo (jpu) : show this in a div with fps
  }

  void _onTouchStart(TouchEvent event) {
    _touchesManager.update(event);

    if(_touchesManager.touchLength > 1){
      _startFov = mainCamera.yfov;
    }else {
      int screenX = _touchesManager[0].client.x.toInt();
      int screenY = _touchesManager[0].client.y.toInt();
      updateMouseInfos(screenX, screenY);

      cameraController?.beginOrbit(mainCamera, screenX, screenY);
    }

    dragging = false;
    mouseDown = true;
    _onTouchStartController.add(event);
  }

  void _onTouchMove(TouchEvent event) {
    _touchesManager.update(event);

    if(event.targetTouches.length > 1){
      mainCamera.yfov = _startFov / _touchesManager.scaleChange;
    }else {
      int screenX = _touchesManager[0].client.x.toInt();
      int screenY = _touchesManager[0].client.y.toInt();
      updateMouseInfos(screenX, screenY);
      cameraController?.updateCameraPosition(mainCamera, deltaX, deltaY, 0);
    }

    if (mouseDown) {
      dragging = true;
      _onDragController.add(null);
    } else {
      dragging = false;
    }

  }

  void _onTouchEnd(TouchEvent event) {
    cameraController?.endOrbit(mainCamera);

    dragging = false;
    mouseDown = false;

    _onTouchEndController.add(event);
    _startFov = null;
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
