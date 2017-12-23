import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/texture.dart';
import 'dart:async';
import "package:test/test.dart";
import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/gltf_creation.dart';
import 'package:webgl/src/gtlf/debug_gltf.dart';
@TestOn("dartium")

Future main() async {

  group("Texture", () {
    test("Empty array", () async {
      String gltfPath = 'gltf/tests/base/data/texture/empty.gltf';
      GLTFProject gltf = await debugGltf(gltfPath, doGlTFProjectLog : false, isDebug:false, useWebPath: true);

      List<GLTFTexture> textures = gltf.textures;
      expect(textures.length, 0);
    });
    test("Array length", () async {
      String gltfPath = 'gltf/tests/base/data/texture/valid_full.gltf';
      GLTFProject gltf = await debugGltf(gltfPath, doGlTFProjectLog : false, isDebug:false, useWebPath: true);

      List<GLTFTexture> textures = gltf.textures;
      expect(textures.length, 1);
    });
    test("properties", () async {
      String gltfPath = 'gltf/tests/base/data/texture/valid_full.gltf';
      GLTFProject gltf = await debugGltf(gltfPath, doGlTFProjectLog : false, isDebug:false, useWebPath: true);

      List<GLTFTexture> textures = gltf.textures;
      expect(textures.length, 1);

      GLTFTexture sampler = gltf.textures[0];
      expect(sampler.sampler, isNotNull);
      expect(sampler.source, isNotNull);
    });
  });
}
