import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'package:webgl/src/gtlf/debug_gltf.dart';
import 'package:webgl/src/gtlf/mesh.dart';
import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/renderer/renderer.dart';
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
  GLTFMesh mesh = GLTFMesh.triangle(withIndices: false, withNormals: false);
  node.mesh = node.mesh = mesh;

  project.meshes.add(mesh);
  project.addNode(node);

  if(mesh.primitives[0].indices != null) {
    project.accessors.add(mesh.primitives[0].indices);
    project.bufferViews.add(mesh.primitives[0].indices.bufferView);
  }
  project.accessors.add(mesh.primitives[0].attributes['POSITION']);
  project.bufferViews.add(mesh.primitives[0].attributes['POSITION'].bufferView);

  if(mesh.primitives[0].attributes['TEXCOORD_0'] != null) {
    project.accessors.add(mesh.primitives[0].attributes['TEXCOORD_0']);
  }
  project.buffers.add(mesh.primitives[0].attributes['POSITION'].bufferView.buffer);

  return project;
}
