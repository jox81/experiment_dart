import 'package:webgl/src/mesh/mesh_primitive.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

class PointMeshPrimitive extends MeshPrimitive {
  PointMeshPrimitive() {

    mode = DrawMode.POINTS;
    vertices = [
      0.0, 0.0, 0.0,
    ];

  }
}