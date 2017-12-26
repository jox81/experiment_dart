import 'dart:async';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gtlf/mesh.dart';
import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/renderer/renderer.dart';
import 'package:webgl/src/gtlf/scene.dart';

Future main() async {
  GLTFProject gltf = new GLTFProject();

  GLTFScene scene = new GLTFScene();
  gltf.addScene(scene);
  gltf.scene = scene;

  Float32List vertexPositions = new Float32List.fromList([
    0.0, 0.0, 0.0, //
    1.0, 0.0, 0.0, //
    0.0, 1.0, 0.0
  ]);

  Int16List vertexIndices = new Int16List.fromList([
    0,1,2
  ]);

  Float32List vertexNormals = new Float32List.fromList([
    0.0, 0.0, 1.0, //
    0.0, 0.0, 1.0, //
    0.0, 0.0, 1.0
  ]);

  GLTFMesh mesh = GLTFMesh.createMesh(vertexPositions, vertexIndices, vertexNormals);

  //> double object using same mesh data
  GLTFNode node01 = new GLTFNode()
  ..mesh = mesh;
  scene.addNode(node01);

  GLTFNode node02 = new GLTFNode()
  ..mesh = mesh
  ..translation = new Vector3(1.0,0.0,0.0);
  scene.addNode(node02);

  await new GLTFRenderer(gltf).render();
}




