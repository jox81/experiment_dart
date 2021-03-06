import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/gltf/sampler.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'dart:async';
import "package:test/test.dart";
import '../../data/gltf_helper.dart';

@TestOn("browser")

String testFolderRelativePath = "../..";

Future main() async {

  group("Sampler", () {
    test("Empty array", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/sampler/empty.gltf';
      GLTFProject gltf = await loadGLTFProject(gltfPath);
      gltf.debug(doProjectLog : false, isDebug:false);

      List<GLTFSampler> samplers = gltf.samplers;
      expect(samplers.length, 0);
    });
    test("Array length", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/sampler/valid_full.gltf';
      GLTFProject gltf = await loadGLTFProject(gltfPath);
      gltf.debug(doProjectLog : false, isDebug:false);

      List<GLTFSampler> samplers = gltf.samplers;
      expect(samplers.length, 1);
    });
    test("properties", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/sampler/valid_full.gltf';
      GLTFProject gltf = await loadGLTFProject(gltfPath);
      gltf.debug(doProjectLog : false, isDebug:false);

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
