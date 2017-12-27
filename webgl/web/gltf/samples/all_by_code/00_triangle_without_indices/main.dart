import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'package:webgl/src/gtlf/mesh.dart';
import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/renderer/renderer.dart';
import 'package:webgl/src/gtlf/scene.dart';

Future main() async {
  ///First, a Project must be defined
  GLTFProject gltf = new GLTFProject();

  /// The Project must have a scene
  GLTFScene scene = new GLTFScene();
  gltf.addScene(scene);
  gltf.scene = scene;

  /// The Scene must have a node to draw something
  GLTFNode node = new GLTFNode();
  scene.addNode(node);

  Float32List vertexPositions = new Float32List.fromList([
    0.0, 0.0, 0.0, //
    1.0, 0.0, 0.0, //
    0.0, 1.0, 0.0  //
  ]);

  /// The node must have a Mesh defined
  node.mesh = GLTFMesh.createMesh(vertexPositions, null);

  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;
  await new GLTFRenderer(canvas, gltf).render();
}
