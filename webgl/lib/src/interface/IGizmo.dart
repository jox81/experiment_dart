import 'package:webgl/src/models.dart';

abstract class IGizmo{
  List<Model> gizmoMeshes;
  void updateGizmo();
}