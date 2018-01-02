import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/material.dart';
import 'package:webgl/src/gltf/mesh.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/pbr_metallic_roughness.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/scene.dart';

GLTFProject bMultiMesh() {
  GLTFProject project = new GLTFProject.create();

  GLTFScene scene = new GLTFScene();
  project.addScene(scene);
  project.scene = scene;

  GLTFMesh mesh = new GLTFMesh.triangle();
  GLTFPBRMaterial material = new GLTFPBRMaterial(pbrMetallicRoughness: new GLTFPbrMetallicRoughness(baseColorFactor: new Vector4(0.8,0.0,0.0,1.0).storage, metallicFactor: 0.0, roughnessFactor: 0.0));
  mesh.primitives[0].baseMaterial = material;

  //> double object using same mesh data
  GLTFNode node01 = new GLTFNode()
  ..mesh = mesh;
  scene.addNode(node01);

  for (var i = 0; i < 1000; ++i) {
    GLTFNode node = new GLTFNode()
      ..mesh = mesh
      ..translation = (new Vector3.random() - new Vector3(0.5, 0.5, 0.5))* 10.0;
    scene.addNode(node);
  }

  return project;
}


