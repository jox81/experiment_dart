import 'dart:async';
import "package:test/test.dart";

import 'package:webgl/src/utils/utils_gltf.dart';

@TestOn("dartium")

Future main() async {
  group("Project", () {
    test("Project creation", () async {
      GLTFProject gltf = new GLTFProject();
      expect(gltf, isNotNull);
    });
    test("Project content scenes", () async {
      GLTFProject gltf = new GLTFProject();
      expect(gltf.scenes.length, 0);
    });
    test("Project content active scene", () async {
      GLTFProject gltf = new GLTFProject();
      expect(gltf.scene, isNull);
    });
    test("Build Project", () async {
      GLTFProject gltf = new GLTFProject();

      GLTFNode node = new GLTFNode()
        ..name = 'singleNode';
      gltf.addNode(node);

      GLTFScene scene = new GLTFScene()
        ..name = 'singleScene';
      scene.addNode(node);

      gltf.addScene(scene);
      gltf.scene = scene;

//      print(gltf);

      //>>
      expect(gltf.nodes.length, 1);
      expect(gltf.nodes[0].name, "singleNode");

      expect(gltf.scenes.length, 1);
      expect(gltf.scenes[0].name, "singleScene");
      expect(gltf.scenes[0].nodes.length, 1);
      expect(gltf.scenes[0].nodes[0], gltf.nodes[0]);
      expect(gltf.scenes[0].nodes[0], gltf.nodes[gltf.scenes[0].nodes[0].nodeId]);

      expect(gltf.scene, gltf.scenes[0]);
    });
  });

  group('Node hierarchy', () {
    test("Node parenting", () async {
      GLTFProject gltf = new GLTFProject();

      GLTFNode node01 = new GLTFNode();
      gltf.addNode(node01);

      GLTFNode node02 = new GLTFNode();
      gltf.addNode(node02);

      node02.parent = node01;

      GLTFNode node03 = new GLTFNode();
      gltf.addNode(node03);

      node03.parent = node01;

      //> Should be done in the project
      expect(gltf.nodes.length, 3);
      expect(gltf.nodes[0].children.length, 2);
      expect(gltf.nodes[0].children[0], node02);
      expect(gltf.nodes[0].children[1], node03);
      expect(node01.parent, isNull);
      expect(node02.parent, node01);
      expect(node03.parent, node01);

    });
  });
}
