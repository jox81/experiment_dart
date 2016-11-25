import 'package:webgl/src/interface/IGizmo.dart';
import 'package:webgl/src/mesh.dart';

abstract class Object3d{
  String name; //Todo : S'assurer que les noms sont uniques ?!
  Mesh mesh;
  IGizmo gizmo;

  void render();
}