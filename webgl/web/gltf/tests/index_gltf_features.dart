import 'package:webgl/src/gtlf/debug_gltf.dart';
import 'package:webgl/src/gtlf/node.dart';
import 'dart:async';

import 'package:webgl/src/gtlf/project.dart';

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

  assert(gltf.nodes.length == 3);
  assert(gltf.nodes[0].children.length == 2);
  assert(gltf.nodes[0].children[0] == node02);
  assert(gltf.nodes[0].children[1] == node03);
  assert(node01.parent == null);
  assert(node02.parent != null);
  assert(node02.parent == node01);
  assert(node03.parent != null);
  assert(node03.parent == node01);
}
