import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'dart:math' as Math;
import 'package:webgl/src/geometry/object3d.dart';
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';
import 'package:webgl/src/interface/IGizmo.dart';
import 'package:webgl/src/geometry/models.dart';
import 'package:gltf/gltf.dart' as glTF hide Context;
import 'context.dart';
@MirrorsUsed(
    targets: const [
      Camera,
    ],
    override: '*')
import 'dart:mirrors';
import 'package:webgl/src/utils/utils_math.dart';

enum CameraType{
  perspective,
  orthographic
}

abstract class Camera extends Object3d {

  bool _isActive = false;

  int cameraId;

  glTF.Camera get gltfSource;

  static Camera fromGltf(glTF.Camera gltfCamera){
    if(gltfCamera != null) {
      if (gltfCamera.perspective != null)
        return new GLTFCameraPerspective.fromGltf(gltfCamera);
      if (gltfCamera.orthographic != null)
        return new GLTFCameraOrthographic.fromGltf(gltfCamera);
    }
    return null;
  }

  CameraType _type;
  CameraType get type => _type;

  bool get isActive => _isActive;

  set isActive(bool value) {
    _isActive = value;
  }

  set position(Vector3 value) {
   super.position = value;
    update();
  }
  set transform(Matrix4 value) {
   super.transform = value;
    update();
  }

  double _znear;
  double get znear => _znear;
  set znear(double value) {
    _znear = value;
    update();
  }

  double _zfar;
  double get zfar => _zfar;
  set zfar(double value) {
    _zfar = value;
    update();
  }

  CameraController _cameraController;
  set cameraController(CameraController value) {
    _cameraController = value;
    _cameraController.init(this as GLTFCameraPerspective);// Todo (jpu) : ??
  }
  CameraController get cameraController => _cameraController;

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
      _gizmo = new FrustrumGizmo(this as GLTFCameraPerspective);// Todo (jpu) : ??
    }
    _gizmo.visible = value;
  }


  void _updateGizmo() {
    if(_gizmo != null && _gizmo.visible)gizmo.updateGizmo();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Camera &&
              runtimeType == other.runtimeType &&
              _isActive == other._isActive &&
              _type == other._type &&
              _znear == other._znear &&
              _zfar == other._zfar &&
              _cameraController == other._cameraController &&
              _gizmo == other._gizmo;

  @override
  int get hashCode =>
      _isActive.hashCode ^
      _type.hashCode ^
      _znear.hashCode ^
      _zfar.hashCode ^
      _cameraController.hashCode ^
      _gizmo.hashCode;
}

class GLTFCameraPerspective extends Camera{
  double _aspectRatio = 0.1;
  double get aspectRatio => _aspectRatio;
//  set aspectRatio(double value){
//    _aspectRatio = value;
//  }

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

  Vector3 upDirection = new Vector3(0.0, 1.0, 0.0);
  Vector3 get frontDirection => targetPosition - position;

