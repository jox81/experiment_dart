import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gtlf/debug_gltf.dart';
import 'package:webgl/src/gtlf/mesh.dart';
import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/renderer/renderer.dart';
import 'package:webgl/src/gtlf/scene.dart';

GLTFProject aSimpleMesh() {
  GLTFProject project = new GLTFProject();

  GLTFScene scene = new GLTFScene();
  project.addScene(scene);
  project.scene = scene;

  GLTFMesh mesh = GLTFMesh.triangle(withIndices : true, withNormals: true);

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




