import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'dart:async';
import 'package:webgl/src/gltf/scene.dart';

GLTFProject gltf;

Future main() async {
  buildSimpleProject();
  print(gltf);
}

void buildSimpleProject() {
  gltf = new GLTFProject.create();

  GLTFNode node = new GLTFNode()
    ..name = 'singleNode';

  GLTFScene scene = new GLTFScene()
    ..name = 'singleScene';
  scene.addNode(node);

  gltf.scene = scene;

//  List<GLTFNode> nodes = scene.nodes;
}
