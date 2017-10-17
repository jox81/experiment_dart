import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'dart:async';
import 'package:webgl/src/gtlf/scene.dart';

GLTFProject gltf;

Future main() async {
  buildSimpleProject();
  print(gltf);
}

void buildSimpleProject() {
  gltf = new GLTFProject();

  GLTFNode node = new GLTFNode()
    ..name = 'singleNode';
  gltf.addNode(node);

  GLTFScene scene = new GLTFScene()
    ..name = 'singleScene';
  scene.addNode(node);

  gltf.addScene(scene);
  gltf.scene = scene;

//  List<GLTFNode> nodes = scene.nodes;
}
