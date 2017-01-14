import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';

import 'dart:math';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

class Mesh {

  DrawMode mode = DrawMode.TRIANGLE_STRIP;

  //Vertices infos
  int _vertexDimensions = 3;
  int get vertexDimensions => _vertexDimensions;
  set vertexDimensions(int d) {
    _vertexDimensions = d;
  }
  //List<double> _vertices = new List();
  //List<double> get vertices => _vertices;
  //set vertices(List<double> value) {
  //  _vertices = value;
  //}

  List<double> vertices = [];

  int get vertexCount => vertices.length ~/ _vertexDimensions;

  //Color infos
  int _colorDimensions = 4;
  int get colorDimensions => _colorDimensions;
  List<double> _colors = new List();
  List<double> get colors => _colors;
  set colors(List<double> value) {
    _colors = value;
  }

  int get colorCount => _colors.length ~/ _colorDimensions;

  //Indices Infos
  List<int> _indices = new List();
  List<int> get indices => _indices;
  set indices(List<int> value) {
    _indices = value;
  }

  int get indiceCount => _indices.length;

  //TextureCoords infos
  int _textureCoordsDimensions = 2;
  int get textureCoordsDimensions => _textureCoordsDimensions;
  List<double> _textureCoords = new List();
  List<double> get textureCoords => _textureCoords;
  set textureCoords(List<double> value) {
    _textureCoords = value;
  }

  int get textureCoordsCount =>
      _textureCoords.length ~/ _textureCoordsDimensions;

  //vertexNormals infos
  int _vertexNormalsDimensions = 3;
  int get vertexNormalsDimensions => _vertexNormalsDimensions;
  List<double> _vertexNormals = new List();
  List<double> get vertexNormals => _vertexNormals;
  set vertexNormals(List<double> value) {
    _vertexNormals = value;
  }

  int get vertexNormalsCount =>
      _vertexNormals.length ~/ _vertexNormalsDimensions;

  List<Triangle> _faces;
  List<Triangle> get faces {

    /*
    //Référence de construction
    0 - 3
    | \ |
    1 - 2

    vertices = [
      -1.0, 1.0, 0.0,
      -1.0, -1.0, 0.0,
      1.0, -1.0, 0.0,
      1.0, 1.0, 0.0
    ];
    indices = [
      0, 1, 2, 0, 2, 3,
    ];
    */

    if(_faces == null){
      List<Float32List> fullVertices = [];
      _faces = [];
      int stepVertices = 3;
      for(int vertex = 0; vertex < vertices.length; vertex += stepVertices) {
        fullVertices.add(new Float32List.fromList([vertices[vertex + 0], vertices[vertex + 1], vertices[vertex + 2]]));
      }

      int stepIndices = 3;
      for(int i = 0; i < indices.length; i += stepIndices) {
        Vector3 p1 = new Vector3.fromFloat32List(fullVertices[indices[i]]);
        Vector3 p2 = new Vector3.fromFloat32List(fullVertices[indices[i + 1]]);
        Vector3 p3 = new Vector3.fromFloat32List(fullVertices[indices[i + 2]]);
        _faces.add(new Triangle.points(p1, p2, p3));
      }
    }
    return _faces;
  }

  Mesh();

  factory Mesh.Point() {
    return new _PointMesh();
  }

  factory Mesh.Line(List<Vector3> points) {
    return new _LineMesh(points);
  }

  factory Mesh.Rectangle() {
    return new _SquareMesh();
  }

  factory Mesh.Triangle() {
    return new _TriangleMesh();
  }

  factory Mesh.Pyramid() {
    return new _PyramidMesh();
  }

  factory Mesh.Cube() {
    return new _CubeMesh();
  }

  factory Mesh.Sphere({num radius : 1, int segmentV: 32, int segmentH: 32}) {
    return new _SphereMesh(radius : radius, segmentV:segmentV, segmentH:segmentH);
  }

  factory Mesh.Axis() {
    return new _AxisMesh();
  }

