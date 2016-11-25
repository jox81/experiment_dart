import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:webgl/src/globals/context.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/mesh.dart';
import 'package:webgl/src/texture_utils.dart';
import 'dart:async';
import 'dart:web_gl';

Future<Mesh> experiment() async {

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

  Texture texture = await TextureUtils.createTextureFromFile("../images/crate.gif");

  //Material
  List<String> buffersNames = ['aVertexPosition', 'aVertexIndice'];

  MaterialCustom materialCustom = new MaterialCustom(vs, fs, buffersNames);
  materialCustom.setShaderAttributsVariables = (Mesh mesh) {
      materialCustom.setShaderAttributWithName(
          'aVertexPosition', arrayBuffer:  mesh.vertices, dimension : mesh.vertexDimensions);
      materialCustom.setShaderAttributWithName('aVertexIndice', elemetArrayBuffer:  mesh.indices);
    };
  materialCustom.setShaderUniformsVariables = (Mesh mesh) {
      materialCustom.setShaderUniformWithName("time", shaderTime);
      gl.activeTexture(GL.TEXTURE0);
      gl.bindTexture(GL.TEXTURE_2D, texture);
      materialCustom.setShaderUniformWithName("sTexture", 0);
    };

  Mesh mesh = new Mesh()
  ..mode = GL.POINTS
  ..vertices = [
    0.0, 0.0, 0.0,
    -0.5, 0.5, 0.0,
    -0.5, -0.5, 0.0,
  ]
  ..indices = [
    0,1,2
  ]
  ..material = materialCustom;

  mesh.updateFunction = (num time){
    shaderTime = time;
//    print(10.0 + 100.0 * cos(time / 500.0));
  };

  return mesh;
}





