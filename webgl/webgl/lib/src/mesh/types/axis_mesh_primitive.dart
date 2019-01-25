import 'package:webgl/src/mesh/mesh_primitive.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

class AxisMeshPrimitive extends MeshPrimitive {
  AxisMeshPrimitive() {
    mode = DrawMode.LINES;
    vertices = [
      0.0,0.0,0.0,
      1.0,0.0,0.0,
      0.0,0.0,0.0,
      0.0,1.0,0.0,
      0.0,0.0,0.0,
      0.0,0.0,1.0,
    ];
    colors = [
      1.0,0.0,0.0,1.0,
      1.0,0.0,0.0,1.0,
      0.0,1.0,0.0,1.0,
      0.0,1.0,0.0,1.0,
      0.0,0.0,1.0,1.0,
      0.0,0.0,1.0,1.0,
    ];
  }
}