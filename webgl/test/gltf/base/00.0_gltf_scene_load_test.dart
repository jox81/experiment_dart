import 'dart:async';
import "package:test/test.dart";
import 'package:gltf/gltf.dart' as glTF;

import 'package:webgl/src/utils/utils_gltf.dart';

@TestOn("dartium")

Future main() async {

  group("test camera", () {
    test("test camera creation", () async {
      glTF.Gltf gltf = await GLTFProject.loadGLTFResource('gltf/tests/base/data/camera/empty.gltf', useWebPath:true);

      GLTFProject gltfObject = new GLTFProject.fromGltf(gltf);
      expect(gltfObject, isNotNull);
    });
  });
}
