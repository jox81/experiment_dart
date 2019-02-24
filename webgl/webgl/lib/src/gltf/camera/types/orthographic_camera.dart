import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/camera/camera.dart';
import 'package:webgl/src/gltf/engine/gltf_engine.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/introspection/introspection.dart';
import 'package:webgl/src/utils/utils_math.dart';

@reflector
class GLTFCameraOrthographic extends GLTFCamera{

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

  Vector3 get frontDirection => null;

  GLTFCameraOrthographic(){
    GLTFEngine.currentProject.cameras.add(this);
    GLTFEngine.currentProject.removeNode(this);
    GLTFNode.nextId--;
  }

  // >> JSON

  GLTFCameraOrthographic.fromJson(Map json) {
    translation = new Vector3.fromFloat32List(new Float32List.fromList(json['position'] as List<double>));
//    showGizmo = json['showGizmo'] as bool;
  }

  Map toJson(){
    Map json = new Map<String, dynamic>();
    json['position'] = translation.storage.map((v)=>UtilsMath.roundPrecision(v)).toList();
//    json['showGizmo'] = showGizmo;
    return json;
  }

  @override
  String toString() {
    return 'GLTFCameraOrthographic{cameraId: $cameraId, _ymag: $_ymag, _xmag: $_xmag, super: ${super.toString()}}';
  }

  @override
  // TODO: implement projectionMatrix
  Matrix4 get projectionMatrix => null;

  @override
  // TODO: implement viewMatrix
  Matrix4 get viewMatrix => null;
}