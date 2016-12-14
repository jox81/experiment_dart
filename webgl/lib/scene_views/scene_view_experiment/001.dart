
import 'dart:web_gl';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/meshes.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/models.dart';

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
  List<String> buffersNames = ['aVertexPosition'];

  MaterialCustom materialCustom = new MaterialCustom(vs, fs, buffersNames);
  materialCustom.setShaderAttributsVariables = (Mesh mesh) {
      materialCustom.setShaderAttributWithName(
          'aVertexPosition', arrayBuffer:  mesh.vertices, dimension : mesh.vertexDimensions);
    };
  materialCustom.setShaderUniformsVariables = (Mesh mesh) {
      materialCustom.setShaderUniformWithName("pointSize", pointSize);
    };

  Mesh mesh = new Mesh()
  ..mode = RenderingContext.POINTS
  ..vertices = [
  ];
  CustomObject customObject = new CustomObject()
    ..mesh = mesh
    ..material = materialCustom;

  Vector4 position = new Vector4(0.0, 0.0, 0.0, 1.0);
  customObject.updateFunction = (num time){
    pointSize = 100 * cos(time / 500);
    position.x = cos(time / 1000) * .4;
    print(cos(time / 1000));
    mesh.vertices = position.storage;
  };

  return customObject;
}


