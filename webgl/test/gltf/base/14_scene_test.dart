import 'package:webgl/src/gtlf/debug_gltf.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/scene.dart';
import "package:test/test.dart";
import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/gltf_creation.dart';
void main() {
  group('Scene', () {
    test("Empty array", () async {
      String gltfPath = 'gltf/tests/base/data/scene/empty.gltf';
      GLTFProject gltf = await debugGltf(gltfPath, doGlTFProjectLog : false, isDebug:false, useWebPath: true);
      expect(gltf, isNotNull);

      List<GLTFScene> scenes = gltf.scenes;
      expect(scenes.length, 0);
    });

    test("Array length", () async {
      String gltfPath = 'gltf/tests/base/data/scene/valid_full.gltf';
      GLTFProject gltf = await debugGltf(gltfPath, doGlTFProjectLog : false, isDebug:false, useWebPath: true);
      expect(gltf, isNotNull);

      List<GLTFScene> scenes = gltf.scenes;
      expect(scenes.length, 1);
    });

    test("Property", () async {
      String gltfPath = 'gltf/tests/base/data/scene/valid_full.gltf';
      GLTFProject gltf = await debugGltf(gltfPath, doGlTFProjectLog : false, isDebug:false, useWebPath: true);

      GLTFScene scene = gltf.scenes[0];

      expect(scene, isNotNull);
      expect(scene.nodes, isNotNull);
    });
  });
}