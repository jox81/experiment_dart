import 'package:webgl/src/gtlf/mesh.dart';

abstract class IGizmo{
  List<GLTFMesh> gizmoModels;
  void updateGizmo();
}