import 'dart:async';
import 'dart:html';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/material/shader_source.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';

Future main() async {
  await ShaderSource.loadShaders();

  WebglTest webglTest =
      new WebglTest(querySelector('#glCanvas') as CanvasElement);

  webglTest.setup();
}

class WebglTest {

  WebglTest(CanvasElement canvas) {
    Context.init(canvas, enableExtensions: true, logInfos: false);
  }

  void setup() {

    gl.clearColor(1.0,0.0,0.0,1.0);

    WebGLShader vertexShader = new WebGLShader(ShaderType.VERTEX_SHADER)
      ..source = ShaderSource.materialPoint.vsCode
      ..compile();

    WebGLShader fragmentShader = new WebGLShader(ShaderType.FRAGMENT_SHADER)
      ..source = ShaderSource.materialPoint.fsCode
      ..compile();

    WebGLProgram program = new WebGLProgram();

    program
      ..attachShader(vertexShader)
      ..attachShader(fragmentShader)
      ..link()
      ..validate()
      ..use();

    Context.glWrapper.logRenderingContextInfos();

  }

}