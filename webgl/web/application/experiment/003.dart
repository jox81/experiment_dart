import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/mesh.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/texture.dart';
import 'dart:async';
import 'dart:web_gl';
import 'dart:html';

Future<Mesh> experiment(RenderingContext gl) async {

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

  TextureMap textureMap = await TextureMap.createTextureMap("../images/crate.gif");

  //Material
  List<String> buffersNames = ['aVertexPosition', 'aVertexIndice'];

  MaterialCustom materialCustom = new MaterialCustom(vs, fs, buffersNames);
  materialCustom.setShaderAttributsVariables = (Mesh mesh) {
      materialCustom.setShaderAttributWithName(
          'aVertexPosition', mesh.vertices, mesh.vertexDimensions);
      materialCustom.setShaderAttributWithName('aVertexIndice', mesh.indices, null);
    };
  materialCustom.setShaderUniformsVariables = (Mesh mesh) {
      materialCustom.setShaderUniformWithName("time", shaderTime);
      gl.activeTexture(GL.TEXTURE0);
      gl.bindTexture(GL.TEXTURE_2D, textureMap.texture);
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

  mesh.animation = (num time){
    shaderTime = time;
//    print(10.0 + 100.0 * cos(time / 500.0));
  };

  return mesh;
}




