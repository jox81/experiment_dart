import 'package:webgl/src/context.dart';
import 'package:webgl/src/gltf/mesh_primitive.dart';

import 'dart:async';

import 'package:webgl/src/time/time.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

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

  WebGLTexture texture = await TextureUtils.createTexture2DFromFile("./images/crate.gif");

  //Material
  MaterialCustom materialCustom = new MaterialCustom(vs, fs);
  materialCustom.setShaderAttributsVariables = (Mesh model) {
    materialCustom.setShaderAttributArrayBuffer(
        'aVertexPosition', model.primitive.vertices, model.primitive.vertexDimensions);
    materialCustom.setShaderAttributElementArrayBuffer('aVertexIndice', model.primitive.indices);
  };
  materialCustom.setShaderUniformsVariables = (Mesh model) {
    materialCustom.setShaderUniform("time", shaderTime);
    gl.activeTexture(TextureUnit.TEXTURE0);
    gl.bindTexture(TextureTarget.TEXTURE_2D, texture.webGLTexture);
    materialCustom.setShaderUniform("sTexture", 0);
  };

  MeshPrimitive primitive = new MeshPrimitive()
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
    ..primitive = primitive
    ..material = materialCustom;

  customObject.updateFunction = (){
    shaderTime = Time.currentTime;
//    print(10.0 + 100.0 * cos(Time.currentTime / 500.0));
  };

  return customObject;
}





