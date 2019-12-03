import 'package:webgl/src/gltf/pbr_material.dart';
import 'package:webgl/src/gltf/texture_info/normal_texture_info.dart';
import 'package:webgl/src/gltf/texture_info/occlusion_texture_info.dart';
import 'package:webgl/src/gltf/pbr_metallic_roughness.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'dart:async';
import "package:test/test.dart";
import 'package:webgl/src/gltf/texture_info/texture_info.dart';

import '../../data/gltf_helper.dart';
@TestOn("browser")

String testFolderRelativePath = "../..";

Future main() async {
  group("Material", () {
    test("Empty array", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/material/empty.gltf';;
      GLTFProject gltf = await loadGLTFProject(gltfPath);
      gltf.debug(doProjectLog : false, isDebug:false);

      List<GLTFPBRMaterial> materials = gltf.materials;
      expect(materials.length, 0);
    });
    test("Array length", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/material/valid_full.gltf';
      GLTFProject gltf = await loadGLTFProject(gltfPath);
      gltf.debug(doProjectLog : false, isDebug:false);

      List<GLTFPBRMaterial> materials = gltf.materials;
      expect(materials.length, 1);
    });
    test("base properties", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/material/valid_full.gltf';
      GLTFProject gltf = await loadGLTFProject(gltfPath);
      gltf.debug(doProjectLog : false, isDebug:false);

      GLTFPBRMaterial material = gltf.materials[0];
      expect(material.emissiveFactor, <double>[0.0, 1.0, 0.0]);
      expect(material.alphaMode, "MASK");
      expect(material.alphaCutoff, 0.4);
      expect(material.doubleSided, true);
    });
    test("properties pbrMetallicRoughness", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/material/valid_full.gltf';
      GLTFProject gltf = await loadGLTFProject(gltfPath);
      gltf.debug(doProjectLog : false, isDebug:false);

      GLTFPBRMaterial material = gltf.materials[0];

      expect(material.pbrMetallicRoughness, isNotNull);
      GLTFPbrMetallicRoughness metallicRoughness = material.pbrMetallicRoughness;
      expect(metallicRoughness.baseColorFactor, <double>[
        1.0,
        0.0,
        1.0,
        1.0
      ]);
      expect(metallicRoughness.baseColorTexture.texCoord, 0);
      expect(metallicRoughness.metallicFactor, 0.5);
      expect(metallicRoughness.roughnessFactor, 0.5);
      expect(metallicRoughness.metallicRoughnessTexture.texCoord, 1);

    });
    test("properties normalTexture", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/material/valid_full.gltf';
      GLTFProject gltf = await loadGLTFProject(gltfPath);
      gltf.debug(doProjectLog : false, isDebug:false);

      GLTFPBRMaterial material = gltf.materials[0];

      expect(material.normalTexture, isNotNull);
      GLTFNormalTextureInfo normalTexture = material.normalTexture;
      expect(normalTexture.texCoord, 2);
      expect(normalTexture.scale, 2.1);
    });
    test("properties occlusionTexture", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/material/valid_full.gltf';
      GLTFProject gltf = await loadGLTFProject(gltfPath);
      gltf.debug(doProjectLog : false, isDebug:false);

      GLTFPBRMaterial material = gltf.materials[0];

      expect(material.occlusionTexture, isNotNull);
      GLTFOcclusionTextureInfo occlusionTexture = material.occlusionTexture;
      expect(occlusionTexture.texCoord, 3);
      expect(occlusionTexture.strength, 0.5);
    });
    test("properties emissiveTexture", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/material/valid_full.gltf';
      GLTFProject gltf = await loadGLTFProject(gltfPath);
      gltf.debug(doProjectLog : false, isDebug:false);

      GLTFPBRMaterial material = gltf.materials[0];

      expect(material.emissiveTexture, isNotNull);
      GLTFTextureInfo emissiveTexture = material.emissiveTexture;
      expect(emissiveTexture.texCoord, 4);
    });
  });
}
