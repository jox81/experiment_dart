import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/mesh/mesh_primitive.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

class LineMeshPrimitive2 extends MeshPrimitive {
  LineMeshPrimitive2(List<Vector3> points) {
    assert(points.length >= 2);

    mode = DrawMode.LINES;

    vertices = [];

    for(int i = 0; i < points.length - 1; i++){
      Vector3 point1 = points[i];
      vertices.addAll(point1.storage);

      Vector3 point2 = points[i+1];
      vertices.addAll(point2.storage);

      colors.addAll([1.0, 0.0, 0.0, 1.0]);
    }
  }
}