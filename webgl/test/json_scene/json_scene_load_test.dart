import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import "package:test/test.dart";
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/geometry/models.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/utils/utils_assets.dart';

@TestOn("dartium")

Future main() async {

  UtilsAssets.useWebPath = true;

  Map testJson;

  Application application;
  CanvasElement canvas;

  setUp(() async {
    testJson = await UtilsAssets.loadJSONResource('../objects/json_scene.json');
    canvas = querySelector('#glCanvas') as CanvasElement;
    application = await Application.create(canvas);
  });

  tearDown(() async {
    canvas = null;
    application = null;
//    testJson = null;
  });

  group("json read", () {
    test("test 01", () {
      String type = testJson['scene']['models'][0]["type"] as String;
      expect(type, equals("ModelType.quad"));
    });
  });

  group("test CameraPerspective", () {
    test("test camera creation", () {
      GLTFCameraPerspective camera = new GLTFCameraPerspective.fromJson(testJson['scene']['cameras'][0] as Map);
      expect(camera != null,isTrue);
    });
    test("test camera fov", () {
      GLTFCameraPerspective camera = new GLTFCameraPerspective.fromJson(testJson['scene']['cameras'][0] as Map);
      expect(camera.yfov == 25.0,isTrue);
    });
    test("test camera zNear", () {
      GLTFCameraPerspective camera = new GLTFCameraPerspective.fromJson(testJson['scene']['cameras'][0] as Map);
      print(camera.znear);
      expect(camera.znear == 0.1,isTrue);
    });
    test("test camera zFar", () {
      GLTFCameraPerspective camera = new GLTFCameraPerspective.fromJson(testJson['scene']['cameras'][0] as Map);
      expect(camera.zfar == 100.0,isTrue);
    });
    test("test camera targetPosition", () {
      GLTFCameraPerspective camera = new GLTFCameraPerspective.fromJson(testJson['scene']['cameras'][0] as Map);
      expect(camera.targetPosition == new Vector3(0.0,0.0,0.0),isTrue);
    });
    test("test camera targetPosition new", () {
      GLTFCameraPerspective camera = new GLTFCameraPerspective(25.0,1.0,10.0)
        ..targetPosition = new Vector3.fromFloat32List(new Float32List.fromList(testJson['scene']['cameras'][0]['targetPosition'] as List<double>));
      expect(camera.targetPosition == new Vector3(0.0,0.0,0.0),isTrue);
    });
    test("test camera position", () {
      GLTFCameraPerspective camera = new GLTFCameraPerspective.fromJson(testJson['scene']['cameras'][0] as Map);
      expect(camera.position == new Vector3(10.0,10.0,10.0),isTrue);
    });
    test("test camera position new", () {
      GLTFCameraPerspective camera = new GLTFCameraPerspective(25.0,1.0,10.0)
        ..position = new Vector3.fromFloat32List(new Float32List.fromList(testJson['scene']['cameras'][0]['position'] as List<double>));
      expect(camera.position == new Vector3(10.0,10.0,10.0),isTrue);
    });
    test("test camera showGizmo", () {
      GLTFCameraPerspective camera = new GLTFCameraPerspective.fromJson(testJson['scene']['cameras'][0] as Map);
      expect(camera.showGizmo,isTrue);
    });
  });

  group("test model 01", () {
    test("test model", () {
      Model model = new Model.fromJson(testJson['scene']['models'][0] as Map);

      expect(model is QuadModel,isTrue);
    });
    test("test model name", () {
      Model model = new Model.fromJson(testJson['scene']['models'][0] as Map);

      expect(model.name == 'quad',isTrue);
    });
    test("test model position", () {
      Model model = new Model.fromJson(testJson['scene']['models'][0] as Map);

      expect(model.position == new Vector3(5.0, 0.0, -5.0),isTrue);
    });
  });

  group("test model 02", () {
    test("test model", () {
      Model model = new Model.fromJson(testJson['scene']['models'][1] as Map);

      expect(model is CubeModel,isTrue);
    });
    test("test model name", () {
      Model model = new Model.fromJson(testJson['scene']['models'][1] as Map);
      expect(model.name == 'cube',isTrue);
    });
    test("test model position", () {
      Model model = new Model.fromJson(testJson['scene']['models'][1] as Map);
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
      expect(scene.backgroundColor,equals(new Vector4.fromFloat32List(new Float32List.fromList([0.5,
      1.0,
      0.2,
      1.0]))));
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