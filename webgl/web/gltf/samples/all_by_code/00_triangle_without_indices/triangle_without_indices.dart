import 'package:webgl/src/gtlf/mesh.dart';
import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/scene.dart';

GLTFProject triangleWithoutIndices() {
  ///First, a Project must be defined
  GLTFProject project = new GLTFProject();

  /// The Project must have a scene
  GLTFScene scene = new GLTFScene();
  project.addScene(scene);
  project.scene = scene;

  /// The Scene must have a node to draw something
  GLTFNode node = new GLTFNode();
  scene.addNode(node);

  /// The node must have a Mesh defined
  GLTFMesh mesh = new GLTFMesh.triangle(withIndices: false, withNormals: false);
  node.mesh = node.mesh = mesh;

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
