import 'dart:html';
import "package:test/test.dart";
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/gltf/renderer/materials.dart';
import 'package:webgl/src/material/shader_source.dart';
import 'package:webgl/src/utils/utils_assets.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';

@TestOn("browser")

void main() {

  assetManager.useWebPath = true;

  CanvasElement canvas;

  setUp(() async {

    canvas = new Element.html('<canvas/>') as CanvasElement;
    canvas.width = 10;
    canvas.height = 10;

    await ShaderSource.loadShaders();

    Context.init(canvas,enableExtensions:true,logInfos:false);
  });

  tearDown(() async {
    gl = null;
    canvas = null;
  });

  group("Shader", () {
    test("MaterialPoint", () {
      MaterialPoint material = new MaterialPoint(pointSize:10.0, color:new Vector4(0.0, 0.66, 1.0, 1.0));
      expect(material, isNotNull);
      expect(material.shaderSource, isNotNull);

      WebGLProgram program = material.getProgram();
      expect(program, isNotNull);
    });
//    test("KronosPRBMaterial", () {
//      KronosPRBMaterial material = new KronosPRBMaterial(false, false, false, false);
//      expect(material, isNotNull);
//      expect(material.shaderSource, isNotNull);
//
//      WebGLProgram program = material.getProgram();
//      expect(program, isNotNull);
//    });
    test("MaterialSAO", () {
      MaterialSAO material = new MaterialSAO();
      expect(material, isNotNull);
      expect(material.shaderSource, isNotNull);

      WebGLProgram program = material.getProgram();
      expect(program, isNotNull);
    });
  });
}