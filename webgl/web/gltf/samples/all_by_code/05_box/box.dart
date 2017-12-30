import 'dart:typed_data';

import 'package:webgl/src/gtlf/image.dart';
import 'package:webgl/src/gtlf/material.dart';
import 'package:webgl/src/gtlf/mesh.dart';
import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/pbr_metallic_roughness.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/sampler.dart';
import 'package:webgl/src/gtlf/scene.dart';
import 'package:webgl/src/gtlf/texture.dart';
import 'package:webgl/src/gtlf/texture_info.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

GLTFProject box() {
  GLTFProject project = new GLTFProject()..baseDirectory = '05_box/';

  GLTFScene scene = new GLTFScene();
  project.addScene(scene);
  project.scene = scene;

  GLTFMesh mesh = GLTFMesh.cube(withIndices:true, withNormals: false, withUVs: true);
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
  project.materials.add(material);

  mesh.primitives[0].baseMaterial = material;

  //

  project.meshes.add(mesh);
  project.addNode(node);

  if(mesh.primitives[0].indices != null) {
    project.accessors.add(mesh.primitives[0].indices);
    project.bufferViews.add(mesh.primitives[0].indices.bufferView);
  }

  project.accessors.add(mesh.primitives[0].attributes['POSITION']);
  project.bufferViews.add(mesh.primitives[0].attributes['POSITION'].bufferView);

  if(mesh.primitives[0].attributes['NORMAL'] != null) {
    project.accessors.add(mesh.primitives[0].attributes['NORMAL']);
  }

  if(mesh.primitives[0].attributes['TEXCOORD_0'] != null) {
    project.accessors.add(mesh.primitives[0].attributes['TEXCOORD_0']);
  }

  project.buffers.add(mesh.primitives[0].attributes['POSITION'].bufferView.buffer);

  return project;
}


