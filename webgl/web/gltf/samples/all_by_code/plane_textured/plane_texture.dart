import 'package:webgl/src/gtlf/mesh.dart';
import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/scene.dart';

GLTFProject planeTexture() {
  GLTFProject project = new GLTFProject();

  GLTFScene scene = new GLTFScene();
  project.addScene(scene);
  project.scene = scene;

  GLTFMesh mesh = GLTFMesh.quad(withIndices:true, withNormals: false, withUVs: true);
  GLTFNode node = new GLTFNode()
    ..mesh = mesh
    ..name = 'quad';
  scene.addNode(node);

  project.meshes.add(mesh);
  project.addNode(node);

  if(mesh.primitives[0].indices != null) {
    project.accessors.add(mesh.primitives[0].indices);
    project.bufferViews.add(mesh.primitives[0].indices.bufferView);
  }

  project.accessors.add(mesh.primitives[0].attributes['POSITION']);
  project.bufferViews.add(mesh.primitives[0].attributes['POSITION'].bufferView);

  if(mesh.primitives[0].attributes['NORMAL'] != null) {
    project.accessors.add(mesh.primitives[0].attributes['NORMAL']);
  }

  if(mesh.primitives[0].attributes['TEXCOORD_0'] != null) {
    project.accessors.add(mesh.primitives[0].attributes['TEXCOORD_0']);
  }

  project.buffers.add(mesh.primitives[0].attributes['POSITION'].bufferView.buffer);

  return project;
}


