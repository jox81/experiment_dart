import 'package:webgl/src/gltf/creation.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/gltf/scene.dart';
import "package:test/test.dart";

String testFolderRelativePath = "../..";

void main() {
  group('Scene', () {
    test("Empty array", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/scene/empty.gltf';
      GLTFProject gltf = await GLTFCreation.loadGLTFProject(gltfPath, useWebPath : false);
      await gltf.debug(doProjectLog : false, isDebug:false);

      expect(gltf, isNotNull);

      List<GLTFScene> scenes = gltf.scenes;
      expect(scenes.length, 0);
    });

    test("Array length", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/scene/valid_full.gltf';
      GLTFProject gltf = await GLTFCreation.loadGLTFProject(gltfPath, useWebPath : false);
      await gltf.debug(doProjectLog : false, isDebug:false);

      expect(gltf, isNotNull);

      List<GLTFScene> scenes = gltf.scenes;
      expect(scenes.length, 1);
    });

    test("Property", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/scene/valid_full.gltf';
      GLTFProject gltf = await GLTFCreation.loadGLTFProject(gltfPath, useWebPath : false);
      await gltf.debug(doProjectLog : false, isDebug:false);

      GLTFScene scene = gltf.scenes[0];

      expect(scene, isNotNull);
      expect(scene.nodes, isNotNull);
    });
  });
}