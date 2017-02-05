import 'dart:async';
import 'dart:convert';
import 'dart:html';
import "package:test/test.dart";
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/utils.dart';

@TestOn("dartium")

Future main() async {

  Map testJson = await Utils.loadJSONResource('../objects/json_scene.json');
  String testJonString = await Utils.loadTextResource('../objects/json_scene.json');

  Application application;
  CanvasElement canvas;

  setUp(() async {
    CanvasElement canvas = querySelector('#glCanvas');
    application = await Application.create(canvas);
  });

  tearDown(() async {
    canvas = null;
    application = null;
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
      expect(scene.backgroundColor,equals(new Vector4.fromFloat32List([0.5,
      1.0,
      0.2,
      1.0])));
    });

    test("scene camera", () {
      Scene scene = new Scene.fromJson(testJson);
      expect(scene.cameras.length == 1, isTrue);
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