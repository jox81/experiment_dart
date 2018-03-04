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

    canvas = new CanvasElement.created()
    ..width = 10
    ..height = 10;

    Context.init(canvas,enableExtensions:true,logInfos:false);
  });

  tearDown(() async {
    gl = null;
    canvas = null;
  });

  WebGLProgram getProgram(){
    final WebGLShader vertexShader = new WebGLShader(ShaderType.VERTEX_SHADER)
      ..source = ShaderSource.materialBaseTexture.vsCode
      ..compile()
      ..logShaderInfos();

    final WebGLShader fragmentShader = new WebGLShader(ShaderType.FRAGMENT_SHADER)
      ..source = ShaderSource.materialBaseTexture.fsCode
      ..compile()
      ..logShaderInfos();

    final WebGLProgram program = new WebGLProgram()
      ..attachShader(vertexShader)
      ..attachShader(fragmentShader)
      ..link()
      ..validate()
      ..use();

    return program;
  }

  group("WebGLUniformLocation CTOR", () {
    test("WebGLUniformLocation init with nulls", () {
      final WebGLUniformLocation uniform = new WebGLUniformLocation(null, null);
      expect(uniform, isNotNull);
    });

    test("WebGLUniformLocation init with nulls + ", () {
      final WebGLUniformLocation uniform = new WebGLUniformLocation(null, null);
      final Function function = (){
        uniform.uniformMatrix4fv(null, null);
      };
      expect(function, throwsA);
    });
  });

  group("WebGLUniformLocation uniformMatrix4fv", () {
    test("WebGLUniformLocation init with nulls", () {
      final WebGLProgram program = getProgram();
      final WebGLUniformLocation uniform = new WebGLUniformLocation(program, null);
      expect(uniform, isNotNull);
    });
  });

}