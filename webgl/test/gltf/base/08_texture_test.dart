import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/utils/utils_gltf.dart';
import 'dart:async';
import "package:test/test.dart";
import 'package:gltf/gltf.dart' as glTF;

@TestOn("dartium")

Future main() async {

  group("Texture", () {
    test("Empty array", () async {
      glTF.Gltf gltfSource = await GLTFObject.loadGLTFResource('gltf/tests/base/data/texture/empty.gltf', useWebPath:true);
      GLTFObject gltf = new GLTFObject.fromGltf(gltfSource);

      List<GLTFTexture> textures = gltf.textures;
      expect(textures.length, 0);
    });
    test("Array length", () async {
      glTF.Gltf gltfSource = await GLTFObject.loadGLTFResource('gltf/tests/base/data/texture/valid_full.gltf', useWebPath:true);
      GLTFObject gltf = new GLTFObject.fromGltf(gltfSource);

      List<GLTFTexture> textures = gltf.textures;
      expect(textures.length, 1);
    });
    test("properties", () async {
      glTF.Gltf gltfSource = await GLTFObject.loadGLTFResource('gltf/tests/base/data/texture/valid_full.gltf', useWebPath:true);
      GLTFObject gltf = new GLTFObject.fromGltf(gltfSource);

      List<GLTFTexture> textures = gltf.textures;
      expect(textures.length, 1);

      GLTFTexture sampler = gltf.textures[0];
      expect(sampler.sampler, isNotNull);
      expect(sampler.source, isNotNull);
    });
  });
}
