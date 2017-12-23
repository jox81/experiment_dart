import 'dart:async';
import "package:test/test.dart";
import 'package:webgl/src/gtlf/debug_gltf.dart';
import 'package:webgl/src/gtlf/project.dart';

@TestOn("dartium")

Future main() async {
  group("test camera", () {
    test("test camera creation", () async {
      GLTFProject gltfObject = await debugGltf('gltf/tests/base/data/camera/empty.gltf', doGlTFProjectLog : false, isDebug:false, useWebPath: true);
      expect(gltfObject, isNotNull);
    });
  });
}
