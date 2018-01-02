import 'dart:typed_data';

import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gtlf/material.dart';
import 'package:webgl/src/gtlf/mesh.dart';
import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/pbr_metallic_roughness.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/renderer/kronos_material.dart';
import 'package:webgl/src/gtlf/scene.dart';

GLTFProject projectPrimitives() {
  GLTFProject project = new GLTFProject()..baseDirectory = 'primitives/';

  GLTFScene scene = new GLTFScene();
  scene.backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);// Todo (jpu) : ?
  project.addScene(scene);
  project.scene = scene;

  GLTFPBRMaterial material = new GLTFPBRMaterial(
      pbrMetallicRoughness: new GLTFPbrMetallicRoughness(
          baseColorFactor: new Float32List.fromList([1.0,1.0,1.0,1.0]),
          baseColorTexture: null,//GLTFTextureInfo.createTexture(project, 'testTexture.png'),
          metallicFactor: 0.0,
          roughnessFactor: 1.0
      )
  );
  project.materials.add(material);

  MaterialPoint materialPoint = new MaterialPoint(pointSize:10.0, color:new Vector4(0.0, 0.66, 1.0, 1.0));
//  project.materials.add(material); // Todo (jpu) : don't add ?

  // Todo (jpu) :This doesn't show, use another material ?
  GLTFMesh meshPoint = new GLTFMesh.point()
    ..primitives[0].material = materialPoint;
  project.meshes.add(meshPoint);
  GLTFNode nodePoint = new GLTFNode()
    ..mesh = meshPoint
    ..name = 'point'
    ..translation = new Vector3(-5.0, 0.0, -5.0);
  scene.addNode(nodePoint);
  project.addNode(nodePoint);

  // Todo (jpu) :This doesn't show, use another material
  GLTFMesh meshLine = new GLTFMesh.line([
    new Vector3.all(0.0),
    new Vector3(10.0, 0.0, 0.0),
    new Vector3(10.0, 0.0, 10.0),
    new Vector3(10.0, 10.0, 10.0),
  ])
    ..primitives[0].baseMaterial = material;
  project.meshes.add(meshLine);
  GLTFNode nodeLine = new GLTFNode()
    ..mesh = meshLine
    ..name = 'multiline'
    ..translation = new Vector3(-5.0, 0.0, -5.0);
  scene.addNode(nodeLine);
  project.addNode(nodeLine);

  // Todo (jpu) : should use normals
  GLTFMesh meshTriangle = new GLTFMesh.triangle(withNormals: false)
    ..primitives[0].baseMaterial = material;
  project.meshes.add(meshTriangle);
  GLTFNode nodeTriangle = new GLTFNode()
    ..mesh = meshTriangle
    ..name = 'triangle'
    ..translation = new Vector3(0.0, 0.0, -5.0);
  scene.addNode(nodeTriangle);
  project.addNode(nodeTriangle);

  // Todo (jpu) : should use normals
  GLTFMesh meshQuad = new GLTFMesh.quad(withNormals: false)
    ..primitives[0].baseMaterial = material;
  project.meshes.add(meshQuad);
  GLTFNode nodeQuad = new GLTFNode()
    ..mesh = meshQuad
    ..name = 'quad'
    ..translation = new Vector3(5.0, 0.0, -5.0);
  scene.addNode(nodeQuad);
  project.addNode(nodeQuad);

  // Todo (jpu) : should use normals
  GLTFMesh meshPyramid = new GLTFMesh.pyramid(withNormals: false)
    ..primitives[0].baseMaterial = material;
  project.meshes.add(meshPyramid);
  GLTFNode nodePyramid = new GLTFNode()
    ..mesh = meshPyramid
    ..name = 'pyramid'
    ..translation = new Vector3(-5.0, 0.0, 0.0);
  scene.addNode(nodePyramid);
  project.addNode(nodePyramid);

  // Todo (jpu) : should use normals
  GLTFMesh meshCube = new GLTFMesh.cube(withNormals: false)
    ..primitives[0].baseMaterial = material;
  project.meshes.add(meshCube);
  GLTFNode nodeCube = new GLTFNode()
    ..mesh = meshCube
    ..name = 'cube'
    ..translation = new Vector3(0.0, 0.0, 0.0);
  scene.addNode(nodeCube);
  project.addNode(nodeCube);

  // Todo (jpu) : should use normals
  GLTFMesh meshSphere = new GLTFMesh.sphere(withNormals: false)
    ..primitives[0].baseMaterial = material;
  project.meshes.add(meshSphere);
  GLTFNode nodeSphere = new GLTFNode()
    ..mesh = meshSphere
    ..name = 'sphere'
    ..translation = new Vector3(5.0, 0.0, 0.0);
  scene.addNode(nodeSphere);
  project.addNode(nodeSphere);

  return project;
}