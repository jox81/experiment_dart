import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/utils/utils_gltf.dart';
import 'dart:async';
import "package:test/test.dart";
import 'package:gltf/gltf.dart' as glTF;

@TestOn("dartium")

Future main() async {

  group("Sampler", () {
    test("Empty array", () async {
      glTF.Gltf gltfSource = await GLTFProject.loadGLTFResource('gltf/tests/base/data/sampler/empty.gltf', useWebPath:true);
      GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);

      List<GLTFSampler> samplers = gltf.samplers;
      expect(samplers.length, 0);
    });
    test("Array length", () async {
      glTF.Gltf gltfSource = await GLTFProject.loadGLTFResource('gltf/tests/base/data/sampler/valid_full.gltf', useWebPath:true);
      GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);

      List<GLTFSampler> samplers = gltf.samplers;
      expect(samplers.length, 1);
    });
    test("properties", () async {
      glTF.Gltf gltfSource = await GLTFProject.loadGLTFResource('gltf/tests/base/data/sampler/valid_full.gltf', useWebPath:true);
      GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);

      List<GLTFSampler> samplers = gltf.samplers;
      expect(samplers.length, 1);

      GLTFSampler sampler = gltf.samplers[0];
      expect(sampler.magFilter, TextureFilterType.NEAREST);
      expect(sampler.minFilter, TextureFilterType.LINEAR_MIPMAP_LINEAR);
      expect(sampler.wrapS, TextureWrapType.CLAMP_TO_EDGE);
      expect(sampler.wrapT, TextureWrapType.MIRRORED_REPEAT);
    });
  });
}
