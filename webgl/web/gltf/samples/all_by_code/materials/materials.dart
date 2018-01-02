import 'dart:async';
import 'dart:typed_data';

import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gtlf/material.dart';
import 'package:webgl/src/gtlf/mesh.dart';
import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/pbr_metallic_roughness.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/renderer/kronos_material.dart';
import 'package:webgl/src/gtlf/scene.dart';
import 'package:webgl/src/gtlf/texture_info.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

Future<GLTFProject> projectTestMaterials() async {
  GLTFProject project = new GLTFProject()..baseDirectory = 'materials/';

  GLTFScene scene = new GLTFScene();
  scene.backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);// Todo (jpu) : ?
  project.addScene(scene);
  project.scene = scene;

  GLTFPBRMaterial baseMmaterial = new GLTFPBRMaterial(
      pbrMetallicRoughness: new GLTFPbrMetallicRoughness(
          baseColorFactor: new Float32List.fromList([1.0,1.0,1.0,1.0]),
          baseColorTexture: GLTFTextureInfo.createTexture(project, 'testTexture.png'),
          metallicFactor: 0.0,
          roughnessFactor: 1.0
      )
  );
  project.materials.add(baseMmaterial);

  List<RawMaterial> materials = [
    new MaterialPoint(pointSize:5.0, color:new Vector4(0.0, 0.66, 1.0, 1.0)),
    new MaterialBase(),
    new MaterialBaseColor(new Vector4(1.0, 1.0, 0.0, 1.0)),
    new MaterialBaseTexture()..texture = await TextureUtils.createTexture2DFromFile('materials/testTexture.png'),
  ];

  int materialsIndex = 0;
  int drawMode = DrawMode.TRIANGLES;

  RawMaterial material = materials.last;
  
  // Todo (jpu) :This doesn't show, use another material
  GLTFMesh meshPoint = new GLTFMesh.point()
    ..primitives[0].material = material;
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
    ..primitives[0].material = material;
  project.meshes.add(meshLine);
  GLTFNode nodeLine = new GLTFNode()
  ..mesh = meshLine
  ..name = 'multiline'
  ..translation = new Vector3(-5.0, 0.0, -5.0);
  scene.addNode(nodeLine);
  project.addNode(nodeLine);

  // Todo (jpu) : should use normals
  GLTFMesh meshTriangle = new GLTFMesh.triangle(withNormals: false)
    ..primitives[0].material = material
    ..primitives[0].drawMode = drawMode;
  project.meshes.add(meshTriangle);
  GLTFNode nodeTriangle = new GLTFNode()
  ..mesh = meshTriangle
  ..name = 'triangle'
  ..translation = new Vector3(0.0, 0.0, -5.0);
  scene.addNode(nodeTriangle);
  project.addNode(nodeTriangle);

  // Todo (jpu) : should use normals
  GLTFMesh meshQuad = new GLTFMesh.quad(withNormals: false)
    ..primitives[0].material = material
    ..primitives[0].drawMode = drawMode;
  project.meshes.add(meshQuad);
  GLTFNode nodeQuad = new GLTFNode()
    ..mesh = meshQuad
    ..name = 'quad'
    ..translation = new Vector3(5.0, 0.0, -5.0);
  scene.addNode(nodeQuad);
  project.addNode(nodeQuad);

  // Todo (jpu) : should use normals
  GLTFMesh meshPyramid = new GLTFMesh.pyramid(withNormals: false)
    ..primitives[0].material = material
    ..primitives[0].drawMode = drawMode;
  project.meshes.add(meshPyramid);
  GLTFNode nodePyramid = new GLTFNode()
    ..mesh = meshPyramid
    ..name = 'pyramid'
    ..translation = new Vector3(-5.0, 0.0, 0.0);
  scene.addNode(nodePyramid);
  project.addNode(nodePyramid);

  // Todo (jpu) : should use normals
  GLTFMesh meshCube = new GLTFMesh.cube(withNormals: false)
    ..primitives[0].material = material
    ..primitives[0].drawMode = drawMode;
  project.meshes.add(meshPyramid);
  GLTFNode nodeCube = new GLTFNode()
    ..mesh = meshCube
    ..name = 'cube'
    ..translation = new Vector3(0.0, 0.0, 0.0);
  scene.addNode(nodeCube);
  project.addNode(nodeCube);

  // Todo (jpu) : should use normals
  GLTFMesh meshSphere = new GLTFMesh.sphere(segmentV: 8, segmentH: 8,withNormals: false)
    ..primitives[0].material = material
    ..primitives[0].drawMode = drawMode;
  project.meshes.add(meshSphere);
  GLTFNode nodeSphere = new GLTFNode()
    ..mesh = meshSphere
    ..name = 'sphere'
    ..translation = new Vector3(5.0, 0.0, 0.0);
  scene.addNode(nodeSphere);
  project.addNode(nodeSphere);

  return project;
}

// Todo (jpu) : remarques sur comment convertir une scene application en gltf renderer
////    AxisMesh axis = new AxisMesh();
////    meshes.add(axis);
