import 'dart:async';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/material.dart';
import 'package:webgl/src/gltf/mesh.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/renderer/materials.dart';
import 'package:webgl/src/gltf/scene.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/camera/camera.dart';

import 'material_library.dart';

Future<GLTFProject> projectPrimitives() async {
  GLTFProject project = new GLTFProject.create()..baseDirectory = 'primitives/';

  GLTFScene scene = new GLTFScene();
  project.addScene(scene);
  project.scene = scene;

  Context.mainCamera = new
  CameraPerspective(radians(37.0), 0.1, 1000.0)
    ..targetPosition = new Vector3.zero()
    ..translation = new Vector3(20.0, 20.0, 20.0);

  //> materials

  MaterialLibrary materialLibrary = new MaterialLibrary();
  await materialLibrary.loadRessources();

  GLTFPBRMaterial baseMaterial = materialLibrary.gLTFPBRMaterial;
  RawMaterial material = materialLibrary.materialReflection;
  MaterialPoint materialPoint = materialLibrary.matrerialPoint;
//  project.materials.add(material); // Todo (jpu) : don't add ?

  //> environnement

  scene.backgroundColor = new Vector4(0.8, 0.2, 1.0, 1.0);// Todo (jpu) : ?

  GLTFMesh skyBoxMesh = new GLTFMesh.cube()
    ..primitives[0].material = materialLibrary.materialSkyBox;/// ! vu ceci, il faut que l'objet qui a ce matériaux soit rendu en premier
  GLTFNode skyBoxNode = new GLTFNode()
    ..mesh = skyBoxMesh
    ..name = 'quadDepth'
    ..matrix.scale(2.0);
  scene.addNode(skyBoxNode);

  //> meshes

  GLTFMesh meshPoint = new GLTFMesh.point()
    ..primitives[0].material = materialPoint;
  project.meshes.add(meshPoint);
  GLTFNode nodePoint = new GLTFNode()
    ..mesh = meshPoint
    ..name = 'point'
    ..translation = new Vector3(5.0, 0.0, 0.0);
  scene.addNode(nodePoint);
  project.addNode(nodePoint);

  // Todo (jpu) :This doesn't show, use another material ? what material doesn't work ?
  GLTFMesh meshLine = new GLTFMesh.line([
    new Vector3.all(0.0),
    new Vector3(10.0, 0.0, 0.0),
    new Vector3(10.0, 0.0, 10.0),
    new Vector3(10.0, 10.0, 10.0),
  ])
    ..primitives[0].material = material;
  project.meshes.add(meshLine);
  GLTFNode nodeLine = new GLTFNode()
    ..mesh = meshLine
    ..name = 'multiline'
    ..translation = new Vector3(-5.0, 0.0, -5.0);
  scene.addNode(nodeLine);
  project.addNode(nodeLine);

  GLTFMesh meshTriangle = new GLTFMesh.triangle()
    ..primitives[0].material = material;
  project.meshes.add(meshTriangle);
  GLTFNode nodeTriangle = new GLTFNode()
    ..mesh = meshTriangle
    ..name = 'triangle'
    ..translation = new Vector3(0.0, 0.0, -5.0);
  scene.addNode(nodeTriangle);
  project.addNode(nodeTriangle);

  GLTFMesh meshQuad = new GLTFMesh.quad()
    ..primitives[0].material = material;
  project.meshes.add(meshQuad);
  GLTFNode nodeQuad = new GLTFNode()
    ..mesh = meshQuad
    ..name = 'quad'
    ..translation = new Vector3(5.0, 0.0, -5.0);
  scene.addNode(nodeQuad);
  project.addNode(nodeQuad);

  GLTFMesh meshPyramid = new GLTFMesh.pyramid()
    ..primitives[0].material = material;
  project.meshes.add(meshPyramid);
  GLTFNode nodePyramid = new GLTFNode()
    ..mesh = meshPyramid
    ..name = 'pyramid'
    ..translation = new Vector3(-5.0, 0.0, 0.0);
  scene.addNode(nodePyramid);
  project.addNode(nodePyramid);

  GLTFMesh meshCube = new GLTFMesh.cube()
    ..primitives[0].material = material;
  project.meshes.add(meshCube);
  GLTFNode nodeCube = new GLTFNode()
    ..mesh = meshCube
    ..name = 'cube'
    ..translation = new Vector3(0.0, 0.0, 0.0);
  scene.addNode(nodeCube);
  project.addNode(nodeCube);

  // Todo (jpu) : bug with other primitives with MaterialBaseVertexColor
  GLTFMesh meshSphere = new GLTFMesh.sphere(meshPrimitiveInfos : new MeshPrimitiveInfos(useColors: false))
    ..primitives[0].material = material;
  project.meshes.add(meshSphere);
  GLTFNode nodeSphere = new GLTFNode()
    ..mesh = meshSphere
    ..name = 'sphere'
    ..translation = new Vector3(5.0, 0.0, 0.0);
  scene.addNode(nodeSphere);
  project.addNode(nodeSphere);

  return project;
}
