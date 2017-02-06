import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import "package:test/test.dart";
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/utils_assets.dart';

@TestOn("dartium")

Future main() async {

  UtilsAssets.useWebPath = true;

  Map testJson;
  String testJonString;
  Application application;
  CanvasElement canvas;

  setUp(() async {
    testJson = await UtilsAssets.loadJSONResource('../objects/json_scene.json');
    testJonString = await UtilsAssets.loadTextResource('../objects/json_scene.json');
    CanvasElement canvas = querySelector('#glCanvas');
    application = await Application.create(canvas);
  });

  tearDown(() async {
    canvas = null;
    application = null;
    testJson = null;
    testJonString = null;
  });

  group("json read", () {
    test("test 01", () {
      String type = testJson['scene']['models'][0]["type"];
      expect(type, equals("ModelType.quad"));
    });
  });

  group("test scene", () {
    test("scene creation", () {
      Scene scene = new Scene.fromJson(testJson);
      expect(scene,isNotNull);
    });

    test("scene background color", () {
      Scene scene = new Scene.fromJson(testJson);
      var result = scene.backgroundColor;
      var value = new Vector4.fromFloat32List(new Float32List.fromList([0.5,
      1.0,
      0.2,
      1.0]));
      expect(result == value,isTrue);
    });

    test("scene camera", () {
      Scene scene = new Scene.fromJson(testJson);
      var result = scene.cameras.length;
      expect(result == 1, isTrue);
    });

    test("scene models", () {
      Scene scene = new Scene.fromJson(testJson);
      expect(scene.models.length == 2, isTrue);
    });

    test("save scene to json", () {
      Scene scene = new Scene.fromJson(testJson);
      //on est obligé d'encoder la testJson car l'encode compresse et crée donc une différence
      expect(JSON.encode(testJson) == JSON.encode(scene), isTrue);
    });
  });
}