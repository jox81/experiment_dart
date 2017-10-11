import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'dart:math' as Math;
import 'package:webgl/src/geometry/object3d.dart';
import 'package:webgl/src/controllers/camera_controllers.dart';
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

  static Camera fromGltf(glTF.Camera gltfCamera){
    if(gltfCamera.perspective != null) return new CameraPerspective.fromGltf(gltfCamera.perspective);
    if(gltfCamera.orthographic != null) return new CameraOrthographic.fromGltf(gltfCamera.orthographic);
    return null;
  }

  bool get isActive => _isActive;

  CameraType _type;
  CameraType get type => _type;

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
    _cameraController.init(this as CameraPerspective);// Todo (jpu) : ??
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
      _gizmo = new FrustrumGizmo(this as CameraPerspective);// Todo (jpu) : ??
    }
    _gizmo.visible = value;
  }


  void _updateGizmo() {
    if(_gizmo != null && _gizmo.visible)gizmo.updateGizmo();
  }
}

class CameraPerspective extends Camera{
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
  Matrix4 _perspectiveMatrix = new Matrix4.identity();
  Matrix4 get perspectiveMatrix {
    return (_perspectiveMatrix * new Matrix4.identity()) as Matrix4;// Why is it needed to update shader uniform!!?
  }
  set perspectiveMatrix(Matrix4 value){
    _perspectiveMatrix = value;
    _updateGizmo();
  }

  //viewMatrix
  Matrix4 _lookAtMatrix = new Matrix4.identity();
  Matrix4 get lookAtMatrix {
    return (_lookAtMatrix * new Matrix4.identity()) as Matrix4; // Why is it needed to update shader shader uniform!!?
  }

  //viewProjectionMatrix
  Matrix4 get viewProjectionMatrix {
    return (perspectiveMatrix * lookAtMatrix) as Matrix4;
  }

  CameraPerspective(this._yfov, double znear, double _zfar){
   super._znear = znear;
   super._zfar = _zfar;
  }

  update() {
    _aspectRatio = Context.viewAspectRatio;
    setPerspectiveMatrix(_perspectiveMatrix, _yfov, _aspectRatio, _znear, _zfar);
    setViewMatrix(_lookAtMatrix, position, _targetPosition, upDirection);
    _updateGizmo();
  }

  String toString() {
    return 'camera position : $position -> target : $targetPosition';
  }

  // >> JSON

  CameraPerspective.fromJson(Map json) {
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

  factory CameraPerspective.fromGltf(glTF.CameraPerspective gltfCamera){
    CameraPerspective camera = new CameraPerspective(gltfCamera.yfov, gltfCamera.znear, gltfCamera.zfar);
    camera
      .._type = CameraType.perspective
      .._aspectRatio = gltfCamera.aspectRatio;
    // Todo (jpu) :
//      cameraPerspective.extensions;
//      cameraPerspective.extras;

    return camera;
  }
}

class CameraOrthographic extends Camera{

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

  CameraOrthographic();

  // >> JSON

  CameraOrthographic.fromJson(Map json) {
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

  factory CameraOrthographic.fromGltf(glTF.CameraOrthographic gltfCamera){
    CameraOrthographic camera = new CameraOrthographic()
      .._type = CameraType.orthographic
      .._znear = gltfCamera.znear
      .._zfar = gltfCamera.zfar
      .._xmag = gltfCamera.xmag
      .._ymag = gltfCamera.ymag;

      // Todo (jpu) :
//      cameraPerspective.extensions;
//      cameraPerspective.extras;

    return camera;
  }

}