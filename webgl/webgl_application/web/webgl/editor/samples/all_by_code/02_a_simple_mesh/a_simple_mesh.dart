import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/scene.dart';
import 'package:webgl/src/gltf/mesh/mesh_primitive_infos.dart';

GLTFProject aSimpleMesh() {
  GLTFProject project = new GLTFProject.create();

  GLTFScene scene = new GLTFScene();
  project.scene = scene;

  GLTFMesh mesh = new GLTFMesh.triangle(meshPrimitiveInfos : new MeshPrimitiveInfos(useNormals: false, useUVs: false));

  //> double object using same mesh data
  GLTFNode node = new GLTFNode()
  ..mesh = mesh;
  scene.addNode(node);

  GLTFNode node02 = new GLTFNode()
  ..mesh = mesh
  ..translation = new Vector3(1.0,0.0,0.0);
  scene.addNode(node02);

  return project;
}




