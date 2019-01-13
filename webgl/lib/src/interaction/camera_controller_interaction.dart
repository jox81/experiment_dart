import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/interaction/interactionnable.dart';


abstract class CameraControllerInteraction implements Interactionable{
  CameraController get cameraController;
}

class BaseCameraControllerInteraction implements CameraControllerInteraction{

  final BaseCameraController cameraController;

  double _startFov;

  BaseCameraControllerInteraction(this.cameraController);

  @override
  void onMouseDown(int screenX, int screenY) {
    cameraController?.beginOrbit(screenX, screenY);
  }

  @override
  void onMouseMove(double deltaX, double deltaY, bool isMiddleMouseButton) {
    //!! hack : dart doesn't seem to recognize middle mouse button dragging !!
    cameraController.cameraControllerMode = isMiddleMouseButton ? CameraControllerMode.pan:CameraControllerMode.orbit;
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

  @override
  void onTouchStart(int screenX, int screenY) {
    if(screenX == null && screenY == null){
      _startFov = cameraController.yfov;
    }else {
      cameraController?.beginOrbit(screenX, screenY);
    }
  }

  @override
  void onTouchMove(double deltaX, double deltaY, {num scaleChange : 1.0}) {
    if(deltaX == null && deltaY == null){
      //fov
      cameraController.updateCameraFov(_startFov / scaleChange);
    }else {
      // Todo (jpu) : switch mode with orbit menu ?
      cameraController.cameraControllerMode = CameraControllerMode.rotate;
      cameraController?.updateCameraPosition(deltaX, deltaY);
    }
  }

  @override
  void onTouchEnd(int screenX, int screenY) {
    cameraController?.endOrbit();
    _startFov = null;
  }
}