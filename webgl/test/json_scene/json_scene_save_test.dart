import 'dart:async';
import 'dart:typed_data';
import "package:test/test.dart";
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/utils/utils_assets.dart';

@TestOn("dartium")

Future main() async {

  UtilsAssets.useWebPath = true;

  Map testJson;

  setUp(() async {
    testJson = await UtilsAssets.loadJSONResource('../objects/json_scene.json');
//    CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;
//    await Application.build(canvas);
  });

  tearDown(() async {
    testJson = null;
  });

  group("json read", () {
    test("test 01", () {
      String type = testJson['scene']['models'][0]["type"] as String;
      expect(type, equals("ModelType.quad"));
    });
  });

  group("test scene", () {
    test("scene creation", () {
      Scene scene = new SceneJox.fromJson(testJson);
      expect(scene,isNotNull);
    });

    test("scene background color", () {
      Scene scene = new SceneJox.fromJson(testJson);
      var result = scene.backgroundColor;
      var value = new Vector4.fromFloat32List(new Float32List.fromList([0.5,
      1.0,
      0.2,
      1.0]));
      expect(result == value,isTrue);
    });

    test("scene camera", () {
      Scene scene = new SceneJox.fromJson(testJson);
      var result = scene.cameras.length;
      expect(result == 1, isTrue);
    });

    test("scene models", () {
      Scene scene = new SceneJox.fromJson(testJson);
      expect(scene.meshes.length == 2, isTrue);
    });

    // Todo (jpu) : don't work anymore : check to save as gltf
//    test("save scene to json", () {
//      Scene scene = new Scene.fromJson(testJson);
//      //on est obligé d'encoder la testJson car l'encode compresse et crée donc une différence
//      print(JSON.encode(testJson));
//      print(JSON.encode(scene));
//      expect(JSON.encode(testJson) , JSON.encode(scene));
//    });
  });
}