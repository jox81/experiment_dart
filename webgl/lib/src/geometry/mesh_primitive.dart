import 'package:vector_math/vector_math.dart';
import 'dart:math';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

@MirrorsUsed(
    targets: const [
      MeshPrimitive,
      _PointMeshPrimitive,
      _LineMeshPrimitive2,
      _LineMeshPrimitive,
      _TriangleMeshPrimitive,
      _QuadMeshPrimitive,
      _PyramidMeshPrimitive,
      _CubeMeshPrimitive,
      _SphereMeshPrimitive,
      _AxisMeshPrimitive,
      _AxisPointMeshPrimitive,
    ],
    override: '*')
import 'dart:mirrors';

class MeshPrimitive {

  /// DrawMode mode
  int mode = DrawMode.TRIANGLES;

  List<double> vertices = [];

  //Indices Infos
  List<int> _indices = new List();
  List<int> get indices => _indices;
  set indices(List<int> value) {
    _indices = value;
  }

  List<double> _textureCoords = new List();
  List<double> get textureCoords => _textureCoords;
  set textureCoords(List<double> value) {
    _textureCoords = value;
  }

  List<double> _vertexNormals = new List();
  List<double> get vertexNormals => _vertexNormals;
  set vertexNormals(List<double> value) {
    _vertexNormals = value;
  }

  List<double> _colors = new List();
  List<double> get colors => _colors;
  set colors(List<double> value) {
    _colors = value;
  }

  MeshPrimitive();

  factory MeshPrimitive.Point() {
    return new _PointMeshPrimitive();
  }

  factory MeshPrimitive.Line(List<Vector3> points) {
    return new _LineMeshPrimitive(points);
  }

  factory MeshPrimitive.Line2(List<Vector3> points) {
    return new _LineMeshPrimitive2(points);
  }

  factory MeshPrimitive.Triangle() {
    return new _TriangleMeshPrimitive();
  }

  factory MeshPrimitive.Quad() {
    return new _QuadMeshPrimitive();
  }

  factory MeshPrimitive.Pyramid() {
    return new _PyramidMeshPrimitive();
  }

  factory MeshPrimitive.Cube() {
    return new _CubeMeshPrimitive();
  }

  factory MeshPrimitive.Sphere({double radius : 1.0, int segmentV: 32, int segmentH: 32}) {
    return new _SphereMeshPrimitive(radius : radius, segmentV:segmentV, segmentH:segmentH);
  }

  factory MeshPrimitive.Axis() {
    return new _AxisMeshPrimitive();
  }

  factory MeshPrimitive.AxisPoints() {
    return new _AxisPointMeshPrimitive();
  }
}

class _PointMeshPrimitive extends MeshPrimitive {
  _PointMeshPrimitive() {

    mode = DrawMode.POINTS;
    vertices = [
      0.0, 0.0, 0.0,
    ];

  }
}