  factory Mesh.AxisPoints() {
    return new _AxisPointMesh();
  }
}

class _PointMesh extends Mesh {
  _PointMesh() {

    mode = DrawMode.POINTS;
    vertices = [
      0.0, 0.0, 0.0,
    ];

  }
}
class _LineMesh extends Mesh {
  _LineMesh(List<Vector3> points) {
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

class _TriangleMesh extends Mesh {
  _TriangleMesh() {
    mode = DrawMode.TRIANGLES;

    vertices = [
      0.0, 0.0, 0.0,
      2.0, 0.0, 0.0,
      0.0, 2.0, 0.0
    ];
    indices = [0,1,2];
  }
}

class _SquareMesh extends Mesh {
  _SquareMesh() {
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

class _PyramidMesh extends Mesh {
  _PyramidMesh() {
    vertices = [
      0.0, 1.0, 0.0, //top vertex
      1.0, -1.0, 1.0,
      1.0, -1.0, -1.0,
      -1.0, -1.0, -1.0,
      -1.0, -1.0, 1.0,
    ];

    indices = [
      0, 1, 2, // right face
      0, 2, 3, // front face
      0, 3, 4, // left face
      0, 4, 1, // back face
      1, 2, 3, // bottom face
      1, 3, 4, // bottom face
    ];

    colors = [
      1.0, 0.0, 0.0, 1.0,//top vertex
      0.0, 0.0, 1.0, 1.0,
      0.0, 1.0, 0.0, 1.0,
      0.0, 0.0, 1.0, 1.0,
      0.0, 1.0, 0.0, 1.0,
    ];
  }
}

class _CubeMesh extends Mesh {
  _CubeMesh() {
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
      [1.0, 0.5, 0.5, 1.0], // Bottom face
      [1.0, 0.0, 1.0, 1.0], // Right face
      [0.0, 0.0, 1.0, 1.0], // Left face
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

class _SphereMesh extends Mesh {

  Matrix4 _matRotY = new Matrix4.identity();
  Matrix4 _matRotZ = new Matrix4.identity();

  Vector3 _tmpVec3 = new Vector3.zero();
  Vector3 _up = new Vector3(0.0, 1.0, 0.0);

  List<Vector3> sphereVerticesVector = [];
  List<Vector2> uvs = [];


  _SphereMesh({num radius : 1, int segmentV: 32, int segmentH : 32}) {

    mode = DrawMode.TRIANGLES;

    segmentV = max(1,segmentV--);

    int totalZRotationSteps = 1 + segmentV;
    int totalYRotationSteps = segmentH;

    for (int zRotationStep = 0;
        zRotationStep <= totalZRotationSteps;
        zRotationStep++) {
      num normalizedZ = zRotationStep / totalZRotationSteps;
      num angleZ = (normalizedZ * PI);//part of vertical half circle

      for (int yRotationStep = 0;
          yRotationStep <= totalYRotationSteps;
          yRotationStep++) {
        num normalizedY = yRotationStep / totalYRotationSteps;
        num angleY = normalizedY * PI * 2;//part of horizontal full circle

        _matRotZ.setIdentity();//reset
        _matRotZ.rotateZ(-angleZ);

        _matRotY.setIdentity();//reset
        _matRotY.rotateY(angleY);

        _tmpVec3 = _matRotY * _matRotZ * _up ;//up vector transformed by the 2 rotations

        _tmpVec3.scale(-radius);// why - ?
        vertices.addAll(_tmpVec3.storage);
        sphereVerticesVector.add(_tmpVec3);

        _tmpVec3.normalize();
        vertexNormals.addAll(_tmpVec3.storage);

        uvs.add(new Vector2(normalizedY, 1 - normalizedZ));
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
//    _textureCoords = uvs;


  }
}

class _AxisMesh extends Mesh {
  _AxisMesh() {
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
class _AxisPointMesh extends Mesh {
  _AxisPointMesh() {
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