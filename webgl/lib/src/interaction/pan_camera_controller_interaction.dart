import 'dart:html';
import 'dart:typed_data';
import 'package:webgl/src/controllers/base_camera_controller.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/interaction/camera_controller_interaction.dart';

class PanCameraControllerInteraction implements CameraControllerInteraction{

  final BaseCameraController cameraController;

  Element _elementDebugInfoText;
  double _startFov;

  PanCameraControllerInteraction(this.cameraController){
    _elementDebugInfoText = querySelector("#debugInfosText");
  }

  ///Mouse

  @override
  void onMouseDown(int screenX, int screenY) {
    cameraController?.beginOrbit();
  }

  @override
  void onMouseMove(double deltaX, double deltaY, bool isMiddleMouseButton) {
    cameraController?.updateCameraPosition(deltaX, deltaY);
  }

  @override
  void onMouseUp(int screenX, int screenY) {
    cameraController?.endOrbit();
  }

  @override
  void onMouseWheel(num deltaY) {
    cameraController?.updateCameraFov(deltaY);
  }

  ///Touch

  @override
  void onTouchStart(int screenX, int screenY) {
    if(screenX == null && screenY == null){
      _startFov = cameraController?.yfov;
    }else {
      cameraController?.beginOrbit();
    }
  }

  @override
  void onTouchMove(double deltaX, double deltaY, {num scaleChange : 1.0}) {
    if(deltaX == null && deltaY == null){
      //fov
      cameraController?.updateCameraFov(_startFov / scaleChange);
    }else {
      cameraController?.updateCameraPosition(deltaX, deltaY);
    }
  }

  @override
  void onTouchEnd(int screenX, int screenY) {
    cameraController?.endOrbit();
    _startFov = null;
  }

  ///Keyboard
  ///
  @override
  void onKeyPressed(List<bool> currentlyPressedKeys) {
    _handleKeys(currentlyPressedKeys);
  }

  void _handleKeys(List<bool> currentlyPressedKeys) {
    updateOrbit(currentlyPressedKeys);
    updateFov(currentlyPressedKeys);
  }

  void updateFov(List<bool> currentlyPressedKeys) {
    num fovAmplitude = 0.01;
    if (currentlyPressedKeys[KeyCode.NUM_MINUS]) {
      cameraController?.updateCameraFov(-fovAmplitude);
    }
    if (currentlyPressedKeys[KeyCode.NUM_PLUS]) {
      cameraController?.updateCameraFov(fovAmplitude);
    }
  }

  void updateOrbit(List<bool> currentlyPressedKeys) {
    double orbitAmplitude = 1.0;
    Vector2 direction = new Vector2.zero();

    if (currentlyPressedKeys[KeyCode.UP]) {
      direction += new Vector2(0.0, -orbitAmplitude);
    }
    if (currentlyPressedKeys[KeyCode.DOWN]) {
      direction += new Vector2(0.0, orbitAmplitude);
    }
    if (currentlyPressedKeys[KeyCode.LEFT]) {
      direction += new Vector2(-orbitAmplitude, 0.0);
    }
    if (currentlyPressedKeys[KeyCode.RIGHT]) {
      direction += new Vector2(orbitAmplitude, 0.0);
    }

    if(direction != new Vector2.zero()) {
      cameraController?.beginOrbit();
      cameraController?.updateCameraPosition(direction.x, direction.y);
      cameraController?.endOrbit();
    }
  }

  ///
  /// Debug
  ///

  void debugInfo(num posX, num posY, num posZ) {
    var colorPicked = new Uint8List(4);
    //Todo : readPixels doesn't work in dartium...
//    gl.readPixels(posX.toInt(), posY.toInt(), 1, 1, RenderingContext.RGBA, RenderingContext.UNSIGNED_BYTE, colorPicked);
    _elementDebugInfoText?.text = '[$posX, $posY, $posZ] : $colorPicked';
  }
}
