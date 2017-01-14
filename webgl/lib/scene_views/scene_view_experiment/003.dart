import 'package:webgl/src/context.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/meshes.dart';
import 'package:webgl/src/models.dart';
import 'dart:async';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

Future<Model> experiment() async {

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
    uniform sampler2D sTexture;

    vec4 color = vec4(1.0, 1.0, 1.0, 1.0);

    void main(void) {
        color = texture2D(sTexture, gl_PointCoord);
        gl_FragColor = color;
    }
  ''';

  num shaderTime = 0.0;

  WebGLTexture texture = await TextureUtils.getTextureFromFile("./images/crate.gif");

  //Material
  List<String> buffersNames = ['aVertexPosition', 'aVertexIndice'];

  MaterialCustom materialCustom = new MaterialCustom(vs, fs, buffersNames);
  materialCustom.setShaderAttributsVariables = (Model model) {
    materialCustom.setShaderAttributWithName(
        'aVertexPosition', arrayBuffer:  model.mesh.vertices, dimension : model.mesh.vertexDimensions);
    materialCustom.setShaderAttributWithName('aVertexIndice', elemetArrayBuffer:  model.mesh.indices);
  };
  materialCustom.setShaderUniformsVariables = (Model model) {
    materialCustom.setShaderUniformWithName("time", shaderTime);
    gl.activeTexture.activeUnit = TextureUnit.TEXTURE0;
    gl.activeTexture.bind(TextureTarget.TEXTURE_2D, texture);
    materialCustom.setShaderUniformWithName("sTexture", 0);
  };

  Mesh mesh = new Mesh()
  ..mode = DrawMode.POINTS
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





