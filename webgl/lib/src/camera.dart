import 'package:vector_math/vector_math.dart';
import 'dart:math' as Math;
import 'dart:html';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/object3d.dart';
import 'package:webgl/src/utils.dart';

class Camera extends Object3d{
  final double zNear;
  final double zFar;

  double aspectRatio;
  Vector3 position = new Vector3(0.0, 1.0, 0.0);
  Vector3 targetPosition;

  Vector3 upDirection = new Vector3(0.0, 1.0, 0.0);
  Vector3 get frontDirection => targetPosition - position;

  Vector3 get zAxis => frontDirection.normalized();
  Vector3 get xAxis => zAxis.cross(upDirection);
  Vector3 get yAxis => zAxis.cross(xAxis);

  double _fOV;
  double get fOV => _fOV;
  set fOV(num value) {
    _fOV = value;
  }

  CameraController _cameraController;

  set cameraController(CameraController value) {
    _cameraController = value;
    _cameraController.init(this);
  }

  Camera(this._fOV, this.zNear, this.zFar){
  }

  void translate(Vector3 position) {
    this.position = position;
  }

  String toString() {
    return '$position -> $targetPosition';
  }

  //roll on y
  double get yaw {
    Vector3 z = new Vector3(0.0, 0.0, 1.0);
    Vector3 forward = frontDirection;
    forward.normalize();
    return degrees(Math.acos(forward.dot(z)));
  }

  //roll on x
  //Form up 0 to bottom 180°
  double get pitch {
    Vector3 y = new Vector3(0.0, 1.0, 0.0);
    Vector3 forward = frontDirection;
    forward.normalize();
    return degrees(Math.acos(forward.dot(y)));
  }

  //todo get roll ( z )

  //Angle phi/horizontal en coordonée polaire
  double get phiAngle {
    Vector3 z = new Vector3(0.0, 0.0, 1.0);
    Vector3 forwardHorizontal = new Vector3(targetPosition.x, 0.0, targetPosition.z) - new Vector3(position.x, 0.0, position.z);
    forwardHorizontal.normalize();
    num mirrorFactor = forwardHorizontal.x > 0 ? 1.0 : -1.0;
    return mirrorFactor * degrees(Math.acos(forwardHorizontal.dot(z)));
  }

  Matrix4 get perspectiveMatrix {
    return makePerspectiveMatrix(_fOV, aspectRatio, zNear, zFar);
  }

  Matrix4 get lookAtMatrix {
    return makeViewMatrix(position, targetPosition, upDirection);
  }

  Matrix4 get vpMatrix {
    return perspectiveMatrix * lookAtMatrix;
  }

  void rotateOrbitCamera(num xAngleRot, num yAngleRot) {
    num distance = frontDirection
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

  void pan(double deltaX, double deltaY) {
    position += xAxis * deltaX;
    position += yAxis * deltaY;
    targetPosition += xAxis * deltaX;
    targetPosition += yAxis * deltaY;
  }
}

// A simple camera controller which uses an HTML element as the event
// source for constructing a view matrix.
//
// The view matrix is computed elsewhere.

//Todo create multiple controller for each action
//abstract class CameraController {
//  void init(Camera camera);
//}

class CameraController {
  num xRot = 0.0;
  num yRot = 0.0;
  num scaleFactor = 3.0;
  bool dragging = false;
  int currentX = 0;
  int currentY = 0;

  //WheelEvent values
  num fov = radians(45.0);

  CanvasElement canvas;

  CameraController(this.canvas);

  void init(Camera camera) {

    xRot = 90 - camera.pitch;
    yRot = camera.phiAngle;

    // Assign a mouse down handler to the HTML element.
    canvas.onMouseDown.listen((ev) {
      dragging = true;
      currentX = ev.client.x;
      currentY = ev.client.y;
    });

    // Assign a mouse up handler to the HTML element.
    canvas.onMouseUp.listen((MouseEvent ev) {
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

        if (ev.button == 0) {

          // Update the X and Y rotation angles based on the mouse motion.
          yRot = (yRot + deltaX) % 360;
          xRot = (xRot + deltaY);

          // Clamp the X rotation to prevent the camera from going upside down.
          if (xRot < -90) {
            xRot = -90;
          } else if (xRot > 90) {
            xRot = 90;
          }

          //Todo : create first person eye Rotation with ctrl key
          camera.rotateOrbitCamera(yRot, xRot); //why inverted ?


        } else if (ev.button == 1) {
          camera.pan(deltaX, deltaY);
        }
      }

    });

    canvas.onMouseWheel.listen((WheelEvent event) {
      //Todo add zAxis translation

      //Todo with ctrl key..May switch behaviors
      {
        var delta = Math.max(-1, Math.min(1, -event.deltaY));
        fov += delta / 50; //calcul du zoom

        camera.fOV = fov;
      }
    });
  }
}
