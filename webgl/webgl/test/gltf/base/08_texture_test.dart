import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/gltf/texture.dart';
import 'dart:async';
import "package:test/test.dart";

import '../../data/gltf_helper.dart';
@TestOn("browser")

String testFolderRelativePath = "../..";

Future main() async {

  group("Texture", () {
    test("Empty array", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/texture/empty.gltf';
      GLTFProject gltf = await loadGLTFProject(gltfPath);
      gltf.debug(doProjectLog : false, isDebug:false);

      List<GLTFTexture> textures = gltf.textures;
      expect(textures.length, 0);
    });
    test("Array length", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/texture/valid_full.gltf';
      GLTFProject gltf = await loadGLTFProject(gltfPath);
      gltf.debug(doProjectLog : false, isDebug:false);

      List<GLTFTexture> textures = gltf.textures;
      expect(textures.length, 1);
    });
    test("properties", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/texture/valid_full.gltf';
      GLTFProject gltf = await loadGLTFProject(gltfPath);
      gltf.debug(doProjectLog : false, isDebug:false);

      List<GLTFTexture> textures = gltf.textures;
      expect(textures.length, 1);

      GLTFTexture sampler = gltf.textures[0];
      expect(sampler.sampler, isNotNull);
      expect(sampler.source, isNotNull);
    });
  });
}
