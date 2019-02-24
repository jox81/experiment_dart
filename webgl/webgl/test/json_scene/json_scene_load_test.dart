import 'dart:async';
//import 'dart:html';
//import 'dart:typed_data';
import "package:test/test.dart";
//import 'package:vector_math/vector_math.dart';
//import 'package:webgl/src/gltf/camera/camera.dart';
//import 'package:webgl/src/gltf/scene.dart';
//import 'package:webgl/src/utils/utils_assets.dart';
//import 'package:webgl/src/gltf/mesh/mesh.dart';

@TestOn("browser")

Future main() async {
//
//  UtilsAssets.useWebPath = true;
//
//  Map testJson;
//
//  CanvasElement canvas;
//
//  setUp(() async {
//    testJson = await UtilsAssets.loadJSONResource('../objects/json_scene.json');
////    canvas = querySelector('#glCanvas') as CanvasElement;
////    await Application.build(canvas);
//  });
//
//  tearDown(() async {
//    canvas = null;
//  });
//
//  group("json read", () {
//    test("test 01", () {
//      String type = testJson['scene']['models'][0]["type"] as String;
//      expect(type, equals("ModelType.quad"));
//    });
//  });
//
//  group("test CameraPerspective", () {
//    test("test camera creation", () {
//      CameraPerspective camera = new CameraPerspective.fromJson(testJson['scene']['cameras'][0] as Map);
//      expect(camera != null,isTrue);
//    });
//    test("test camera fov", () {
//      CameraPerspective camera = new CameraPerspective.fromJson(testJson['scene']['cameras'][0] as Map);
//      expect(camera.yfov == 25.0,isTrue);
//    });
//    test("test camera zNear", () {
//      CameraPerspective camera = new CameraPerspective.fromJson(testJson['scene']['cameras'][0] as Map);
//      print(camera.znear);
//      expect(camera.znear == 0.1,isTrue);
//    });
//    test("test camera zFar", () {
//      CameraPerspective camera = new CameraPerspective.fromJson(testJson['scene']['cameras'][0] as Map);
//      expect(camera.zfar == 100.0,isTrue);
//    });
//    test("test camera targetPosition", () {
//      CameraPerspective camera = new CameraPerspective.fromJson(testJson['scene']['cameras'][0] as Map);
//      expect(camera.targetPosition == new Vector3(0.0,0.0,0.0),isTrue);
//    });
//    test("test camera targetPosition new", () {
//      CameraPerspective camera = new CameraPerspective(25.0,1.0,10.0)
//        ..targetPosition = new Vector3.fromFloat32List(new Float32List.fromList(testJson['scene']['cameras'][0]['targetPosition'] as List<double>));
//      expect(camera.targetPosition == new Vector3(0.0,0.0,0.0),isTrue);
//    });
//    test("test camera position", () {
//      CameraPerspective camera = new CameraPerspective.fromJson(testJson['scene']['cameras'][0] as Map);
//      expect(camera.translation == new Vector3(10.0,10.0,10.0),isTrue);
//    });
//    test("test camera position new", () {
//      CameraPerspective camera = new CameraPerspective(25.0,1.0,10.0)
//        ..translation = new Vector3.fromFloat32List(new Float32List.fromList(testJson['scene']['cameras'][0]['position'] as List<double>));
//      expect(camera.translation == new Vector3(10.0,10.0,10.0),isTrue);
//    });
////    test("test camera showGizmo", () {
////      CameraPerspective camera = new CameraPerspective.fromJson(testJson['scene']['cameras'][0] as Map);
////      expect(camera.showGizmo,isTrue);
////    });
//  });
//
//  group("test model 01", () {
//    test("test model", () {
//      GLTFMesh model = new Mesh.fromJson(testJson['scene']['models'][0] as Map);
//
//      expect(model is QuadMesh,isTrue);
//    });
//    test("test model name", () {
//      GLTFMesh model = new Mesh.fromJson(testJson['scene']['models'][0] as Map);
//
//      expect(model.name == 'quad',isTrue);
//    });
//    test("test model position", () {
//      GLTFMesh model = new Mesh.fromJson(testJson['scene']['models'][0] as Map);
//
//      expect(model.translation == new Vector3(5.0, 0.0, -5.0),isTrue);
//    });
//  });
//
//  group("test model 02", () {
//    test("test model", () {
//      GLTFMesh model = new Mesh.fromJson(testJson['scene']['models'][1] as Map);
//
//      expect(model is CubeMesh,isTrue);
//    });
//    test("test model name", () {
//      GLTFMesh model = new Mesh.fromJson(testJson['scene']['models'][1] as Map);
//      expect(model.name == 'cube',isTrue);
//    });
//    test("test model position", () {
//      GLTFMesh model = new Mesh.fromJson(testJson['scene']['models'][1] as Map);
//      expect(model.translation == new Vector3(0.0, 0.0, 0.0),isTrue);
//    });
//  });
//
//  group("test scene", () {
//    test("scene creation", () {
//      GLTFScene scene = new SceneJox.fromJson(testJson);
//      expect(scene,isNotNull);
//    });
//
//    test("scene background color", () {
//      GLTFScene scene = new SceneJox.fromJson(testJson);
//      expect(scene.backgroundColor,equals(new Vector4.fromFloat32List(new Float32List.fromList([0.5,
//      1.0,
//      0.2,
//      1.0]))));
//    });
//
//    test("scene camera", () {
//      GLTFScene scene = new SceneJox.fromJson(testJson);
//      expect(scene.cameras.length == 1, isTrue);
//    });
//
//    test("scene models", () {
//      GLTFScene scene = new SceneJox.fromJson(testJson);
//      expect(scene.meshes.length == 2, isTrue);
//    });
//  });
}