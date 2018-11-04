//import 'dart:async';
//import 'dart:html';
//import 'package:webgl/src/gltf/debug_gltf.dart';
//import 'package:webgl/src/gltf/project.dart';
//import 'package:webgl/src/gltf/renderer/renderer.dart';
//import 'package:webgl/src/gltf/mesh.dart';
//import 'package:webgl/src/gltf/node.dart';
//import 'package:webgl/src/gltf/scene.dart';
//
//Future main() async {
//  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;
//  GLTFRenderer renderer = await new GLTFRenderer(canvas);
//
//  GLTFProject gltf = await triangleWithIndices();
//  debugGltf(gltf, doGlTFProjectLog : true, isDebug:false);
//
//  renderer.render(gltf);
//}
//
//GLTFProject triangleWithIndices() {
//  ///First, a Project must be defined
//  GLTFProject project = new GLTFProject.create();
//
//  /// The Project must have a scene
//  GLTFScene scene = new GLTFScene();
//  project.scene = scene;
//
//  /// The Scene must have a node to draw something
//  GLTFNode node = new GLTFNode();
//  scene.addNode(node);
//
//  GLTFMesh mesh = new GLTFMesh.triangle(withIndices: true, withNormals: false, withUVs: false);
//  node.mesh = mesh;
//
//  return project;
//}
