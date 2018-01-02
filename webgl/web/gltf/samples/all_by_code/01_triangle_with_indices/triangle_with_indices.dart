import 'package:webgl/src/gltf/mesh.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/scene.dart';

GLTFProject triangleWithIndices() {
  ///First, a Project must be defined
  GLTFProject project = new GLTFProject.create();

  /// The Project must have a scene
  GLTFScene scene = new GLTFScene();
  project.addScene(scene);
  project.scene = scene;

  /// The Scene must have a node to draw something
  GLTFNode node = new GLTFNode();
  scene.addNode(node);

  GLTFMesh mesh = new GLTFMesh.triangle(withIndices: true, withNormals: false, withUVs: false);
  node.mesh = mesh;

  project.meshes.add(mesh);
  project.addNode(node);

  if(mesh.primitives[0].indicesAccessor != null) {
    project.accessors.add(mesh.primitives[0].indicesAccessor);
    project.bufferViews.add(mesh.primitives[0].indicesAccessor.bufferView);
  }
  project.accessors.add(mesh.primitives[0].positionAccessor);
  project.bufferViews.add(mesh.primitives[0].positionAccessor.bufferView);

  if(mesh.primitives[0].uvAccessor != null) {
    project.accessors.add(mesh.primitives[0].uvAccessor);
  }
  project.buffers.add(mesh.primitives[0].positionAccessor.bufferView.buffer);


  return project;
}


