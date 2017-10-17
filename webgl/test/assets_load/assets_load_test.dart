import 'dart:async';
import 'package:webgl/src/utils/utils_assets.dart';
import "package:test/test.dart";

@TestOn("dartium")

Future main() async {

  UtilsAssets.useWebPath = true;

  setUp(() async {

  });

  tearDown(() async {
  });

  group("Assets load Init", () {
    test("loadTextResource ..", () async {
      var text = await UtilsAssets.loadTextResource('../test.txt');
      print(text);
      expect(text, isNotNull);
    });
  });

}