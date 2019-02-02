import 'dart:html';

import 'package:webgl/engine.dart';
import 'package:webgl/src/gltf/node.dart';
import 'dart:async';

import 'package:webgl/src/gltf/project/project.dart';

Future main() async {

  GLTFProject project = new GLTFProject.create();

  GLTFNode node01 = new GLTFNode();

  GLTFNode node02 = new GLTFNode();

  node01.children.add(node02);

  GLTFNode node03 = new GLTFNode();

  node01.children.add(node03);

  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;

  GLTFEngine engine = new GLTFEngine(canvas);
  await engine.render(project);
}
