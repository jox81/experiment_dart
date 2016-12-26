import 'dart:html';
import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/context.dart';

class CameraController {
  num xRot = 0.0;
  num yRot = 0.0;
  num scaleFactor = 3.0;
  bool dragging = false;
  int currentX = 0;
  int currentY = 0;

  //WheelEvent values
  num fov = radians(45.0);

  CameraController();

  Camera _camera;

  void init(Camera camera) {
    _camera = camera;
    xRot = 90 - camera.pitch;
    yRot = camera.phiAngle;

    // Assign a mouse down handler to the HTML element.
    gl.canvas.onMouseDown.listen((ev) {
      if (camera.active) {
        beginOrbit(camera, ev.client.x, ev.client.y);
      }
    });

    // Assign a mouse up handler to the HTML element.
    gl.canvas.onMouseUp.listen((MouseEvent ev) {
      if (camera.active) {
        endOrbit(camera);
      }
    });

    // Assign a mouse move handler to the HTML element.
    gl.canvas.onMouseMove.listen((MouseEvent ev) {
      if (camera.active) {
        if (dragging) {
          // Determine how far we have moved since the last mouse move event.
          int tempCurX = ev.client.x;
          int tempCurY = ev.client.y;
          var deltaX = (currentX - tempCurX) / scaleFactor;
          var deltaY = (currentY - tempCurY) / scaleFactor;
          currentX = tempCurX;
          currentY = tempCurY;

          if (ev.button == 0) {
            //LMB
            doOrbit(deltaX, deltaY);

          } else if (ev.button == 1) {
            //MMB
            deltaX *= 0.5;
            deltaY *= 0.5;
            pan(deltaX, deltaY);
          }
        }
      }
    });

    gl.canvas.onMouseWheel.listen((WheelEvent event) {
      changeCameraFov(camera, -event.deltaY);
    });
  }

  /// Update the X and Y rotation angles based on the mouse motion.
  void doOrbit(double deltaX, double deltaY) {
    //LMB
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
    rotateOrbit(yRot, xRot); //why inverted ?
  }

  void beginOrbit(Camera camera, int screenX, int screenY) {
    dragging = true;
    currentX = screenX;
    currentY = screenY;
  }

  void endOrbit(Camera camera) {
    dragging = false;
  }

  void changeCameraFov(Camera camera, num deltaY) {
    var delta = Math.max(-1, Math.min(1, deltaY));
    fov += delta / 50; //calcul du zoom

    camera.fov = fov;
  }

  void rotateOrbit(num xAngleRot, num yAngleRot) {
    num distance = _camera.frontDirection
        .length; // Straight line distance between the camera and look at point

    // Calculate the camera position using the distance and angles
    num camX = _camera.targetPosition.x +
        distance *
            -Math.sin(xAngleRot * (Math.PI / 180)) *
            Math.cos((yAngleRot) * (Math.PI / 180));
    num camY = _camera.targetPosition.y +
        distance * -Math.sin((yAngleRot) * (Math.PI / 180));
    num camZ = _camera.targetPosition.z +
        -distance *
            Math.cos((xAngleRot) * (Math.PI / 180)) *
            Math.cos((yAngleRot) * (Math.PI / 180));

    _camera.position = _camera.position..setValues(camX, camY, camZ);
  }

  void pan(double deltaX, double deltaY) {
    _camera.position += _camera.xAxis * deltaX;
    _camera.position += _camera.yAxis * deltaY;
    _camera.targetPosition += _camera.xAxis * deltaX;
    _camera.targetPosition += _camera.yAxis * deltaY;
  }
}
