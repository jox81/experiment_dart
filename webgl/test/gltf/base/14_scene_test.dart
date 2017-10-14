import 'package:webgl/src/utils/utils_gltf.dart';
import "package:test/test.dart";
import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

void main() {
  group('Scene', () {
    test("Empty array", () async {
      glTF.Gltf gltfSource = await GLTFProject.loadGLTFResource('gltf/tests/base/data/scene/empty.gltf', useWebPath:true);
      GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);

      List<GLTFScene> scenes = gltf.scenes;
      expect(scenes.length, 0);
    });

    test("Array length", () async {
      glTF.Gltf gltfSource = await GLTFProject.loadGLTFResource('gltf/tests/base/data/scene/valid_full.gltf', useWebPath:true);
      GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);

      List<GLTFScene> scenes = gltf.scenes;
      expect(scenes.length, 1);
    });

    test("Property", () async {
      glTF.Gltf gltfSource = await GLTFProject.loadGLTFResource('gltf/tests/base/data/scene/valid_full.gltf', useWebPath:true);
      GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);

      GLTFScene scene = gltf.scenes[0];

      expect(scene, isNotNull);
      expect(scene.nodes, isNotNull);
    });

  });
}