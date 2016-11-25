import 'dart:html';
import 'dart:web_gl';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/globals/context.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/utils.dart';
import 'dart:typed_data';
import 'package:gl_enums/gl_enums.dart' as GL;

class Interaction {

  RenderingContext gl;
  final Scene scene;

  //Debug div
  Element elementDebugInfoText;
  Element elementFPSText;
  //Interaction with keyboard
  List<bool> _currentlyPressedKeys;

  Interaction(this.scene, this.gl) {
    _initEvents();
  }

  ///
  ///Keyboard
  ///
  void _onKeyDown(KeyboardEvent event) {
    if (KeyCode.UP == event.keyCode || KeyCode.DOWN == event.keyCode) {
      if ((elementDebugInfoText != null)) {
        elementDebugInfoText.text =
            "Camera Position: ${mainCamera.position}";
        print(event.keyCode);
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

  void _initEvents() {
    //Without specifying size this array throws exception on []
    _currentlyPressedKeys = new List<bool>(128);
    for (int i = 0; i < 128; i++) _currentlyPressedKeys[i] = false;

    window.onKeyUp.listen(_onKeyUp);
    window.onKeyDown.listen(_onKeyDown);

    elementDebugInfoText = querySelector("#debugInfosText");
    elementFPSText = querySelector("#fps");

    gl.canvas.onMouseMove.listen((MouseEvent e) {
//      debugInfo(e.offset.x, e.offset.y,0);
      Matrix4 cameraMatix = mainCamera.vpMatrix;
      Vector3 worldPick = Utils.screenToWorld(cameraMatix, scene.application.width, scene.application.height, e.offset.x, e.offset.y);

//      debugInfo(worldPick.x, worldPick.y, worldPick.z);
    });

    gl.canvas.onMouseUp.listen((MouseEvent e) {
      Matrix4 cameraMatix = mainCamera.vpMatrix;
      Vector3 worldPick = Utils.screenToWorld(cameraMatix, scene.application.width, scene.application.height, e.offset.x, e.offset.y);
//      scene.createLine(new Vector3.all(0.0), worldPick);
    });
  }

  void debugInfo(num posX, num posY, num posZ) {
    var colorPicked = new Uint8List(4);
    //Todo : readPixels doesn't work in dartium...
    gl.readPixels(posX.toInt(), posY.toInt(), 1, 1, GL.RGBA, GL.UNSIGNED_BYTE, colorPicked);
    elementDebugInfoText.text = '[$posX, $posY, $posZ] : $colorPicked';
  }
}
