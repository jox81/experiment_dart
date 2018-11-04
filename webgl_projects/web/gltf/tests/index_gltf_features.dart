import 'dart:html';

import 'package:webgl/src/gltf/node.dart';
import 'dart:async';

import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/renderer/renderer.dart';

Future main() async {

  GLTFProject gltf = new GLTFProject.create();

  GLTFNode node01 = new GLTFNode();

  GLTFNode node02 = new GLTFNode();

  node01.children.add(node02);

  GLTFNode node03 = new GLTFNode();

  node01.children.add(node03);

  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;
  GLTFRenderer renderer = new GLTFRenderer(canvas);
  await renderer.init(gltf);
  renderer.render();
}
