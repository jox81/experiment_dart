import 'dart:async';
import 'package:webgl/src/assets_manager/assets_manager.dart';
import "package:test/test.dart";

@TestOn("chrome")

Future main() async {

  AssetManager assetManager;

  setUp(() async {
    assetManager = new AssetManager();
    assetManager.useWebPath = true;
  });

  tearDown(() async {
    assetManager = null;
  });

  group("Assets load Init", () {
    test("loadTextResource in test folder ...", () async {
      var text = await assetManager.loadTextResource('../data/test.txt');
      print(text);
      expect(text, isNotNull);
    });
  });

}