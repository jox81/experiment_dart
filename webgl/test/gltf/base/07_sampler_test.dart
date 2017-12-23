import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/sampler.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'dart:async';
import "package:test/test.dart";
import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/gltf_creation.dart';
import 'package:webgl/src/gtlf/debug_gltf.dart';
@TestOn("dartium")

Future main() async {

  group("Sampler", () async {
    test("Empty array", () async {
      String gltfPath = 'gltf/tests/base/data/sampler/empty.gltf';
      GLTFProject gltf = await debugGltf(gltfPath, doGlTFProjectLog : false, isDebug:false, useWebPath: true);

      List<GLTFSampler> samplers = gltf.samplers;
      expect(samplers.length, 0);
    });
    test("Array length", () async {
      String gltfPath = 'gltf/tests/base/data/sampler/valid_full.gltf';
      GLTFProject gltf = await debugGltf(gltfPath, doGlTFProjectLog : false, isDebug:false, useWebPath: true);

      List<GLTFSampler> samplers = gltf.samplers;
      expect(samplers.length, 1);
    });
    test("properties", () async {
      String gltfPath = 'gltf/tests/base/data/sampler/valid_full.gltf';
      GLTFProject gltf = await debugGltf(gltfPath, doGlTFProjectLog : false, isDebug:false, useWebPath: true);

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
