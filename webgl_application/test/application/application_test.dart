import 'dart:async';
@TestOn("dartium")

import 'dart:html';
import "package:test/test.dart";
import 'package:webgl/src/utils/utils_assets.dart';
import 'package:webgl_application/src/application.dart';

Future main() async {

  UtilsAssets.useWebPath = true;

  CanvasElement canvas;

  setUp(() async {
    canvas = querySelector('#glCanvas') as CanvasElement;
  });

  tearDown(() async {
    canvas = null;
  });

  group("Application Init", () {
    test("application create test", () async {
      Application application = await Application.build(canvas);
      expect(application, isNotNull);
    });
  });

}