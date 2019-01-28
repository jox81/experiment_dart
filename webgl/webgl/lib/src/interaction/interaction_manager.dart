import 'dart:async';
import 'dart:html';
import 'dart:math' as Math;
import 'package:webgl/src/context.dart';
import 'package:webgl/src/engine/engine.dart';
import 'package:webgl/src/interaction/interactionnable.dart';
import 'package:webgl/src/interaction/touch_manager.dart';

class InteractionManager {

  final Engine engine;
  final TouchesManager _touchesManager = new TouchesManager();

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

  InteractionManager(this.engine) {
    _initEvents();
  }

  void _initEvents() {
    _currentlyPressedKeys = new List<bool>(128);
    for (int i = 0; i < 128; i++) _currentlyPressedKeys[i] = false;

    onResize.listen((dynamic event){
      Context.glWrapper.resizeCanvas();
    });

    window.onResize.listen(_onWindowResize);

    window.onKeyUp.listen(_onKeyUp);
    window.onKeyDown.listen(_onKeyDown);

    engine.canvas.onMouseDown.listen(_onMouseDown);
    engine.canvas.onMouseMove.listen(_onMouseMove);
    engine.canvas.onMouseUp.listen(_onMouseUp);
    engine.canvas.onMouseWheel.listen(_onMouseWheel);

    engine.canvas.onTouchStart.listen(_onTouchStart);
    engine.canvas.onTouchMove.listen(_onTouchMove);
    engine.canvas.onTouchEnd.listen(_onTouchEnd);
    engine.canvas.onTouchLeave.listen(_onTouchLeave);
    engine.canvas.onTouchCancel.listen(_onTouchCancel);
    engine.canvas.onTouchEnter.listen(_onTouchEnter);
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
    if ((event.keyCode > 0) && (event.keyCode < 128)) {
      _currentlyPressedKeys[event.keyCode] = true;
    }
  }

  void _onKeyUp(KeyboardEvent event) {
    if ((event.keyCode > 0) && (event.keyCode < 128)) {
      _currentlyPressedKeys[event.keyCode] = false;
    }
  }

  void update({num currentTime: 0.0}) {
    engine.currentProject.interactionables
        .forEach((i) => i.onKeyPressed(_currentlyPressedKeys));
  }

  ///
  /// Mouse
  ///

  void _onMouseDown(MouseEvent event) {
    int screenX = event.client.x.toInt();
    int screenY = event.client.y.toInt();
    updateMouseInfos(screenX, screenY);

    engine.currentProject.interactionables.forEach((i)=> i.onMouseDown(screenX, screenY));

    dragging = false;
    mouseDown = true;
    isMiddleMouseButton = event.button == 1;

    _onMouseDownController.add(event);
  }

  void _onMouseMove(MouseEvent event) {
    int screenX = event.client.x.toInt();
    int screenY = event.client.y.toInt();
    updateMouseInfos(screenX, screenY);

    engine.currentProject.interactionables.forEach((i)=> i.onMouseMove(deltaX, deltaY, isMiddleMouseButton));

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

    engine.currentProject.interactionables.forEach((i)=> i.onMouseUp(screenX, screenY));

    dragging = false;
    mouseDown = false;
    isMiddleMouseButton = false;

    _onMouseUpController.add(event);
  }

  void _onMouseWheel(WheelEvent event){
    num deltaY = -event.deltaY;
    deltaY = Math.max(-1, Math.min(1, deltaY))/ 50;
    engine.currentProject.interactionables.forEach((i)=> i.onMouseWheel(deltaY));
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
      engine.currentProject.interactionables.forEach((i)=> i.onTouchStart(null, null));
    }else {
      int screenX = _touchesManager[0].client.x.toInt();
      int screenY = _touchesManager[0].client.y.toInt();
      updateMouseInfos(screenX, screenY);

      engine.currentProject.interactionables.forEach((i)=> i.onTouchStart(screenX, screenY));
    }

    dragging = false;
    mouseDown = true;
    _onTouchStartController.add(event);
  }

  void _onTouchMove(TouchEvent event) {
    _touchesManager.update(event);

    if(event.targetTouches.length > 1){
      engine.currentProject.interactionables.forEach((i)=> i.onTouchMove(null, null, scaleChange : _touchesManager.scaleChange));
//      //position with center of 2 first touches
//      int screenX = (_touchesManager[0].client.x.toInt() + _touchesManager[1].client.x.toInt())~/2;
//      int screenY = (_touchesManager[0].client.y.toInt() + _touchesManager[1].client.y.toInt())~/2;
//      updateMouseInfos(screenX, screenY);
//      cameraController?.updateCameraPosition(mainCamera, deltaX, deltaY, CameraControllerMode.pan);
    }else {
      int screenX = _touchesManager[0].client.x.toInt();
      int screenY = _touchesManager[0].client.y.toInt();
      updateMouseInfos(screenX, screenY);

      engine.currentProject.interactionables.forEach((i)=> i.onTouchMove(deltaX, deltaY));
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
    engine.currentProject.interactionables.forEach((i)=> i.onTouchEnd(screenX, screenY));

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
}

