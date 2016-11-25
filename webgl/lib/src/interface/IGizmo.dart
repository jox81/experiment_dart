import 'package:webgl/src/mesh.dart';

abstract class IGizmo{
  List<Mesh> gizmoMeshes;
  void updateGizmo();
}