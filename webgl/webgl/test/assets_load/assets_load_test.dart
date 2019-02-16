import 'dart:async';
import 'package:webgl/src/assets_manager/loaders/text_loader.dart';
import "package:test/test.dart";

@TestOn("chrome")

Future main() async {

  setUp(() async {
  });

  tearDown(() async {
  });

  group("Assets load Init", () {
    test("loadTextResource in test folder ...", () async {
      TextLoader textLoader = new TextLoader()
      ..filePath = '../data/test.txt';
      await textLoader.load();
      var text = textLoader.result;
      expect(text, isNotNull);
      print(text);
    });
  });

}