//Deprecated
class _LineMeshPrimitive2 extends MeshPrimitive {
  _LineMeshPrimitive2(List<Vector3> points) {
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

class _LineMeshPrimitive extends MeshPrimitive {
  _LineMeshPrimitive(List<Vector3> points) {
    assert(points.length >= 2);

    mode = DrawMode.LINE_STRIP;

    vertices = [];

    for(int i = 0; i < points.length; i++){
      vertices.addAll(points[i].storage);
//      colors.addAll([1.0, 0.0, 0.0, 1.0]);
    }
  }
}

class _TriangleMeshPrimitive extends MeshPrimitive {
  _TriangleMeshPrimitive() {
    mode = DrawMode.TRIANGLES;

    vertices = [
      0.0, 0.0, 0.0,
      2.0, 0.0, 0.0,
      0.0, 2.0, 0.0
    ];
    indices = [0,1,2];
    textureCoords = [
      0.0, 0.0,
      1.0, 0.0,
      0.0, 1.0,
    ];
  }
}

class _QuadMeshPrimitive extends MeshPrimitive {
  _QuadMeshPrimitive() {
    mode = DrawMode.TRIANGLES;
    /*
    0 - 3
    | \ |
    1 - 2
    */
    vertices = [
      -1.0, 1.0, 0.0,
      -1.0, -1.0, 0.0,
      1.0, -1.0, 0.0,
      1.0, 1.0, 0.0
    ];
    indices = [
      0, 1, 2, 0, 2, 3,
    ];
    vertexNormals = [
      0.0, 0.0, 1.0,
      0.0, 0.0, 1.0,
      0.0, 0.0, 1.0,
      0.0, 0.0, 1.0,
    ];
    textureCoords = [
      0.0, 0.0,
      1.0, 0.0,
      1.0, 1.0,
      0.0, 1.0,
    ];
  }
}

class _PyramidMeshPrimitive extends MeshPrimitive {
  _PyramidMeshPrimitive() {
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
      1.0, 0.0, -1.0,
    ];

    indices = [
      0, 1, 2, // right face
      3, 4, 5, // front face
      6, 7, 8, // left face
      9, 10, 11, // back face
      12, 13, 14, // bottom face
      15, 16, 17, // bottom face
    ];

    textureCoords = [
      0.0, 0.0,
      1.0, 0.0,
      0.0, 1.0,

      0.0, 0.0,
      1.0, 0.0,
      0.0, 1.0,

      0.0, 0.0,
      1.0, 0.0,
      0.0, 1.0,

      0.0, 0.0,
      1.0, 0.0,
      0.0, 1.0,

      0.0, 0.0,
      1.0, 0.0,
      0.0, 1.0,

      0.0, 0.0,
      1.0, 0.0,
      0.0, 1.0,
    ];

    vertexNormals = []
    ..addAll(new Plane.components(vertices[0], vertices[1], vertices[2], 1.0).normal.storage)
    ..addAll(new Plane.components(vertices[3], vertices[4], vertices[5], 1.0).normal.storage)
    ..addAll(new Plane.components(vertices[6], vertices[7], vertices[8], 1.0).normal.storage)
    ..addAll(new Plane.components(vertices[9], vertices[10], vertices[11], 1.0).normal.storage)
    ..addAll(new Vector3(0.0,-1.0,0.0).storage)
    ..addAll(new Vector3(0.0,-1.0,0.0).storage);
  }
}

class _CubeMeshPrimitive extends MeshPrimitive {
  _CubeMeshPrimitive() {
    mode = DrawMode.TRIANGLES;

    vertices = [
      // Front face
      -1.0, -1.0, 1.0,
      1.0, -1.0, 1.0,
      1.0, 1.0, 1.0,
      -1.0, 1.0, 1.0,

      // Back face
      -1.0, -1.0, -1.0,
      -1.0, 1.0, -1.0,
      1.0, 1.0, -1.0,
      1.0, -1.0, -1.0,

      // Top face
      -1.0, 1.0, -1.0,
      -1.0, 1.0, 1.0,
      1.0, 1.0, 1.0,
      1.0, 1.0, -1.0,

      // Bottom face
      -1.0, -1.0, -1.0,
      1.0, -1.0, -1.0,
      1.0, -1.0, 1.0,
      -1.0, -1.0, 1.0,

      // Right face
      1.0, -1.0, -1.0,
      1.0, 1.0, -1.0,
      1.0, 1.0, 1.0,
      1.0, -1.0, 1.0,

      // Left face
      -1.0, -1.0, -1.0,
      -1.0, -1.0, 1.0,
      -1.0, 1.0, 1.0,
      -1.0, 1.0, -1.0,
    ];

    indices = [
      0, 1, 2, 0, 2, 3, // Front face
      4, 5, 6, 4, 6, 7, // Back face
      8, 9, 10, 8, 10, 11, // Top face
      12, 13, 14, 12, 14, 15, // Bottom face
      16, 17, 18, 16, 18, 19, // Right face
      20, 21, 22, 20, 22, 23 // Left face
    ];

    textureCoords = [
      // Front
      0.0, 1.0,
      0.0, 0.0,
      1.0, 0.0,
      1.0, 1.0,

      // Back
      0.0, 1.0,
      0.0, 0.0,
      1.0, 0.0,
      1.0, 1.0,

      // Top
      0.0, 1.0,
      0.0, 0.0,
      1.0, 0.0,
      1.0, 1.0,

      // Bottom
      0.0, 1.0,
      0.0, 0.0,
      1.0, 0.0,
      1.0, 1.0,

      // Right
      0.0, 1.0,
      0.0, 0.0,
      1.0, 0.0,
      1.0, 1.0,

      // Left
      0.0, 1.0,
      0.0, 0.0,
      1.0, 0.0,
      1.0, 1.0,
    ];

    List<List<double>> _colorsFace = [
      [1.0, 0.0, 0.0, 1.0], // Front face
      [1.0, 1.0, 0.0, 1.0], // Back face
      [0.0, 1.0, 0.0, 1.0], // Top face
      [0.0, 1.0, 1.0, 1.0], // Bottom face
      [0.0, 0.0, 1.0, 1.0], // Right face
      [1.0, 0.0, 1.0, 1.0], // Left face
    ];

    colors = new List.generate(4 * 4 * _colorsFace.length, (int index) {
      // index ~/ 16 returns 0-5, that's color index
      // index % 4 returns 0-3 that's color component for each color
      return _colorsFace[index ~/ 16][index % 4];
    }, growable: false);

    vertexNormals = [
      // Front face
      0.0, 0.0, 1.0,
      0.0, 0.0, 1.0,
      0.0, 0.0, 1.0,
      0.0, 0.0, 1.0,

      // Back face
      0.0, 0.0, -1.0,
      0.0, 0.0, -1.0,
      0.0, 0.0, -1.0,
      0.0, 0.0, -1.0,

      // Top face
      0.0, 1.0, 0.0,
      0.0, 1.0, 0.0,
      0.0, 1.0, 0.0,
      0.0, 1.0, 0.0,

      // Bottom face
      0.0, -1.0, 0.0,
      0.0, -1.0, 0.0,
      0.0, -1.0, 0.0,
      0.0, -1.0, 0.0,

      // Right face
      1.0, 0.0, 0.0,
      1.0, 0.0, 0.0,
      1.0, 0.0, 0.0,
      1.0, 0.0, 0.0,

      // Left face
      -1.0, 0.0, 0.0,
      -1.0, 0.0, 0.0,
      -1.0, 0.0, 0.0,
      -1.0, 0.0, 0.0,
    ];


  }
}

class _SphereMeshPrimitive extends MeshPrimitive {

