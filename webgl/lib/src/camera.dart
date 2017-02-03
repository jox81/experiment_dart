import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'dart:math' as Math;
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/interface/IGizmo.dart';
import 'package:webgl/src/models.dart';
@MirrorsUsed(
    targets: const [
      Camera,
    ],
    override: '*')
import 'dart:mirrors';

class Camera extends Object3d {

  bool _isActive = false;
  bool get isActive => _isActive;
  set isActive(bool value) {
    _isActive = value;
  }

  double _aspectRatio;
  set aspectRatio(double value){
    _aspectRatio = value;
  }
  double get aspectRatio => _aspectRatio != null ? _aspectRatio : Context.viewAspectRatio;

  double _fov;
  double get fov => _fov;
  set fov(num value) {
    _fov = value;
    update();
  }

  double _zNear;
  double get zNear => _zNear;
  set zNear(double value) {
    _zNear = value;
    update();
  }

  double _zFar;
  double get zFar => _zFar;
  set zFar(double value) {
    _zFar = value;
    update();
  }

  set position(Vector3 value) {
   super.position = value;
    update();
  }
  set transform(Matrix4 value) {
   super.transform = value;
    update();
  }

  Vector3 _targetPosition = new Vector3.all(0.0);
  Vector3 get targetPosition => _targetPosition;
  set targetPosition(Vector3 value) {
    _targetPosition = value;
    update();
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
    this.position += value;
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

  //projectionMatrix
  Matrix4 _perspectiveMatrix = new Matrix4.identity();
  Matrix4 get perspectiveMatrix {
    return _perspectiveMatrix;
  }
  set perspectiveMatrix(Matrix4 value){
    _perspectiveMatrix = value;
    _updateGizmo();
  }

  //viewMatrix
  Matrix4 _lookAtMatrix = new Matrix4.identity();
  Matrix4 get lookAtMatrix {
    return _lookAtMatrix;
  }

  //viewProjectionMatrix
  Matrix4 get viewProjecionMatrix {
    return perspectiveMatrix * lookAtMatrix;
  }

  @override
  void render() {
    if (_gizmo.visible && !_isActive) {
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

  update() {
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

  static Camera createFromJson(Map json) {
    Camera camera =  new Camera(json['fov'] as num, json['zNear'] as num, json['zFar'] as num);
    camera.targetPosition = new Vector3.fromFloat32List(new Float32List.fromList(json['targetPosition']));
    camera.position = new Vector3.fromFloat32List(new Float32List.fromList(json['position']));
    camera.showGizmo = json['showGizmo'] as bool;
    return camera;
  }
}



