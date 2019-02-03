import 'dart:async';
import 'package:webgl/src/assets_manager/assets_manager.dart';
import "package:test/test.dart";

@TestOn("chrome")

Future main() async {

  assetManager.useWebPath = true;

  setUp(() async {

  });

  tearDown(() async {
  });

  group("Assets load Init", () {
    test("loadTextResource ..", () async {
      var text = await assetManager.loadTextResource('../test.txt');
      print(text);
      expect(text, isNotNull);
    });
  });

}