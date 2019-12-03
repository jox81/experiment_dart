import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/mesh/mesh_primitive.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

class LineMeshPrimitive extends MeshPrimitive {
  LineMeshPrimitive(List<Vector3> points) {
    assert(points.length >= 2);

    mode = DrawMode.LINE_STRIP;

    setPoints(points);
  }

  void setPoints(List<Vector3> points) {
    vertices = [];

    for(int i = 0; i < points.length; i++){
      vertices.addAll(points[i].storage);
      colors.addAll([1.0, 0.0, 0.0, 1.0]);
    }
  }
}