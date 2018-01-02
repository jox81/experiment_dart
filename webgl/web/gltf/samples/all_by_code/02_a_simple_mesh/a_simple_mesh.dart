import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/mesh.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/scene.dart';

GLTFProject aSimpleMesh() {
  GLTFProject project = new GLTFProject.create();

  GLTFScene scene = new GLTFScene();
  project.addScene(scene);
  project.scene = scene;

  GLTFMesh mesh = new GLTFMesh.triangle(withIndices : true, withNormals: true);

  //> double object using same mesh data
  GLTFNode node = new GLTFNode()
  ..mesh = mesh;
  scene.addNode(node);

  GLTFNode node02 = new GLTFNode()
  ..mesh = mesh
  ..translation = new Vector3(1.0,0.0,0.0);
  scene.addNode(node02);

  project.meshes.add(mesh);
  project.addNode(node);
  project.addNode(node02);

  if(mesh.primitives[0].indicesAccessor != null) {
    project.accessors.add(mesh.primitives[0].indicesAccessor);
    project.bufferViews.add(mesh.primitives[0].indicesAccessor.bufferView);
  }

  project.accessors.add(mesh.primitives[0].positionAccessor);
  project.bufferViews.add(mesh.primitives[0].positionAccessor.bufferView);

  if(mesh.primitives[0].normalAccessor != null) {
    project.accessors.add(mesh.primitives[0].normalAccessor);
  }

  if(mesh.primitives[0].uvAccessor != null) {
    project.accessors.add(mesh.primitives[0].uvAccessor);
  }

  project.buffers.add(mesh.primitives[0].positionAccessor.bufferView.buffer);


  return project;
}




