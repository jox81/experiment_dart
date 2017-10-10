import 'dart:html';
import "package:test/test.dart";
import 'package:webgl/src/context.dart';
import 'package:webgl/src/material/shader_source.dart';
import 'package:webgl/src/utils/utils_assets.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_uniform_location.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';

@TestOn("dartium")

void main() {

  UtilsAssets.useWebPath = true;

  CanvasElement canvas;

  setUp(() async {
    await ShaderSource.loadShaders();

    canvas = new Element.html('<canvas/>') as CanvasElement;
    canvas.width = 10;
    canvas.height = 10;

    Context.init(canvas,enableExtensions:true,logInfos:false);
  });

  tearDown(() async {
    gl = null;
    canvas = null;
  });

  WebGLProgram getProgram(){
    WebGLShader vertexShader = new WebGLShader(ShaderType.VERTEX_SHADER)
      ..source = ShaderSource.sources['material_base_texture'].vsCode
      ..compile();
    vertexShader.logShaderInfos();

    WebGLShader fragmentShader = new WebGLShader(ShaderType.FRAGMENT_SHADER)
      ..source = ShaderSource.sources['material_base_texture'].fsCode
      ..compile();

    fragmentShader.logShaderInfos();

    WebGLProgram program = new WebGLProgram()
      ..attachShader(vertexShader)
      ..attachShader(fragmentShader)
      ..link()
      ..validate()
      ..use();

    return program;
  }

  group("WebGLUniformLocation CTOR", () {
    test("WebGLUniformLocation init with nulls", () {
      WebGLUniformLocation uniform = new WebGLUniformLocation(null, null);
      expect(uniform, isNotNull);
    });

    test("WebGLUniformLocation init with nulls + ", () {
      WebGLUniformLocation uniform = new WebGLUniformLocation(null, null);
      Function function = (){
        uniform.uniformMatrix4fv(null, null);
      };
      expect(function, throws);
    });
  });

  group("WebGLUniformLocation uniformMatrix4fv", () {
    test("WebGLUniformLocation init with nulls", () {
      WebGLProgram program = getProgram();
      WebGLUniformLocation uniform = new WebGLUniformLocation(program, null);
      expect(uniform, isNotNull);
    });
  });

}