import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/texture.dart';
import 'dart:async';
import "package:test/test.dart";
import 'package:gltf/gltf.dart' as glTF;

@TestOn("dartium")

Future main() async {

  group("Texture", () {
    test("Empty array", () async {
      glTF.Gltf gltfSource = await GLTFProject.loadGLTFResource('gltf/tests/base/data/texture/empty.gltf', useWebPath:true);
      GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);

      List<GLTFTexture> textures = gltf.textures;
      expect(textures.length, 0);
    });
    test("Array length", () async {
      glTF.Gltf gltfSource = await GLTFProject.loadGLTFResource('gltf/tests/base/data/texture/valid_full.gltf', useWebPath:true);
      GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);

      List<GLTFTexture> textures = gltf.textures;
      expect(textures.length, 1);
    });
    test("properties", () async {
      glTF.Gltf gltfSource = await GLTFProject.loadGLTFResource('gltf/tests/base/data/texture/valid_full.gltf', useWebPath:true);
      GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);

      List<GLTFTexture> textures = gltf.textures;
      expect(textures.length, 1);

      GLTFTexture sampler = gltf.textures[0];
      expect(sampler.sampler, isNotNull);
      expect(sampler.source, isNotNull);
    });
  });
}