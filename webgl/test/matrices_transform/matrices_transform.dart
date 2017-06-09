import 'dart:async';
@TestOn("dartium")

import 'dart:html';
import "package:test/test.dart";
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/utils/utils_assets.dart';

Future main() async {

  UtilsAssets.useWebPath = true;

  CanvasElement canvas;

  setUp(() async {
    canvas = querySelector('#glCanvas');
  });

  tearDown(() async {
    canvas = null;
  });

  group("Application Init", () {
    test("application create test2", () async {
      Application application = await Application.create(canvas);

      Camera camera = new Camera(radians(37.0), 0.1, 100.0)
        ..targetPosition = new Vector3.zero()
        ..position = new Vector3(0.0, 0.0, -1.0);
      Context.mainCamera = camera;

      //Todo ?...
    });
  });

}