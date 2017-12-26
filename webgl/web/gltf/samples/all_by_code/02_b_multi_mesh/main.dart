import 'dart:async';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gtlf/material.dart';
import 'package:webgl/src/gtlf/mesh.dart';
import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/pbr_metallic_roughness.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/renderer/renderer.dart';
import 'package:webgl/src/gtlf/scene.dart';

Future main() async {
  GLTFProject gltf = new GLTFProject();

  GLTFScene scene = new GLTFScene();
  gltf.addScene(scene);
  gltf.scene = scene;

  Float32List vertexPositions = new Float32List.fromList([
    0.0, 0.0, 0.0, //
    1.0, 0.0, 0.0, //
    0.0, 1.0, 0.0
  ]);

  Int16List vertexIndices = new Int16List.fromList([
    0,1,2
  ]);

  Float32List vertexNormals = new Float32List.fromList([
    0.0, 0.0, 1.0, //
    0.0, 0.0, 1.0, //
    0.0, 0.0, 1.0
  ]);

  GLTFMesh mesh = GLTFMesh.createMesh(vertexPositions, vertexIndices, vertexNormals);
  GLTFPBRMaterial material = new GLTFPBRMaterial(pbrMetallicRoughness: new GLTFPbrMetallicRoughness(baseColorFactor: new Vector4(0.8,0.0,0.0,1.0).storage, metallicFactor: 0.0, roughnessFactor: 0.0));
  mesh.primitives[0].material = material;

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

  await new GLTFRenderer(gltf).render();
}


