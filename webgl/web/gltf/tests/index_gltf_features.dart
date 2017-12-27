import 'dart:html';

import 'package:webgl/src/gtlf/node.dart';
import 'dart:async';

import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/renderer/renderer.dart';

Future main() async {

  GLTFProject gltf = new GLTFProject();

  GLTFNode node01 = new GLTFNode();
  gltf.addNode(node01);

  GLTFNode node02 = new GLTFNode();
  gltf.addNode(node02);

  node01.children.add(node02);

  GLTFNode node03 = new GLTFNode();
  gltf.addNode(node03);

  node01.children.add(node03);

  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;
  await new GLTFRenderer(canvas, gltf).render();
}
