import 'package:webgl/src/geometry/meshes.dart';
import 'dart:math';
import 'package:webgl/src/geometry/models.dart';
import 'package:webgl/src/material/materials.dart';
import 'package:webgl/src/time/time.dart';
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
  MaterialCustom materialCustom = new MaterialCustom(vs, fs);
  materialCustom.setShaderAttributsVariables = (Model model) {
      materialCustom.setShaderAttributArrayBuffer(
          'aVertexPosition', model.mesh.vertices, model.mesh.vertexDimensions);
      materialCustom.setShaderAttributArrayBuffer(
          'aVertexColor', model.mesh.colors,  model.mesh.colorDimensions);
    };
  materialCustom.setShaderUniformsVariables = (Model model) {
      materialCustom.setShaderUniform("pointSize", pointSize);
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

  customObject.updateFunction = (){
    pointSize = 100 * cos(Time.currentTime / 100);
  };

  return customObject;
}


