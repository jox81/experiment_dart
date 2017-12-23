import 'dart:async';

import 'package:webgl/src/gtlf/mesh.dart';
import 'package:webgl/src/gtlf/mesh_primitive.dart';
import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/renderer/renderer.dart';
import 'package:webgl/src/gtlf/scene.dart';

Future main() async {
  GLTFProject gltf = new GLTFProject();

  /// Project must have a scene
  GLTFScene scene = new GLTFScene();
  gltf.addScene(scene);
  gltf.scene = scene;

  /// To draw something, scene must have nodes
  GLTFNode node = new GLTFNode();
  scene.addNode(node);

  /// The node must have a Mesh
  GLTFMesh mesh = new GLTFMesh();
  node.mesh = mesh;

  /// The mesh must have primitive
  GLTFMeshPrimitive primitive = new GLTFMeshPrimitive();
  mesh.primitives.add(primitive);

  await new GLTFRenderer(gltf).render();
}
