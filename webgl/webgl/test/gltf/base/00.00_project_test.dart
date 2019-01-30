import 'dart:async';
import "package:test/test.dart";
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/gltf/scene.dart';

@TestOn("browser")

String testFolderRelativePath = "../..";

Future main() async {
  group("Project", () {
    test("Project creation", () async {
      GLTFProject gltf = new GLTFProject.create();
      expect(gltf, isNotNull);
    });
    test("Project content scenes", () async {
      GLTFProject gltf = new GLTFProject.create();
      expect(gltf.scenes.length, 0);
    });
    test("Project content active scene", () async {
      GLTFProject gltf = new GLTFProject.create();
      expect(gltf.scene, isNull);
    });
    test("Build Project", () async {
      GLTFProject gltf = new GLTFProject.create();

      GLTFNode node = new GLTFNode()
        ..name = 'singleNode';

      GLTFScene scene = new GLTFScene()
        ..name = 'singleScene';
      scene.addNode(node);

      gltf.scene = scene;

      print(gltf);

      //>>

      print(gltf.nodes[0].name);

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
}