  Vector3 get zAxis => frontDirection.normalized();
  Vector3 get xAxis => zAxis.cross(upDirection);
  Vector3 get yAxis => zAxis.cross(xAxis);

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
    double mirrorFactor = forwardHorizontal.x > 0 ? 1.0 : -1.0;
    return mirrorFactor * degrees(Math.acos(forwardHorizontal.dot(z)));
  }

  //projectionMatrix
  Matrix4 _projectionMatrix = new Matrix4.identity();
  Matrix4 get projectionMatrix {
    return (_projectionMatrix * new Matrix4.identity()) as Matrix4;// Why is it needed to update shader uniform!!?
  }
  set projectionMatrix(Matrix4 value){
    _projectionMatrix = value;
    _updateGizmo();
  }

  //viewMatrix
  Matrix4 _viewMatrix = new Matrix4.identity();
  Matrix4 get viewMatrix {
    return (_viewMatrix * new Matrix4.identity()) as Matrix4; // Why is it needed to update shader shader uniform!!?
  }

  //viewProjectionMatrix
  Matrix4 get viewProjectionMatrix {
    return (projectionMatrix * viewMatrix) as Matrix4;
  }

  GLTFCameraPerspective(this._yfov, double znear, double _zfar){
   super._znear = znear;
   super._zfar = _zfar;
  }

  update() {
    _aspectRatio = Context.viewAspectRatio;
    setPerspectiveMatrix(_projectionMatrix, _yfov, _aspectRatio, _znear, _zfar);
    setViewMatrix(_viewMatrix, position, _targetPosition, upDirection);
    _updateGizmo();
  }

  @override
  String toString() {
    return 'GLTFCameraPerspective{cameraId: $cameraId, _aspectRatio: $_aspectRatio, _yfov: $_yfov, _targetPosition: $_targetPosition, upDirection: $upDirection, _perspectiveMatrix: $_projectionMatrix, _lookAtMatrix: $_viewMatrix}';
  }

  // >> JSON

  GLTFCameraPerspective.fromJson(Map json) {
    _yfov = json['fov'] as double;
    _znear = json['zNear'] as double;
    _zfar = json['zFar'] as double;
    targetPosition = new Vector3.fromFloat32List(new Float32List.fromList(json['targetPosition'] as List<double>));
    position = new Vector3.fromFloat32List(new Float32List.fromList(json['position'] as List<double>));
    showGizmo = json['showGizmo'] as bool;
  }

  Map toJson(){
    Map json = new Map<String, dynamic>();
    json['fov'] = UtilsMath.roundPrecision(_yfov);//.toDouble();
    json['zNear'] = UtilsMath.roundPrecision(_znear);//.toDouble();
    json['zFar'] = UtilsMath.roundPrecision(_zfar);//.toDouble();
    json['targetPosition'] = targetPosition.storage.map((v)=> UtilsMath.roundPrecision(v)).toList();
    json['position'] = position.storage.map((v)=>UtilsMath.roundPrecision(v)).toList();
    json['showGizmo'] = showGizmo;
    return json;
  }

  // >> glTF
  glTF.Camera _gltfSource;
  glTF.Camera get gltfSource => _gltfSource;

  factory GLTFCameraPerspective.fromGltf(glTF.Camera gltfCamera){
    GLTFCameraPerspective camera = new GLTFCameraPerspective(gltfCamera.perspective.yfov, gltfCamera.perspective.znear, gltfCamera.perspective.zfar)
    .._gltfSource = gltfCamera;
    camera
      .._type = CameraType.perspective
      .._aspectRatio = gltfCamera.perspective.aspectRatio;
    return camera;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          super == other &&
              other is GLTFCameraPerspective &&
              runtimeType == other.runtimeType &&
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

class GLTFCameraOrthographic extends Camera{

  double _ymag;
  double get ymag => _ymag;
  set ymag(double value) {
    _ymag = value;
    update();
  }

  double _xmag;
  double get xmag => _xmag;
  set xmag(double value) {
    _xmag = value;
    update();
  }

  GLTFCameraOrthographic();

  // >> JSON

  GLTFCameraOrthographic.fromJson(Map json) {
    position = new Vector3.fromFloat32List(new Float32List.fromList(json['position'] as List<double>));
    showGizmo = json['showGizmo'] as bool;
  }

  Map toJson(){
    Map json = new Map<String, dynamic>();
    json['position'] = position.storage.map((v)=>UtilsMath.roundPrecision(v)).toList();
    json['showGizmo'] = showGizmo;
    return json;
  }

  // >> glTF

  glTF.Camera _gltfSource;
  glTF.Camera get gltfSource => _gltfSource;

  factory GLTFCameraOrthographic.fromGltf(glTF.Camera gltfCamera){
    GLTFCameraOrthographic camera = new GLTFCameraOrthographic()
      .._gltfSource = gltfCamera
      .._type = CameraType.orthographic
      .._znear = gltfCamera.orthographic.znear
      .._zfar = gltfCamera.orthographic.zfar
      .._xmag = gltfCamera.orthographic.xmag
      .._ymag = gltfCamera.orthographic.ymag;

      // Todo (jpu) :
//      cameraPerspective.extensions;
//      cameraPerspective.extras;

    return camera;
  }

  @override
  String toString() {
    return 'GLTFCameraOrthographic{cameraId: $cameraId, _ymag: $_ymag, _xmag: $_xmag}';
  }


}