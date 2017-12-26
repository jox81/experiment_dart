import 'dart:async';
import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'dart:typed_data';

import 'package:webgl/src/camera.dart';
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/utils/utils_fps.dart';

abstract class Interactable{
  Interaction get interaction;
  CameraPerspective get mainCamera;
  CanvasElement get canvas;

  /// called this in CTOR
  void initInteraction();
}

class Interaction {

  final Interactable _interactable;
  
  //Debug div
  Element elementDebugInfoText;
  Element elementFPSText;

  //Interaction with keyboard
  List<bool> _currentlyPressedKeys;

  bool dragging = false;
  bool mouseDown = false;

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

  StreamController _onDragController = new StreamController<dynamic>.broadcast();
  Stream<dynamic> get onDrag => _onDragController.stream;

  StreamController _onResizeController = new StreamController<dynamic>.broadcast();
  Stream<dynamic> get onResize => _onResizeController.stream;

  Interaction(this._interactable) {
    _initEvents();
  }

  void _initEvents() {
    _currentlyPressedKeys = new List<bool>(128);
    for (int i = 0; i < 128; i++) _currentlyPressedKeys[i] = false;

    // Todo (jpu) : externalise this
    elementDebugInfoText = querySelector("#debugInfosText");
    elementFPSText = querySelector("#fps");

    if(elementFPSText != null) elementFPSText.style.display = 'block';

    window.onKeyUp.listen(_onKeyUp);
    window.onKeyDown.listen(_onKeyDown);

    window.onResize.listen(_onWindowResize);

    _interactable.canvas.onMouseDown.listen(_onMouseDown);
    _interactable.canvas.onMouseMove.listen(_onMouseMove);
    _interactable.canvas.onMouseUp.listen(_onMouseUp);
    _interactable.canvas.onMouseWheel.listen(_onMouseWheel);
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
    UtilsFps.showFps(elementFPSText);
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

    _onMouseDownController.add(event);

  }

  void _onMouseMove(MouseEvent event) {
    int screenX = event.client.x.toInt();
    int screenY = event.client.y.toInt();
    updateMouseInfos(screenX, screenY);

    cameraController?.updateCameraPosition(mainCamera, deltaX, deltaY, event.button);

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

    _onMouseUpController.add(event);
  }

  void _onMouseWheel(WheelEvent event){
    num delatY = -event.deltaY;
    cameraController?.updateCamerFov(mainCamera, delatY);
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
  /// Debug
  ///

  void debugInfo(num posX, num posY, num posZ) {
    var colorPicked = new Uint8List(4);
    //Todo : readPixels doesn't work in dartium...
//    gl.readPixels(posX.toInt(), posY.toInt(), 1, 1, RenderingContext.RGBA, RenderingContext.UNSIGNED_BYTE, colorPicked);
    elementDebugInfoText?.text = '[$posX, $posY, $posZ] : $colorPicked';
  }
}
