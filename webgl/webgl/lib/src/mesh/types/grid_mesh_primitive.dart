import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/mesh/mesh_primitive.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

class GridMeshPrimitive extends MeshPrimitive {

  GridMeshPrimitive() {
    mode = DrawMode.LINES;

    int gridHalfWidthCount = 5;
    constructGrid(gridHalfWidthCount);
  }

  void constructGrid(int gridHalfWidthCount) {
    vertices = [];
    for (int i = -gridHalfWidthCount; i <= gridHalfWidthCount; i++) {
      Vector3 p1 =
      new Vector3(i.toDouble(), 0.0, gridHalfWidthCount.toDouble());
      Vector3 p2 =
      new Vector3(i.toDouble(), 0.0, -gridHalfWidthCount.toDouble());
      vertices.addAll(p1.storage);
      vertices.addAll(p2.storage);
    }
    for (int i = -gridHalfWidthCount; i <= gridHalfWidthCount; i++) {
      Vector3 p1 =
      new Vector3(-gridHalfWidthCount.toDouble(), 0.0, i.toDouble());
      Vector3 p2 =
      new Vector3(gridHalfWidthCount.toDouble(), 0.0, i.toDouble());
      vertices.addAll(p1.storage);
      vertices.addAll(p2.storage);
    }

    List<double> _color = [
      0.5, 0.5, 0.5, 1.0
    ];
    colors = new List.generate(4 * vertices.length ~/ 3, (int index) {
      // index ~/ 16 returns 0-5, that's color index
      // index % 4 returns 0-3 that's color component for each color
      return _color[index % 4];
    }, growable: false);
  }
}