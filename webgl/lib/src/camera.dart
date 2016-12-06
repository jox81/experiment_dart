import 'package:vector_math/vector_math.dart';
import 'dart:math' as Math;
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/globals/context.dart';
import 'package:webgl/src/interface/IGizmo.dart';
import 'package:webgl/src/models.dart';

class Camera extends Model {

  bool _active = false;
  bool get active => _active;
  set active(bool value) {
    _active = value;
  }

  double get aspectRatio => Context.viewAspectRatio;

  double _fov;
  double get fov => _fov;
  set fov(num value) {
    _fov = value;
    _update();
  }

  double _zNear;
  double get zNear => _zNear;
  set zNear(double value) {
    _zNear = value;
    _update();
  }

  double _zFar;
  double get zFar => _zFar;
  set zFar(double value) {
    _zFar = value;
    _update();
  }

  set position(Vector3 value) {
   super.position = value;
    _update();
  }
  set transform(Matrix4 value) {
   super.transform = value;
    _update();
  }

  Vector3 _targetPosition;
  Vector3 get targetPosition => _targetPosition;
  set targetPosition(Vector3 value) {
    _targetPosition = value;
    _update();
  }

  Vector3 upDirection = new Vector3(0.0, 1.0, 0.0);
  Vector3 get frontDirection => targetPosition - position;

  Vector3 get zAxis => frontDirection.normalized();
  Vector3 get xAxis => zAxis.cross(upDirection);
  Vector3 get yAxis => zAxis.cross(xAxis);

  CameraController _cameraController;
  set cameraController(CameraController value) {
    _cameraController = value;
    _cameraController.init(this);
  }

  Camera(this._fov, this._zNear, this._zFar) {

  }

  void translate(Vector3 value) {
    this.position = position;
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
    Vector3 forwardHorizontal =
        new Vector3(targetPosition.x, 0.0, targetPosition.z) -
            new Vector3(position.x, 0.0, position.z);
    forwardHorizontal.normalize();
    num mirrorFactor = forwardHorizontal.x > 0 ? 1.0 : -1.0;
    return mirrorFactor * degrees(Math.acos(forwardHorizontal.dot(z)));
  }

  Matrix4 _perspectiveMatrix = new Matrix4.identity();
  Matrix4 get perspectiveMatrix {
    return _perspectiveMatrix;
  }
  set perspectiveMatrix(Matrix4 value){
    _perspectiveMatrix = value;
    _update();
  }

  Matrix4 _lookAtMatrix = new Matrix4.identity();
  Matrix4 get lookAtMatrix {
    return _lookAtMatrix;
  }

  Matrix4 get vpMatrix {
    return perspectiveMatrix * lookAtMatrix;
  }

  @override
  void render() {
    if (_gizmo.visible && !_active) {
      _gizmo.render();
    }
  }

  //FrustrumGizmo
  FrustrumGizmo _gizmo;
  IGizmo get gizmo => _gizmo;

  bool get showGizmo => _gizmo.visible;
  set showGizmo(bool value) {
    if(_gizmo == null){
      _gizmo = new FrustrumGizmo(this);
    }
    _gizmo.visible = value;
  }

  _update() {
    setPerspectiveMatrix(_perspectiveMatrix, _fov, aspectRatio, _zNear, _zFar);
    setViewMatrix(_lookAtMatrix, position, _targetPosition, upDirection);
    _updateGizmo();
  }
  _updateGizmo() {
    if(_gizmo != null && _gizmo.visible)gizmo.updateGizmo();
  }

  String toString() {
    return 'camera position : $position -> target : $targetPosition';
  }
}



