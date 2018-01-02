import 'package:webgl/src/gltf/mesh.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project.dart';
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
  GLTFMesh mesh = new GLTFMesh.triangle(withIndices: false, withNormals: false);
  node.mesh = node.mesh = mesh;

  return project;
}
