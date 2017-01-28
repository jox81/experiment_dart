import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/application.dart';

import 'package:webgl/src/context.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/utils.dart';
import 'dart:typed_data';

class Interaction {

  Scene get scene => Application.currentScene as Scene;

  //Debug div
  Element elementDebugInfoText;
  Element elementFPSText;

  //Interaction with keyboard
  List<bool> _currentlyPressedKeys;

  bool dragging = false;
  bool mouseDown = false;

  int currentX = 0;
  int currentY = 0;
  num deltaX = 0.0;
  num deltaY = 0.0;

  num scaleFactor = 3.0;

  Interaction() {
    _initEvents();
  }

  void _initEvents() {
    //Without specifying size this array throws exception on []
    _currentlyPressedKeys = new List<bool>(128);
    for (int i = 0; i < 128; i++) _currentlyPressedKeys[i] = false;

    elementDebugInfoText = querySelector("#debugInfosText");
    elementFPSText = querySelector("#fps");

    window.onResize.listen(_onWindowResize);
    window.onKeyUp.listen(_onKeyUp);
    window.onKeyDown.listen(_onKeyDown);

    gl.canvas.onMouseDown.listen(_onMouseDown);
    gl.canvas.onMouseMove.listen(_onMouseMove);
    gl.canvas.onMouseUp.listen(_onMouseUp);
  }

  ///
  /// Window
  ///

  _onWindowResize (event) {
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
//        print(event.keyCode);
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

  Model tempSelection;
  void _onMouseDown(MouseEvent event) {
    updateMouseInfos(event);
    dragging = false;
    mouseDown = true;


    Model modelHit = Utils.findModelFromMouseCoords(Context.mainCamera, event.offset.x, event.offset.y, scene.models);
    tempSelection = modelHit;

  }

  void _onMouseMove(MouseEvent event) {
    updateMouseInfos(event);

    if(mouseDown) {
      dragging = true;

      if(Application.instance.activeTool == ToolType.move ||
        Application.instance.activeTool == ToolType.rotate ||
        Application.instance.activeTool == ToolType.scale) {
        scene.currentSelection = tempSelection;
      }

      if(scene.currentSelection != null && scene.currentSelection is Model) {

        Model currentModel = scene.currentSelection as Model;

        num delta = deltaX; // get mouse delta
        num deltaMoveX = (Application.instance.activeAxis[AxisType.x]
            ? 1
            : 0) * delta;
        num deltaMoveY = (Application.instance.activeAxis[AxisType.y]
            ? 1
            : 0) * delta;
        num deltaMoveZ = (Application.instance.activeAxis[AxisType.z]
            ? 1
            : 0) * delta;

//        print('$deltaMoveX, $deltaMoveY, $deltaMoveZ');

        if (Application.instance.activeTool == ToolType.move) {
          num moveFactor = 1.0;

          currentModel.transform.translate(
              new Vector3(deltaMoveX * moveFactor, deltaMoveY * moveFactor, deltaMoveZ * moveFactor));
        }

        if (Application.instance.activeTool == ToolType.rotate) {
          num rotateFactor = 1.0;

          currentModel.transform.rotateX(deltaMoveX * rotateFactor);
          currentModel.transform.rotateY(deltaMoveY * rotateFactor);
          currentModel.transform.rotateY(deltaMoveZ * rotateFactor);
        }

        if (Application.instance.activeTool == ToolType.scale) {
          num scaleFactor = 0.03;

          currentModel.transform.scale( 1.0 + deltaMoveX * scaleFactor, 1.0 + deltaMoveY * scaleFactor, 1.0 + deltaMoveZ * scaleFactor,);
        }
      }
    }else{
      dragging = false;
    }
  }

  void _onMouseUp(MouseEvent event) {


    if(tempSelection != null && !dragging) {
      scene.currentSelection = tempSelection;
    }

    dragging = false;
    mouseDown = false;

  }

  void updateMouseInfos(MouseEvent event) {
    int tempScreenX = event.client.x;
    int tempScreenY = event.client.y;
    deltaX = (currentX - tempScreenX) / scaleFactor;
    deltaY = (currentY - tempScreenY) / scaleFactor;
    currentX = tempScreenX;
    currentY = tempScreenY;
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
    elementDebugInfoText.text = '[$posX, $posY, $posZ] : $colorPicked';
  }
}
