import 'package:webgl/src/geometry/mesh.dart';

abstract class IGizmo{
  List<Mesh> gizmoModels;
  void updateGizmo();
}