import 'package:test_webgl/src/gltf/mesh.dart';

abstract class IGizmo{
  List<GLTFMesh> gizmoModels;
  void updateGizmo();
}