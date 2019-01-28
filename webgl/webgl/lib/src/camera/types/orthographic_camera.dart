import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera/camera.dart';
import 'package:webgl/src/gltf/engine/gltf_engine.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/introspection/introspection.dart';
import 'package:webgl/src/utils/utils_math.dart';

@reflector
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

  Vector3 get frontDirection => null;

  CameraOrthographic(){
    GLTFEngine.activeProject.cameras.add(this);
    GLTFEngine.activeProject.removeNode(this);
    GLTFNode.nextId--;
  }

  // >> JSON

  CameraOrthographic.fromJson(Map json) {
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
    return 'CameraOrthographic{cameraId: $cameraId, _ymag: $_ymag, _xmag: $_xmag, super: ${super.toString()}}';
  }
}