import 'dart:async';
import 'dart:html';
import 'dart:mirrors';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/context/webgl_parameters.dart';
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/utils.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
import 'package:webgl/src/webgl_objects/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_rendering_context.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';
import 'package:webgl/src/webgl_objects/webgl_uniform_location.dart';

Future main() async {
  await ShaderSource.loadShaders();

  WebglShaderTest webglShaderTest =
      new WebglShaderTest(querySelector('#glCanvas'));

  webglShaderTest.setup();
}

class WebglShaderTest {
  WebGLShader vertexShader;

  WebglShaderTest(CanvasElement canvas) {
    Context.init(canvas, enableExtensions: true, logInfos: false);
  }

  void setup() {
//    PrecisionType pt = PrecisionType.getByIndex(0x8DF3);
//    ShaderVariableType svt = ShaderVariableType.getByIndex(0x8B5E);

//    ShaderType st = ShaderType.VERTEX_SHADER;
    vertexShader = new WebGLShader(ShaderType.VERTEX_SHADER);
    vertexShader.source = ShaderSource.sources['material_point'].vsCode;
    vertexShader.compile();
    logShaderInfos(vertexShader);
  }

  void logShaderInfos(WebGLShader shader) {
    Utils.log("Shader Infos", () {
      print('deleteStatus : ${shader.deleteStatus}');
      print('compileStatus : ${shader.compileStatus}');
      print('shaderType : ${shader.shaderType}');
      print('isShader : ${shader.isShader}');
      print('infoLog : ${shader.infoLog}');
      print('source : \n\n${shader.source}');
      print(
          'VERTEX_ATTRIB_ARRAY_BUFFER_BINDING : ${shader.getVertexAttrib(0, VertexAttribGlEnum.CURRENT_VERTEX_ATTRIB)}');
      print(
          'VERTEX_ATTRIB_ARRAY_ENABLED : ${shader.getVertexAttrib(0, VertexAttribGlEnum.VERTEX_ATTRIB_ARRAY_ENABLED)}');
      print(
          'VERTEX_ATTRIB_ARRAY_SIZE : ${shader.getVertexAttrib(0, VertexAttribGlEnum.VERTEX_ATTRIB_ARRAY_SIZE)}');
      print(
          'VERTEX_ATTRIB_ARRAY_STRIDE : ${shader.getVertexAttrib(0, VertexAttribGlEnum.VERTEX_ATTRIB_ARRAY_STRIDE)}');
      print(
          'VERTEX_ATTRIB_ARRAY_TYPE : ${ShaderVariableType.getByIndex(shader.getVertexAttrib(0, VertexAttribGlEnum.VERTEX_ATTRIB_ARRAY_TYPE))}');
      print(
          'VERTEX_ATTRIB_ARRAY_NORMALIZED : ${shader.getVertexAttrib(0, VertexAttribGlEnum.VERTEX_ATTRIB_ARRAY_NORMALIZED)}');
      print(
          'CURRENT_VERTEX_ATTRIB : ${shader.getVertexAttrib(0, VertexAttribGlEnum.CURRENT_VERTEX_ATTRIB)}');
    });
  }
}
