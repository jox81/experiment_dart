import 'dart:html';

import 'package:webgl/src/gltf/node.dart';
import 'dart:async';

import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/renderer/renderer.dart';

Future main() async {

  GLTFProject gltf = new GLTFProject.create();

  GLTFNode node01 = new GLTFNode();
  gltf.addNode(node01);

  GLTFNode node02 = new GLTFNode();
  gltf.addNode(node02);

  node01.children.add(node02);

  GLTFNode node03 = new GLTFNode();
  gltf.addNode(node03);

  node01.children.add(node03);

  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;
  await new GLTFRenderer(canvas).render(gltf);
}
