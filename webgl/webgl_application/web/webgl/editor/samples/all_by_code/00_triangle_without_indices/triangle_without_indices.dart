import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/mesh/mesh_primitive_infos.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/gltf/scene.dart';

GLTFProject triangleWithoutIndices() {
  ///First, a Project must be defined
  GLTFProject project = new GLTFProject.create();

  /// The Project must have a scene
  GLTFScene scene = new GLTFScene();
  project.scene = scene;

  /// The Scene must have a node to draw something
  GLTFNode node = new GLTFNode();
  scene.addNode(node);

  /// The node must have a Mesh defined
  GLTFMesh mesh = new GLTFMesh.triangle(meshPrimitiveInfos : new MeshPrimitiveInfos(useIndices : false, useNormals: false));
  node.mesh = node.mesh = mesh;

  return project;
}
