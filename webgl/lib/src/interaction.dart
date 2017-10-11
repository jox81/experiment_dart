import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/geometry/models.dart';
import 'package:webgl/src/scene.dart';
import 'dart:typed_data';
import 'package:webgl/src/utils/utils_fps.dart';
import 'package:webgl/src/geometry/utils_geometry.dart';

class Interaction {

  Scene get scene => Application.instance.currentScene as Scene;

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

  Interaction() {
    _initEvents();
  }

  void _initEvents() {
    _currentlyPressedKeys = new List<bool>(128);
    for (int i = 0; i < 128; i++) _currentlyPressedKeys[i] = false;

    elementDebugInfoText = querySelector("#debugInfosText");
    elementFPSText = querySelector("#fps")
    ..style.display = 'block';

    window.onResize.listen(_onWindowResize);
    window.onKeyUp.listen(_onKeyUp);
    window.onKeyDown.listen(_onKeyDown);

    gl.canvas.onMouseDown.listen(_onMouseDown);
    gl.canvas.onMouseMove.listen(_onMouseMove);
    gl.canvas.onMouseUp.listen(_onMouseUp);
    gl.canvas.onMouseWheel.listen((WheelEvent event) {
      num delatY = -event.deltaY;
      Context.mainCamera.cameraController.updateCamerFov(Context.mainCamera, delatY);
    });
  }

  ///
  /// Window
  ///

  void _onWindowResize (Event event) {
    Application.instance.resizeCanvas();
  }

  ///
  /// Keyboard
  ///

  void _onKeyDown(KeyboardEvent event) {
    if (KeyCode.UP == event.keyCode || KeyCode.DOWN == event.keyCode) {
      if ((elementDebugInfoText != null)) {
        elementDebugInfoText.text =
            "Camera Position: ${Context.mainCamera.position}";
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

  ///Bug correctif, Mouse down trigger mouse move...
  ///
//  num mouseMoveX = 0;
//  num mouseMoveY = 0;

  Model tempSelection;
  void _onMouseDown(MouseEvent event) {
    int screenX = event.client.x.toInt();
    int screenY = event.client.y.toInt();
    updateMouseInfos(screenX, screenY);

    Context.mainCamera.cameraController.beginOrbit(Context.mainCamera, screenX, screenY);

    dragging = false;
    mouseDown = true;

//    mouseMoveX = event.client.x;
//    mouseMoveY = event.client.y;

//    print('_onMouseDown ${dragging} : ${event.client.x} / ${event.client.y}');

    Model modelHit = UtilsGeometry.findModelFromMouseCoords(Context.mainCamera, event.offset.x, event.offset.y, scene.models);
    tempSelection = modelHit;
  }

  void _onMouseMove(MouseEvent event) {
    int screenX = event.client.x.toInt();
    int screenY = event.client.y.toInt();
    updateMouseInfos(screenX, screenY);
//    print('_onMouseMove ${dragging} : ${event.client.x} / ${event.client.y}');

    Context.mainCamera?.cameraController?.updateCameraPosition(Context.mainCamera, deltaX, deltaY, event.button);

    if(mouseDown /*&& (event.client.x != mouseMoveX || event.client.y != mouseMoveY)*/) {

      dragging = true;

      if(Application.instance.activeTool == ActiveToolType.move ||
        Application.instance.activeTool == ActiveToolType.rotate ||
        Application.instance.activeTool == ActiveToolType.scale) {
        scene.currentSelection = tempSelection;
      }

      if(scene.currentSelection != null && scene.currentSelection is Model) {

        Model currentModel = scene.currentSelection as Model;

        double delta = deltaX.toDouble(); // get mouse delta
        double deltaMoveX = (Application.instance.activeAxis[AxisType.x]
            ? 1
            : 0) * delta;
        double deltaMoveY = (Application.instance.activeAxis[AxisType.y]
            ? 1
            : 0) * delta;
        double deltaMoveZ = (Application.instance.activeAxis[AxisType.z]
            ? 1
            : 0) * delta;

        if (Application.instance.activeTool == ActiveToolType.move) {
          double moveFactor = 1.0;

          currentModel.transform.translate(
              new Vector3(deltaMoveX * moveFactor, deltaMoveY * moveFactor, deltaMoveZ * moveFactor));
        }

        if (Application.instance.activeTool == ActiveToolType.rotate) {
          num rotateFactor = 1.0;

          currentModel.transform.rotateX(deltaMoveX * rotateFactor);
          currentModel.transform.rotateY(deltaMoveY * rotateFactor);
          currentModel.transform.rotateY(deltaMoveZ * rotateFactor);
        }

        if (Application.instance.activeTool == ActiveToolType.scale) {
          num scaleFactor = 0.03;

          currentModel.transform.scale( 1.0 + deltaMoveX * scaleFactor, 1.0 + deltaMoveY * scaleFactor, 1.0 + deltaMoveZ * scaleFactor,);
        }
      }
    }else{
      dragging = false;
    }
  }

  void _onMouseUp(MouseEvent event) {

    int screenX = event.client.x.toInt();
    int screenY = event.client.y.toInt();
    updateMouseInfos(screenX, screenY);
    Context.mainCamera.cameraController.endOrbit(Context.mainCamera);

    print('_onMouseUp ${dragging} : ${event.client.x} / ${event.client.y}');
    if(!dragging) {
      scene.currentSelection = tempSelection;
    }

    dragging = false;
    mouseDown = false;
  }

  // Determine how far we have moved since the last mouse move event.
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
