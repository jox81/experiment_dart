import 'dart:typed_data';

import 'package:webgl/src/gltf/material.dart';
import 'package:webgl/src/gltf/mesh.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/pbr_metallic_roughness.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/scene.dart';
import 'package:webgl/src/gltf/texture_info.dart';

GLTFProject planeTexture() {
  GLTFProject project = new GLTFProject.create()..baseDirectory = 'plane_textured/';
  print(project.baseDirectory);

  GLTFScene scene = new GLTFScene();
  project.scene = scene;

  GLTFPBRMaterial material = new GLTFPBRMaterial(
      pbrMetallicRoughness: new GLTFPbrMetallicRoughness(
          baseColorFactor: new Float32List.fromList([1.0,1.0,1.0,1.0]),
          baseColorTexture: GLTFTextureInfo.createTexture(project, 'testTexture.png'),
          metallicFactor: 0.0,
          roughnessFactor: 1.0
      )
  );

  GLTFMesh mesh = new GLTFMesh.quad(withIndices:true, withNormals: false, withUVs: true)
    ..primitives[0].baseMaterial = material;
  GLTFNode node = new GLTFNode()
    ..mesh = mesh
    ..name = 'quad';
  scene.addNode(node);

  return project;
}




