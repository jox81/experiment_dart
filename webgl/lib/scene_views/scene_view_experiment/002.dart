import 'package:webgl/src/materials.dart';
import 'package:webgl/src/meshes.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

Model experiment() {

  String vs = '''
    precision mediump float;

    attribute vec3 aVertexPosition;

    uniform float time;

    void main(void) {
      gl_Position = vec4(aVertexPosition.x + cos(time / 1000.0) * .4, aVertexPosition.y, aVertexPosition.z,  1.0);
      gl_PointSize = max(10.0 , 105.0 * cos(time / 500.0));
    }
  ''';

  String fs = '''
    precision mediump float;

    uniform float time;

    vec4 color = vec4(1.0, 1.0, 1.0, 1.0);

    void main(void) {
        color.b = 1.0 - cos(time / 500.0);
        gl_FragColor = color;
    }
  ''';

  num shaderTime = 0.0;

  //Material
  List<String> buffersNames = ['aVertexPosition', 'aVertexIndice'];

  MaterialCustom materialCustom = new MaterialCustom(vs, fs, buffersNames);
  materialCustom.setShaderAttributsVariables = (Model model) {
      materialCustom.setShaderAttributArrayBuffer(
          'aVertexPosition', model.mesh.vertices, model.mesh.vertexDimensions);
      materialCustom.setShaderAttributElementArrayBuffer('aVertexIndice', model.mesh.indices);
    };
  materialCustom.setShaderUniformsVariables = (Model model) {
      materialCustom.setShaderUniform("time", shaderTime);
    };

  Mesh mesh = new Mesh()
  ..mode = DrawMode.TRIANGLE_STRIP
  ..vertices = [
    0.0, 0.0, 0.0,
    -0.5, 0.5, 0.0,
    -0.5, -0.5, 0.0,
  ]
  ..indices = [
    0,1,2
  ];
  CustomObject customObject = new CustomObject()
    ..mesh = mesh
    ..material = materialCustom;

  customObject.updateFunction = (num time){
    shaderTime = time;
//    print(10.0 + 100.0 * cos(time / 500.0));
  };

  return customObject;
}


