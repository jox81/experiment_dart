import 'package:webgl/src/gltf/mesh.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/scene.dart';

GLTFProject triangleWithIndices() {
  ///First, a Project must be defined
  GLTFProject project = new GLTFProject.create();

  /// The Project must have a scene
  GLTFScene scene = new GLTFScene();
  project.scene = scene;

  /// The Scene must have a node to draw something
  GLTFNode node = new GLTFNode();
  scene.addNode(node);

  GLTFMesh mesh = new GLTFMesh.triangle(withIndices: true, withNormals: false, withUVs: false);
  node.mesh = mesh;

  return project;
}

