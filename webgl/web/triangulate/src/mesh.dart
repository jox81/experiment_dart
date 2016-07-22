import 'package:vector_math/vector_math.dart';
import 'dart:web_gl';

class Mesh{
  List _vertices;

  Vector4 color;

  List _texCoords;

  List _normals;

  String vsShader;

  String fsShader;

  var textureImage;

  Texture _texture;
  Texture get texture => _texture;
  set texture(Texture value) => _texture = value;

  List get normals => _normals;
  set normals(List value) => _normals = value;

  List get texCoords => _texCoords;
  set texCoords(List value) => _texCoords = value;

  List get vertices => _vertices;
  set vertices(List value) => _vertices = value;

  List _indices;
  List get indices => _indices;
  set indices(List value) => _indices = value;

  Mesh() {

  }

  void triangulateMesh() {
    //Todo
  }
}