import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/mesh.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/primitives.dart';

Object3d experiment() {

  String vs = '''
    attribute vec3 aVertexPosition;
    attribute vec4 aVertexColor;

    uniform float pointSize;

    varying vec4 vPointColor;

    void main(void) {
      gl_Position = vec4(aVertexPosition, 1.0);
      gl_PointSize = pointSize;
      vPointColor = aVertexColor;
    }
  ''';

  String fs = '''
    precision mediump float;

    varying vec4 vPointColor;

    void main(void) {
        gl_FragColor = vPointColor;
    }
  ''';

  num pointSize = 5.0;

  //Material
  List<String> buffersNames = ['aVertexPosition', 'aVertexColor'];

  MaterialCustom materialCustom = new MaterialCustom(vs, fs, buffersNames);
  materialCustom.setShaderAttributsVariables = (Mesh mesh) {
      materialCustom.setShaderAttributWithName(
          'aVertexPosition', arrayBuffer : mesh.vertices, dimension : mesh.vertexDimensions);
      materialCustom.setShaderAttributWithName(
          'aVertexColor', arrayBuffer : mesh.colors, dimension : mesh.colorDimensions);
    };
  materialCustom.setShaderUniformsVariables = (Mesh mesh) {
      materialCustom.setShaderUniformWithName("pointSize", pointSize);
    };

  Mesh mesh = new Mesh()
  ..mode = GL.POINTS
  ..vertices = [
    0.0,0.0,0.0,
  ]
  ..colors = [
    1.0,1.0,1.0,1.0,
  ];
  CustomObject customObject = new CustomObject()
  ..mesh = mesh
  ..material = materialCustom;

  mesh.updateFunction = (num time){
    pointSize = 100 * cos(time / 100);
  };

  return customObject;
}


