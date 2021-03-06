import 'dart:html';
import "package:test/test.dart";
import 'package:webgl/asset_library.dart';
import 'package:webgl/src/webgl_objects/context.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_uniform_location.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';

@TestOn("browser")

void main() {

  CanvasElement canvas;
  Context context;

  setUp(() async {

    await AssetLibrary.shaders.loadAll();

    canvas = new CanvasElement();
    canvas.width = 10;
    canvas.height = 10;

    context = new Context(canvas,enableExtensions:true,logInfos:false);
  });

  tearDown(() async {
    context.clear();
    context = null;
    canvas = null;
  });

  WebGLProgram getProgram(){
    final WebGLShader vertexShader = new WebGLShader(ShaderType.VERTEX_SHADER)
      ..source = AssetLibrary.shaders.materialBaseTexture.vsCode
      ..compile()
      ..logShaderInfos();

    final WebGLShader fragmentShader = new WebGLShader(ShaderType.FRAGMENT_SHADER)
      ..source = AssetLibrary.shaders.materialBaseTexture.fsCode
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