  Matrix4 _matRotY = new Matrix4.identity();
  Matrix4 _matRotZ = new Matrix4.identity();

  Vector3 _tmpVec3 = new Vector3.zero();
  Vector3 _up = new Vector3(0.0, 1.0, 0.0);

  List<Vector3> sphereVerticesVector = [];
  List<double> uvs = [];

  _SphereMeshPrimitive({double radius : 1.0, int segmentV: 32, int segmentH : 32}) {

    mode = DrawMode.TRIANGLES;

    segmentV = max(1,segmentV--);

    int totalZRotationSteps = 1 + segmentV;
    int totalYRotationSteps = segmentH;

    for (int zRotationStep = 0;
        zRotationStep <= totalZRotationSteps;
        zRotationStep++) {
      double normalizedZ = zRotationStep / totalZRotationSteps;
      double angleZ = (normalizedZ * PI);//part of vertical half circle

      for (int yRotationStep = 0;
          yRotationStep <= totalYRotationSteps;
          yRotationStep++) {
        double normalizedY = yRotationStep / totalYRotationSteps;
        double angleY = normalizedY * PI * 2;//part of horizontal full circle

        _matRotZ.setIdentity();//reset
        _matRotZ.rotateZ(-angleZ);

        _matRotY.setIdentity();//reset
        _matRotY.rotateY(angleY);

        _tmpVec3 = (_matRotY * _matRotZ * _up) as Vector3;//up vector transformed by the 2 rotations

        _tmpVec3.scale(-radius);// why - ?
        vertices.addAll(_tmpVec3.storage);
        sphereVerticesVector.add(_tmpVec3);

        _tmpVec3.normalize();
        vertexNormals.addAll(_tmpVec3.storage);

        uvs.addAll([normalizedY, 1 - normalizedZ]);
      }

      if (zRotationStep > 0) {
        var verticesCount = sphereVerticesVector.length;
        var firstIndex = verticesCount - 2 * (totalYRotationSteps + 1);
        for (;
            (firstIndex + totalYRotationSteps + 2) < verticesCount;
            firstIndex++) {
          indices.addAll([
            firstIndex,
            firstIndex + 1,
            firstIndex + totalYRotationSteps + 1
          ]);
          indices.addAll([
            firstIndex + totalYRotationSteps + 1,
            firstIndex + 1,
            firstIndex + totalYRotationSteps + 2
          ]);
        }
      }
    }
    _textureCoords = uvs;
  }
}

class _AxisMeshPrimitive extends MeshPrimitive {
  _AxisMeshPrimitive() {
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

//Points
class _AxisPointMeshPrimitive extends MeshPrimitive {
  _AxisPointMeshPrimitive() {
    mode = DrawMode.POINTS;

    vertices = [
      0.0, 0.0, 0.0,
      1.0, 0.0, 0.0,
      0.0, 1.0, 0.0,
      0.0, 0.0, 1.0,
    ];
    colors = [
      1.0, 1.0, 0.0, 1.0,
      1.0, 0.0, 0.0, 1.0,
      0.0, 1.0, 0.0, 1.0,
      0.0, 0.0, 1.0, 1.0,
    ];
  }
}