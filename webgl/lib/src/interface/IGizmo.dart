import 'package:webgl/src/geometry/models.dart';

abstract class IGizmo{
  List<Model> gizmoModels;
  void updateGizmo();
}