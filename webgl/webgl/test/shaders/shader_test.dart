import 'dart:html';
import "package:test/test.dart";
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/webgl_objects/context.dart';
import 'package:webgl/materials.dart';
import 'package:webgl/src/materials/types/sao_material.dart';
import 'package:webgl/src/shaders/shader_source.dart';
import 'package:webgl/src/assets_manager/assets_manager.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';

@TestOn("browser")

void main() {

  AssetManager assetManager;

  CanvasElement canvas;
  Context context;

  setUp(() async {
    assetManager = new AssetManager();
    assetManager.useWebPath = true;
    canvas = new Element.html('<canvas/>') as CanvasElement;
    canvas.width = 10;
    canvas.height = 10;

    ShaderSources shaderSources = new ShaderSources(assetManager);
    await shaderSources.loadShaders();

    context = new Context(canvas,enableExtensions:true,logInfos:false);
  });

  tearDown(() async {
    context.clear();
    context = null;
    canvas = null;
    assetManager = null;
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