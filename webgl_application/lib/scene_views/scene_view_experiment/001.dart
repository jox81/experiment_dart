import 'package:webgl/src/geometry/meshes.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/geometry/models.dart';
import 'package:webgl/src/material/materials.dart';
import 'package:webgl/src/time/time.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

Model experiment() {

  String vs = '''
    attribute vec3 aVertexPosition;
    vec4 aVertexColor = vec4(1.0, 1.0, 1.0, 1.0);

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
          'aVertexPosition', model.mesh.vertices,  model.mesh.vertexDimensions);
    };
  materialCustom.setShaderUniformsVariables = (Model model) {
      materialCustom.setShaderUniform("pointSize", pointSize);
    };

  Mesh mesh = new Mesh()
  ..mode = DrawMode.POINTS
  ..vertices = [
  ];
  CustomObject customObject = new CustomObject()
    ..mesh = mesh
    ..material = materialCustom;

  Vector4 position = new Vector4(0.0, 0.0, 0.0, 1.0);
  customObject.updateFunction = (){
    pointSize = 100 * cos(Time.currentTime / 500);
    position.x = cos(Time.currentTime / 1000) * .4;
    print(cos(Time.currentTime / 1000));
    mesh.vertices = position.storage;
  };

  return customObject;
}


