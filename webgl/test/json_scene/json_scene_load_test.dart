import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import "package:test/test.dart";
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/utils_assets.dart';

@TestOn("dartium")

Future main() async {

  var testJson = await UtilsAssets.loadJSONResource('../objects/json_scene.json');

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

  group("test camera", () {
    test("test camera creation", () {
      Camera camera = new Camera.fromJson(testJson['scene']['cameras'][0]);
      expect(camera != null,isTrue);
    });
    test("test camera fov", () {
      Camera camera = new Camera.fromJson(testJson['scene']['cameras'][0]);
      expect(camera.fov == 25.0,isTrue);
    });
    test("test camera zNear", () {
      Camera camera = new Camera.fromJson(testJson['scene']['cameras'][0]);
      expect(camera.zNear == 0.1,isTrue);
    });
    test("test camera zFar", () {
      Camera camera = new Camera.fromJson(testJson['scene']['cameras'][0]);
      expect(camera.zFar == 100.0,isTrue);
    });
    test("test camera targetPosition", () {
      Camera camera = new Camera.fromJson(testJson['scene']['cameras'][0]);
      expect(camera.targetPosition == new Vector3(0.0,0.0,0.0),isTrue);
    });
    test("test camera targetPosition new", () {
      Camera camera = new Camera(25.0,1.0,10.0)
        ..targetPosition = new Vector3.fromFloat32List(new Float32List.fromList(testJson['scene']['cameras'][0]['targetPosition']));;
      expect(camera.targetPosition == new Vector3(0.0,0.0,0.0),isTrue);
    });
    test("test camera position", () {
      Camera camera = new Camera.fromJson(testJson['scene']['cameras'][0]);
      expect(camera.position == new Vector3(10.0,10.0,10.0),isTrue);
    });
    test("test camera position new", () {
      Camera camera = new Camera(25.0,1.0,10.0)
        ..position = new Vector3.fromFloat32List(new Float32List.fromList(testJson['scene']['cameras'][0]['position']));;
      expect(camera.position == new Vector3(10.0,10.0,10.0),isTrue);
    });
    test("test camera showGizmo", () {
      Camera camera = new Camera.fromJson(testJson['scene']['cameras'][0]);
      expect(camera.showGizmo,isTrue);
    });
  });

  group("test model 01", () {
    test("test model", () {
      Model model = new Model.fromJson(testJson['scene']['models'][0]);

      expect(model is QuadModel,isTrue);
    });
    test("test model name", () {
      Model model = new Model.fromJson(testJson['scene']['models'][0]);

      expect(model.name == 'quad',isTrue);
    });
    test("test model position", () {
      Model model = new Model.fromJson(testJson['scene']['models'][0]);

      expect(model.position == new Vector3(5.0, 0.0, -5.0),isTrue);
    });
  });

  group("test model 02", () {
    test("test model", () {
      Model model = new Model.fromJson(testJson['scene']['models'][1]);

      expect(model is CubeModel,isTrue);
    });
    test("test model name", () {
      Model model = new Model.fromJson(testJson['scene']['models'][1]);
      expect(model.name == 'cube',isTrue);
    });
    test("test model position", () {
      Model model = new Model.fromJson(testJson['scene']['models'][1]);
      expect(model.position == new Vector3(0.0, 0.0, 0.0),isTrue);
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
  });
}