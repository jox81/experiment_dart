import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/mesh/mesh_primitive.dart';

class PyramidMeshPrimitive extends MeshPrimitive {
  PyramidMeshPrimitive() {
    vertices = [
      1.0, 0.0, 1.0,
      1.0, 0.0, -1.0,
      0.0, 2.0, 0.0,

      1.0, 0.0, -1.0,
      -1.0, 0.0, -1.0,
      0.0, 2.0, 0.0,

      -1.0, 0.0, -1.0,
      -1.0, 0.0, 1.0,
      0.0, 2.0, 0.0,

      -1.0, 0.0, 1.0,
      1.0, 0.0, 1.0,
      0.0, 2.0, 0.0,

      1.0, 0.0, 1.0,
      1.0, 0.0, -1.0,
      -1.0, 0.0, -1.0,

      1.0, 0.0, 1.0,
      -1.0, 0.0, -1.0,
      -1.0, 0.0, 1.0,
    ];

    indices = [
      0, 1, 2, // right face
      3, 4, 5, // front face
      6, 7, 8, // left face
      9, 10, 11, // back face
      12, 13, 14, // bottom face
      15, 16, 17, // bottom face
    ];

    uvs = [
      0.0, 0.0,
      1.0, 0.0,
      0.5, 1.0,

      0.0, 0.0,
      1.0, 0.0,
      0.5, 1.0,

      0.0, 0.0,
      1.0, 0.0,
      0.5, 1.0,

      0.0, 0.0,
      1.0, 0.0,
      0.5, 1.0,

      1.0, 1.0,
      1.0, 0.0,
      0.0, 0.0,

      1.0, 1.0,
      0.0, 0.0,
      0.0, 1.0,
    ];

    normals = []
      ..addAll(new Plane.components(vertices[0], vertices[1], vertices[2], 1.0).normal.storage)
      ..addAll(new Plane.components(vertices[0], vertices[1], vertices[2], 1.0).normal.storage)
      ..addAll(new Plane.components(vertices[0], vertices[1], vertices[2], 1.0).normal.storage)
      ..addAll(new Plane.components(vertices[3], vertices[4], vertices[5], 1.0).normal.storage)
      ..addAll(new Plane.components(vertices[3], vertices[4], vertices[5], 1.0).normal.storage)
      ..addAll(new Plane.components(vertices[3], vertices[4], vertices[5], 1.0).normal.storage)
      ..addAll(new Plane.components(vertices[6], vertices[7], vertices[8], 1.0).normal.storage)
      ..addAll(new Plane.components(vertices[6], vertices[7], vertices[8], 1.0).normal.storage)
      ..addAll(new Plane.components(vertices[6], vertices[7], vertices[8], 1.0).normal.storage)
      ..addAll(new Plane.components(vertices[9], vertices[10], vertices[11], 1.0).normal.storage)
      ..addAll(new Plane.components(vertices[9], vertices[10], vertices[11], 1.0).normal.storage)
      ..addAll(new Plane.components(vertices[9], vertices[10], vertices[11], 1.0).normal.storage)
      ..addAll(new Vector3(0.0,-1.0,0.0).storage)
      ..addAll(new Vector3(0.0,-1.0,0.0).storage)
      ..addAll(new Vector3(0.0,-1.0,0.0).storage)
      ..addAll(new Vector3(0.0,-1.0,0.0).storage)
      ..addAll(new Vector3(0.0,-1.0,0.0).storage)
      ..addAll(new Vector3(0.0,-1.0,0.0).storage)
      ..addAll(new Vector3(0.0,-1.0,0.0).storage);

    List<List<double>> _colorsFace = [
      [1.0, 0.0, 0.0, 1.0], // Front face
      [1.0, 1.0, 0.0, 1.0], // Back face
      [0.0, 0.0, 1.0, 1.0], // Right face
      [1.0, 0.0, 1.0, 1.0], // Left face
      [0.0, 1.0, 1.0, 1.0], // Bottom face
      [0.0, 1.0, 1.0, 1.0], // Bottom face
    ];

    // Todo (jpu) : wrong color ! recheck that.
    int vertexByFace = 3;
    int colorComponentBayVertex = 4;
    colors = new List.generate(vertexByFace * colorComponentBayVertex * _colorsFace.length, (int index) {
      // index ~/ 18 returns 0-6, that's color index
      // index % colorComponentBayVertex returns 0-3 that's color component for each color
      return _colorsFace[index ~/ 18][index % colorComponentBayVertex];
    }, growable: false);
  }
}