import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/scene.dart';
import 'dart:typed_data';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:webgl/src/application.dart';

class Interaction{

  final Scene scene;

  //Debug div
  Element elementDebugInfoText;
  Element elementFPSText;
  //Interaction with keyboard
  List<bool> _currentlyPressedKeys;

  Interaction(this.scene){
    _initEvents();
  }

  ///
  ///Keyboard
  ///
  void _onKeyDown(KeyboardEvent event) {
    if (KeyCode.UP == event.keyCode || KeyCode.DOWN == event.keyCode) {
      if ((elementDebugInfoText != null)) {
        elementDebugInfoText.text = "Camera Position: ${scene.mainCamera.position}";
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
      scene.mainCamera.translate(new Vector3(0.0, 0.0, 0.1));
    }
    if (_currentlyPressedKeys[KeyCode.DOWN]) {
      // Key Down
      scene.mainCamera.translate(new Vector3(0.0, 0.0, -0.1));
    }
    if (_currentlyPressedKeys[KeyCode.LEFT]) {
      // Key Up
      scene.mainCamera.translate(new Vector3(-0.1, 0.0, 0.0));
    }
    if (_currentlyPressedKeys[KeyCode.RIGHT]) {
      // Key Down
      scene.mainCamera.translate(new Vector3(0.1, 0.0, 0.0));
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

    gl.canvas.onMouseMove.listen((e) {
      // do something with mouse coordinates
      // e.client.x, e.client.y
      debugInfo(e.client.x, e.client.y);
    });

  }

  void debugInfo(int posX, int posY){
    var colorPicked = new Uint8List(4);
    //Todo : doesn't work...
    gl.readPixels(posX, posY, 1, 1, GL.RGBA, GL.UNSIGNED_BYTE, colorPicked);
    elementDebugInfoText.text = '[$posX, $posY] : $colorPicked';
  }

}