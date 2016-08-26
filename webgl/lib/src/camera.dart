import 'package:vector_math/vector_math.dart';
import 'dart:math' as Math;
import 'dart:html';
import 'package:webgl/src/application.dart';

class Camera {
  final double zNear;
  final double zFar;

  double _fOV;
  set fOV(num value){
    _fOV = value;
  }

  double aspectRatio;
  Vector3 position;
  Vector3 upDirection;
  Vector3 targetPosition;

  CameraController _cameraController;
  set cameraController(CameraController value){
    _cameraController = value;
    _cameraController.init(this);
  }

  Camera(this._fOV, this.aspectRatio, this.zNear, this.zFar) {
    position = new Vector3(0.0, 2.0, 0.0);
    targetPosition = new Vector3(1.0, 2.0, -1.0);
    upDirection = new Vector3(0.0, 1.0, 0.0);

//    fOV = 0.35;
//    zNear = 1.0;
//    zFar = 1000.0;
//    aspectRatio = 1.7777778;
  }

  void translate(Vector3 position) {
    this.position = position;
  }

  String toString() {
    return '$position -> $targetPosition';
  }

  double get yaw {
    Vector3 z = new Vector3(0.0, 0.0, 1.0);
    Vector3 forward = frontDirection;
    forward.normalize();
    return degrees(Math.acos(forward.dot(z)));
  }

  double get pitch {
    Vector3 y = new Vector3(0.0, 1.0, 0.0);
    Vector3 forward = frontDirection;
    forward.normalize();
    return degrees(Math.acos(forward.dot(y)));
  }

  Matrix4 get projectionMatrix {
    return makePerspectiveMatrix(_fOV, aspectRatio, zNear, zFar);
  }

  Matrix4 get lookAtMatrix {
    return makeViewMatrix(position, targetPosition, upDirection);
  }

  Matrix4 get matrix {
    return projectionMatrix * lookAtMatrix;
  }

  Vector3 get frontDirection => targetPosition - position;

  void rotateCamera(num xAngleRot, num yAngleRot) {
    num distance = (-position + targetPosition)
        .length; // Straight line distance between the camera and look at point

    // Calculate the camera position using the distance and angles
    num camX = targetPosition.x +
        distance *
            -Math.sin(xAngleRot * (Math.PI / 180)) *
            Math.cos((yAngleRot) * (Math.PI / 180));
    num camY =
        targetPosition.y + distance * -Math.sin((yAngleRot) * (Math.PI / 180));
    num camZ = targetPosition.z +
        -distance *
            Math.cos((xAngleRot) * (Math.PI / 180)) *
            Math.cos((yAngleRot) * (Math.PI / 180));

    position.setValues(camX, camY, camZ);
  }
}

// A simple camera controller which uses an HTML element as the event
// source for constructing a view matrix. Assign an "onchange"
// function to the controller as follows to receive the updated X and
// Y angles for the camera:
//
//    cameraController.onChange = (num xRot, num yRot){
//      camera.rotateCamera(xRot, yRot);
//    };
//
// The view matrix is computed elsewhere.

typedef void OnChange(Camera camera, num xRot, num yRot, num fov);

abstract class CameraController{
  void init(Camera camera);
}

class CameraControllerOrbit extends CameraController {

  num xRot = 0;
  num yRot = 0;
  num scaleFactor = 3.0;
  bool dragging = false;
  int currentX = 0;
  int currentY = 0;

  //WheelEvent values
  num fov = radians(45.0);

  OnChange _onChange;

  CameraControllerOrbit() {}

  void init(Camera camera){

    CanvasElement canvas = Application.gl.canvas;

    _onChange = _onChangeHandler;
    // Assign a mouse down handler to the HTML element.
    canvas.onMouseDown.listen((ev) {
      dragging = true;
      currentX = ev.client.x;
      currentY = ev.client.y;
    });

    // Assign a mouse up handler to the HTML element.
    canvas.onMouseUp.listen((ev) {
      dragging = false;
    });

    // Assign a mouse move handler to the HTML element.
    canvas.onMouseMove.listen((MouseEvent ev) {
      if (dragging) {
        // Determine how far we have moved since the last mouse move event.
        int tempCurX = ev.client.x;
        int tempCurY = ev.client.y;
        var deltaX = (currentX - tempCurX) / scaleFactor;
        var deltaY = (currentY - tempCurY) / scaleFactor;
        currentX = tempCurX;
        currentY = tempCurY;

        // Update the X and Y rotation angles based on the mouse motion.
        yRot = (yRot + deltaX) % 360;
        xRot = (xRot + deltaY);

        // Clamp the X rotation to prevent the camera from going upside down.
        if (xRot < -90) {
          xRot = -90;
        } else if (xRot > 90) {
          xRot = 90;
        }

        // Send the onChange event to any listener.
        if (_onChange != null) {
          _onChange(camera, yRot, xRot, fov);
        }
      }
    });

    canvas.onMouseWheel.listen((WheelEvent event) {
      var delta = Math.max(-1, Math.min(1, -event.deltaY));
      fov += delta / 50; //calcul du zoom

      // Send the onChange event to any listener.
      if (_onChange != null) {
        _onChange(camera, yRot, xRot, fov);
      }
    });
  }

  void _onChangeHandler(Camera camera, num xRot, num yRot, num fov) {
    camera.rotateCamera(xRot, yRot);
    camera.fOV = fov;
  }
}
