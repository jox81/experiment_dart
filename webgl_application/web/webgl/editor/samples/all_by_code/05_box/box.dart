import 'dart:typed_data';

import 'package:webgl/src/gltf/material.dart';
import 'package:webgl/src/gltf/mesh.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/pbr_metallic_roughness.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/scene.dart';
import 'package:webgl/src/gltf/texture_info.dart';

GLTFProject box() {
  GLTFProject project = new GLTFProject.create()..baseDirectory = '05_box/';

  GLTFScene scene = new GLTFScene();
  project.scene = scene;

  GLTFMesh mesh = new GLTFMesh.cube(meshPrimitiveInfos : new MeshPrimitiveInfos(useNormals: false));
  GLTFNode node = new GLTFNode()
    ..mesh = mesh
    ..name = 'cube';
  scene.addNode(node);

  // Materiel

  GLTFPBRMaterial material = new GLTFPBRMaterial(
      pbrMetallicRoughness: new GLTFPbrMetallicRoughness(
          baseColorFactor: new Float32List.fromList([1.0,1.0,1.0,1.0]),
          baseColorTexture: GLTFTextureInfo.createTexture(project, 'testTexture.png'),
          metallicFactor: 0.0,
          roughnessFactor: 1.0
      )
  );

  mesh.primitives[0].baseMaterial = material;

  return project;
}


