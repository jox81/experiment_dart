import 'dart:web_gl';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/material.dart';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'dart:math';

class Mesh {
  RenderingContext get gl => Application.gl;

  //
  int mode = GL.TRIANGLE_STRIP;

  //Transform : position, rotation, scale
  Matrix4 transform = new Matrix4.identity();

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

  List<double> vertices;

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

  Material material;

  Mesh();

  void render() {
    material.render(this);
  }

  static createRectangle() {
    return new _SquareMesh();
  }

  static createTriangle() {
    return new _TriangleMesh();
  }

  static createPyramid() {
    return new _PyramidMesh();
  }

  static createCube() {
    return new _CubeMesh();
  }

  static createSphere({num radius : 1, int segmentV: 32, int segmentH: 32}) {
    return new _SphereMesh(radius : radius, segmentV:segmentV, segmentH:segmentH);
  }
}

class _TriangleMesh extends Mesh {
  _TriangleMesh() {
    vertices = [0.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0, 2.0, 0.0];
  }
}

class _SquareMesh extends Mesh {
  _SquareMesh() {
    vertices = [1.0, 1.0, 0.0, -1.0, 1.0, 0.0, 1.0, -1.0, 0.0, -1.0, -1.0, 0.0];
  }
}

class _PyramidMesh extends Mesh {
  _PyramidMesh() {
    vertices = [
      // Front face
      0.0, 1.0, 0.0,
      -1.0, -1.0, 1.0,
      1.0, -1.0, 1.0,
      // Right face
      0.0, 1.0, 0.0,
      1.0, -1.0, 1.0,
      1.0, -1.0, -1.0,
      // Back face
      0.0, 1.0, 0.0,
      1.0, -1.0, -1.0,
      -1.0, -1.0, -1.0,
      // Left face
      0.0, 1.0, 0.0,
      -1.0, -1.0, -1.0,
      -1.0, -1.0, 1.0
    ];

    _colors = [
      // Front face
      1.0, 0.0, 0.0, 1.0,
      0.0, 1.0, 0.0, 1.0,
      0.0, 0.0, 1.0, 1.0,
      // Right face
      1.0, 0.0, 0.0, 1.0,
      0.0, 0.0, 1.0, 1.0,
      0.0, 1.0, 0.0, 1.0,
      // Back face
      1.0, 0.0, 0.0, 1.0,
      0.0, 1.0, 0.0, 1.0,
      0.0, 0.0, 1.0, 1.0,
      // Left face
      1.0, 0.0, 0.0, 1.0,
      0.0, 0.0, 1.0, 1.0,
      0.0, 1.0, 0.0, 1.0
    ];
  }
}

class _CubeMesh extends Mesh {
  _CubeMesh() {
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

    List<List<double>> _colorsFace = [
      [1.0, 0.0, 0.0, 1.0], // Front face
      [1.0, 1.0, 0.0, 1.0], // Back face
      [0.0, 1.0, 0.0, 1.0], // Top face
      [1.0, 0.5, 0.5, 1.0], // Bottom face
      [1.0, 0.0, 1.0, 1.0], // Right face
      [0.0, 0.0, 1.0, 1.0], // Left face
    ];

    _colors = new List.generate(4 * 4 * _colorsFace.length, (int index) {
      // index ~/ 16 returns 0-5, that's color index
      // index % 4 returns 0-3 that's color component for each color
      return _colorsFace[index ~/ 16][index % 4];
    }, growable: false);

    _indices = [
      0, 1, 2, 0, 2, 3, // Front face
      4, 5, 6, 4, 6, 7, // Back face
      8, 9, 10, 8, 10, 11, // Top face
      12, 13, 14, 12, 14, 15, // Bottom face
      16, 17, 18, 16, 18, 19, // Right face
      20, 21, 22, 20, 22, 23 // Left face
    ];

    _textureCoords = [
      // Front face
      0.0, 0.0,
      1.0, 0.0,
      1.0, 1.0,
      0.0, 1.0,

      // Back face
      1.0, 0.0,
      1.0, 1.0,
      0.0, 1.0,
      0.0, 0.0,

      // Top face
      0.0, 1.0,
      0.0, 0.0,
      1.0, 0.0,
      1.0, 1.0,

      // Bottom face
      1.0, 1.0,
      0.0, 1.0,
      0.0, 0.0,
      1.0, 0.0,

      // Right face
      1.0, 0.0,
      1.0, 1.0,
      0.0, 1.0,
      0.0, 0.0,

      // Left face
      0.0, 0.0,
      1.0, 0.0,
      1.0, 1.0,
      0.0, 1.0,
    ];

    _vertexNormals = [
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

    mode = GL.TRIANGLES;
  }
}

class _SphereMesh extends Mesh {

  Matrix4 _matRotY = new Matrix4.identity();
  Matrix4 _matRotZ = new Matrix4.identity();

  Vector3 _tmpVec3 = new Vector3.zero();
  Vector3 _up = new Vector3(0.0, 1.0, 0.0);

  List<int> faces = [];
  List<double> sphereVertices = [];
  List<Vector3> sphereVerticesVector = [];
  List<Vector3> normals = [];
  List<Vector2> uvs = [];

  _SphereMesh({num radius : 1, int segmentV: 32, int segmentH : 32}) {

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
        sphereVertices.addAll(_tmpVec3.storage);
        sphereVerticesVector.add(_tmpVec3);

        _tmpVec3.normalize();
        normals.add(_tmpVec3);

        uvs.add(new Vector2(normalizedY, 1 - normalizedZ));
      }

      if (zRotationStep > 0) {
        var verticesCount = sphereVertices.length;
        var firstIndex = verticesCount - 2 * (totalYRotationSteps + 1);
        for (;
            (firstIndex + totalYRotationSteps + 2) < verticesCount;
            firstIndex++) {
          faces.addAll([
            firstIndex,
            firstIndex + 1,
            firstIndex + totalYRotationSteps + 1
          ]);
          faces.addAll([
            firstIndex + totalYRotationSteps + 1,
            firstIndex + 1,
            firstIndex + totalYRotationSteps + 2
          ]);
        }
      }
    }

    vertices = sphereVertices;
//    _indices = indices;
//    _vertexNormals = normals;
//    _textureCoords = uvs;

    mode = GL.TRIANGLES;
  }
}
