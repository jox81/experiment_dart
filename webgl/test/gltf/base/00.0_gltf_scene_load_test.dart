import 'dart:async';
import "package:test/test.dart";
import 'package:webgl/src/gltf/debug_gltf.dart';
import 'package:webgl/src/gltf/project.dart';

@TestOn("dartium")

Future main() async {
  group("test camera", () {
    test("test camera creation", () async {
      GLTFProject project = await loadGLTF('gltf/tests/base/data/camera/empty.gltf', useWebPath : false);
      await debugGltf(project, doGlTFProjectLog : false, isDebug:false);
      expect(project, isNotNull);
    });
  });
}
