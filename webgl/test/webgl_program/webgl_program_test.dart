import 'dart:html';
import "package:test/test.dart";
import 'package:webgl/src/context.dart';
import 'package:webgl/src/utils/utils_assets.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'dart:web_gl' as WebGL;

@TestOn("dartium")

void main() {

  UtilsAssets.useWebPath = true;

  CanvasElement canvas;

  setUp(() async {

    canvas = new Element.html('<canvas/>');
    canvas.width = 10;
    canvas.height = 10;

    Context.init(canvas,enableExtensions:true,logInfos:false);
  });

  tearDown(() async {
    gl = null;
    canvas = null;
  });

  group("WebGLProgram CTOR", () {
    // >> base

    test("WebGLUniformLocation CTOR base", () {
      WebGLProgram program = new WebGLProgram();
      expect(program, isNotNull);
    });

    // >> fromWebGL

    test("WebGLUniformLocation CTOR fromWebGL", () {
      WebGL.Program webGLProgram = gl.ctx.createProgram();
      WebGLProgram program = new WebGLProgram.fromWebGL(webGLProgram);
      expect(program, isNotNull);
    });
  });

}