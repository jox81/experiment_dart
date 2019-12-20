import 'dart:math' as Math;
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/camera/camera.dart';
import 'package:webgl/src/gltf/camera/controller/perspective_camera/perspective_camera_controller_types/orbit_perspective_camera_controller.dart';
import 'package:webgl/src/gltf/engine/gltf_engine.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/webgl_objects/context.dart';
import 'package:webgl/src/introspection/introspection.dart';
import 'package:webgl/src/utils/utils_math.dart';

//@reflector
class GLTFCameraPerspective extends GLTFCamera{
  double _aspectRatio = 0.1;
  double get aspectRatio => _aspectRatio;
  set aspectRatio(double value){
    _aspectRatio = value;
  }

  //projectionMatrix
  Matrix4 _projectionMatrix = new Matrix4.identity();
  @override
  Matrix4 get projectionMatrix {
    return (_projectionMatrix * new Matrix4.identity()) as Matrix4;// Why is it needed to update shader uniform!!?
  }
  set projectionMatrix(Matrix4 value){
    _projectionMatrix = value;
//    _updateGizmo();
  }

  //viewMatrix
  Matrix4 _viewMatrix = new Matrix4.identity();
  @override
  Matrix4 get viewMatrix {
    return (_viewMatrix * new Matrix4.identity()) as Matrix4; // Why is it needed to update shader shader uniform!!?
  }

  //viewProjectionMatrix
  Matrix4 get viewProjectionMatrix {
    return (_projectionMatrix * _viewMatrix) as Matrix4;
  }

  double _yfov;
  double get yfov => _yfov;
  set yfov(double value) {
    _yfov = value;
    update();
  }

  Vector3 _targetPosition = new Vector3.all(0.0);
  Vector3 get targetPosition => _targetPosition;
  set targetPosition(Vector3 value) {
    _targetPosition = value;
    update();
  }

  @override
  Vector3 get frontDirection => targetPosition - translation;

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
    Vector3 y = upDirection;
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
            new Vector3(translation.x, 0.0, translation.z);
    forwardHorizontal.normalize();
    double mirrorFactor = forwardHorizontal.x > 0 ? 1.0 : -1.0;
    return mirrorFactor * degrees(Math.acos(forwardHorizontal.dot(z)));
  }

  GLTFCameraPerspective(this._yfov, double znear, double _zfar){
    super.znear = znear;
    super.zfar = _zfar;
    GLTFEngine.currentProject.cameras.add(this);
    GLTFEngine.currentProject.addNode(this);
    GLTFEngine.currentProject.removeNode(this);
    GLTFNode.nextId--;
    cameraController = new OrbitPerspectiveCameraController();
  }

  @override
  update() {
    _aspectRatio = GL.viewAspectRatio;
    setPerspectiveMatrix(_projectionMatrix, _yfov, _aspectRatio, znear, zfar);
    setViewMatrix(_viewMatrix, translation, _targetPosition, upDirection);
//    _updateGizmo();
  }

  @override
  String toString() {
    return 'CameraPerspective{cameraId: $cameraId, _aspectRatio: $_aspectRatio, _yfov: $_yfov, position : $translation, _targetPosition: $_targetPosition, upDirection: $upDirection, _perspectiveMatrix: $_projectionMatrix, _lookAtMatrix: $_viewMatrix, super: ${super.toString()}}';
  }

  // >> JSON

  GLTFCameraPerspective.fromJson(Map json) {
    _yfov = json['fov'] as double;
    znear = json['zNear'] as double;
    zfar = json['zFar'] as double;
    targetPosition = new Vector3.fromFloat32List(new Float32List.fromList(json['targetPosition'] as List<double>));
    translation = new Vector3.fromFloat32List(new Float32List.fromList(json['position'] as List<double>));
//    showGizmo = json['showGizmo'] as bool;
  }

  Map toJson(){
    Map json = new Map<String, dynamic>();
    json['fov'] = UtilsMath.roundPrecision(_yfov);//.toDouble();
    json['zNear'] = UtilsMath.roundPrecision(znear);//.toDouble();
    json['zFar'] = UtilsMath.roundPrecision(zfar);//.toDouble();
    json['targetPosition'] = targetPosition.storage.map((v)=> UtilsMath.roundPrecision(v)).toList();
    json['position'] = translation.storage.map((v)=>UtilsMath.roundPrecision(v)).toList();
//    json['showGizmo'] = showGizmo;
    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          super == other &&
              other is GLTFCameraPerspective &&
              cameraId == other.cameraId &&
              _aspectRatio == other._aspectRatio &&
              _yfov == other._yfov &&
              _targetPosition == other._targetPosition &&
              upDirection == other.upDirection &&
              _projectionMatrix == other._projectionMatrix &&
              _viewMatrix == other._viewMatrix;

  @override
  int get hashCode =>
      super.hashCode ^
      _aspectRatio.hashCode ^
      _yfov.hashCode ^
      _targetPosition.hashCode ^
      upDirection.hashCode ^
      _projectionMatrix.hashCode ^
      _viewMatrix.hashCode;
}