import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera/camera.dart';
import 'package:webgl/src/camera/camera_type.dart';
import 'package:webgl/src/camera/controller/camera_controller.dart';
import 'package:webgl/src/gltf/camera/types/perspective_camera.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/introspection/introspection.dart';

// Todo (jpu) : add Gizmo
//@reflector
abstract class GLTFCamera extends GLTFNode with Camera{
  static int nextId = 0;
  final int cameraId = nextId++;

  CameraType _type;
  CameraType get type => _type;
  set type(CameraType value) {
    _type = value;
  }

  final Vector3 upDirection = new Vector3(0.0, 1.0, 0.0);
  Vector3 get frontDirection;

  Vector3 get zAxis => frontDirection.normalized();
  Vector3 get xAxis => zAxis.cross(upDirection);
  Vector3 get yAxis => zAxis.cross(xAxis);

  @override
  set translation(Vector3 value) {
   super.translation = value;
    update();
  }
  @override
  set matrix(Matrix4 value) {
   super.matrix = value;
    update();
  }

  double _znear = 0.1;
  double get znear => _znear;
  set znear(double value) {
    _znear = value;
    update();
  }

  double _zfar = 1.0;
  double get zfar => _zfar;
  set zfar(double value) {
    _zfar = value;
    update();
  }

  CameraController _cameraController;
  @override
  CameraController get cameraController => _cameraController;
  @override
  set cameraController(covariant CameraController value) {
    _cameraController = value;
    _cameraController.camera = this as GLTFCameraPerspective;
    _cameraController.init();
  }


//  @override
//  void render() {
//    if (_gizmo.visible && !_isActive) {
//      _gizmo.render();
//    }
//  }
//
//  //FrustrumGizmo
//  FrustrumGizmo _gizmo;
//  IGizmo get gizmo => _gizmo;
//
//  bool get showGizmo => _gizmo.visible;
//  set showGizmo(bool value) {
//    if(_gizmo == null){
//      _gizmo = new FrustrumGizmo(this as CameraPerspective);// Todo (jpu) : ??
//    }
//    _gizmo.visible = value;
//  }
//
//  void _updateGizmo() {
//    if(_gizmo != null && _gizmo.visible)gizmo.updateGizmo();
//  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GLTFCamera &&
              cameraId == other.cameraId &&
              isActive == other.isActive &&
              _type == other._type &&
              _znear == other._znear &&
              _zfar == other._zfar &&
              _cameraController == other._cameraController /*&&
              _gizmo == other._gizmo*/;

  @override
  int get hashCode =>
      isActive.hashCode ^
      _type.hashCode ^
      _znear.hashCode ^
      _zfar.hashCode ^
      _cameraController.hashCode/* ^
      _gizmo.hashCode*/;
}