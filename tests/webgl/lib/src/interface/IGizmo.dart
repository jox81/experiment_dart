import 'package:webgl/src/models.dart';

abstract class IGizmo{
  List<Model> gizmoModels;
  void updateGizmo();
}