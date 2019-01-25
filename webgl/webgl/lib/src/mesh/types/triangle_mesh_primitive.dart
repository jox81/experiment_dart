import 'package:webgl/src/mesh/mesh_primitive.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

class TriangleMeshPrimitive extends MeshPrimitive {
  TriangleMeshPrimitive() {
    mode = DrawMode.TRIANGLES;

    vertices = [
      0.0, 0.0, 0.0,
      2.0, 0.0, 0.0,
      0.0, 2.0, 0.0
    ];
    indices = [0,1,2];
    normals = [
      0.0, 0.0, 1.0,
      0.0, 0.0, 1.0,
      0.0, 0.0, 1.0,
    ];
    uvs = [
      0.0, 0.0,
      1.0, 0.0,
      0.0, 1.0,
    ];
    colors = [
      1.0, 0.0, 0.0, 1.0,
      1.0, 0.0, 0.0, 1.0,
      1.0, 0.0, 0.0, 1.0,
    ];
  }
}