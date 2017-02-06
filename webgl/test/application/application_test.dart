import 'dart:async';
@TestOn("dartium")

import 'dart:html';
import "package:test/test.dart";
import 'package:webgl/src/application.dart';

Future main() async {

  CanvasElement canvas;

  setUp(() async {
    canvas = querySelector('#glCanvas');
  });

  tearDown(() async {
    canvas = null;
  });

  group("Application Init", () {
    test("application create test", () async {
      Application application = await Application.create(canvas);
      expect(application, isNotNull);
    });
  });

}