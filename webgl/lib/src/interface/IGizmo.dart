import 'package:webgl/src/primitives.dart';

abstract class IGizmo{
  List<Object3d> gizmoMeshes;
  void updateGizmo();
}