import 'package:webgl/src/gtlf/debug_gltf.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/scene.dart';
import "package:test/test.dart";
void main() {
  group('Scene', () {
    test("Empty array", () async {
      String gltfPath = 'gltf/tests/base/data/scene/empty.gltf';
      GLTFProject gltf = await loadGLTF(gltfPath, useWebPath : true);
      await debugGltf(gltf, doGlTFProjectLog : false, isDebug:false);

      expect(gltf, isNotNull);

      List<GLTFScene> scenes = gltf.scenes;
      expect(scenes.length, 0);
    });

    test("Array length", () async {
      String gltfPath = 'gltf/tests/base/data/scene/valid_full.gltf';
      GLTFProject gltf = await loadGLTF(gltfPath, useWebPath : true);
      await debugGltf(gltf, doGlTFProjectLog : false, isDebug:false);

      expect(gltf, isNotNull);

      List<GLTFScene> scenes = gltf.scenes;
      expect(scenes.length, 1);
    });

    test("Property", () async {
      String gltfPath = 'gltf/tests/base/data/scene/valid_full.gltf';
      GLTFProject gltf = await loadGLTF(gltfPath, useWebPath : true);
      await debugGltf(gltf, doGlTFProjectLog : false, isDebug:false);

      GLTFScene scene = gltf.scenes[0];

      expect(scene, isNotNull);
      expect(scene.nodes, isNotNull);
    });
  });
}