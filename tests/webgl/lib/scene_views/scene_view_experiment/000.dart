import 'package:webgl/src/materials.dart';
import 'package:webgl/src/meshes.dart';
import 'dart:math';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

Model experiment() {

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
  materialCustom.setShaderAttributsVariables = (Model model) {
      materialCustom.setShaderAttributWithName(
          'aVertexPosition', arrayBuffer : model.mesh.vertices, dimension : model.mesh.vertexDimensions);
      materialCustom.setShaderAttributWithName(
          'aVertexColor', arrayBuffer : model.mesh.colors, dimension : model.mesh.colorDimensions);
    };
  materialCustom.setShaderUniformsVariables = (Model model) {
      materialCustom.setShaderUniformWithName("pointSize", pointSize);
    };

  Mesh mesh = new Mesh()
  ..mode = DrawMode.POINTS
  ..vertices = [
    0.0,0.0,0.0,
  ]
  ..colors = [
    1.0,1.0,1.0,1.0,
  ];
  CustomObject customObject = new CustomObject()
  ..mesh = mesh
  ..material = materialCustom;

  customObject.updateFunction = (num time){
    pointSize = 100 * cos(time / 100);
  };

  return customObject;
}


