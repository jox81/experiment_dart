import 'dart:typed_data';

import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gtlf/material.dart';
import 'package:webgl/src/gtlf/mesh.dart';
import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/pbr_metallic_roughness.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/scene.dart';
import 'package:webgl/src/gtlf/texture_info.dart';

GLTFProject primitives() {
  GLTFProject project = new GLTFProject()..baseDirectory = 'primitives/';

  GLTFScene scene = new GLTFScene();
  scene.backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);// Todo (jpu) : ?
  project.addScene(scene);
  project.scene = scene;

  GLTFPBRMaterial material = new GLTFPBRMaterial(
      pbrMetallicRoughness: new GLTFPbrMetallicRoughness(
          baseColorFactor: new Float32List.fromList([1.0,1.0,1.0,1.0]),
          baseColorTexture: GLTFTextureInfo.createTexture(project, 'testTexture.png'),
          metallicFactor: 0.0,
          roughnessFactor: 1.0
      )
  );
  project.materials.add(material);

  GLTFMesh triangleMesh = GLTFMesh.triangle(withIndices:true, withNormals: false, withUVs: false)
    ..primitives[0].baseMaterial = material;
  project.meshes.add(triangleMesh);
  GLTFNode nodeTriangle = new GLTFNode()
  ..mesh = triangleMesh
  ..name = 'triangle'
  ..translation = new Vector3(0.0, 0.0, -5.0);
  scene.addNode(nodeTriangle);
  project.addNode(nodeTriangle);

  GLTFMesh quadMesh = GLTFMesh.quad(withIndices:true, withNormals: false, withUVs: true)
    ..primitives[0].baseMaterial = material;
  project.meshes.add(quadMesh);
  GLTFNode nodeQuad = new GLTFNode()
    ..mesh = quadMesh
    ..name = 'quad'
    ..translation = new Vector3(5.0, 0.0, -5.0);
  scene.addNode(nodeQuad);
  project.addNode(nodeQuad);

  GLTFMesh meshPyramid = GLTFMesh.pyramid(withNormals: false)
    ..primitives[0].baseMaterial = material;
  project.meshes.add(meshPyramid);
  GLTFNode nodePyramid = new GLTFNode()
    ..mesh = meshPyramid
    ..name = 'pyramid'
    ..translation = new Vector3(-5.0, 0.0, 0.0);
  scene.addNode(nodePyramid);
  project.addNode(nodePyramid);

  GLTFMesh meshCube = GLTFMesh.cube(withNormals: false)
    ..primitives[0].baseMaterial = material;
  project.meshes.add(meshPyramid);
  GLTFNode nodeMesh = new GLTFNode()
    ..mesh = meshCube
    ..name = 'cube'
    ..translation = new Vector3(0.0, 0.0, 0.0);
  scene.addNode(nodeMesh);
  project.addNode(nodeMesh);

  return project;
}

// Todo (jpu) : remarques sur comment convertir une scene application en gltf renderer
//class SceneViewPrimitives extends Scene{
//
//  CameraPerspective camera;
//  CameraPerspective camera2;
//  CameraPerspective camera3;
//
//  int cameraIndex = 0;
//
//  SceneViewPrimitives();
//
//  void switchCamera(){
//    cameraIndex += 1;
//    cameraIndex %= cameras.length;
//    Context.mainCamera = cameras[cameraIndex];
//  }
//
//  @override
//  Future setupScene() async {
//
//    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);// Todo (jpu) : c'est la scene qui devrait avoir un tel parametre
//
//    //Cameras
//    // field of view is 45°, width-to-height ratio, hide things closer than 0.1 or further than 100
//    camera = new CameraPerspective(radians(45.0), 5.0, 1000.0)
//      ..targetPosition = new Vector3.zero()
//      ..translation = new Vector3(5.0, 7.5, 10.0)
//      ..showGizmo = true;
//    cameras.add(camera);
//    Context.mainCamera = camera;
//
//    camera2 = new CameraPerspective(radians(37.0), 0.5, 10.0)
//      ..targetPosition = new Vector3(-5.0, 0.0, 0.0)
//      ..translation = new Vector3(2.0, 2.0, 2.0)
//      ..showGizmo = true;
//    cameras.add(camera2);
//
//    camera3 = new CameraPerspective(radians(37.0), 1.0, 100.0)
//      ..targetPosition = new Vector3(-5.0, 0.0, 0.0)
//      ..translation = new Vector3(10.0, 10.0, 10.0)
//      ..showGizmo = false;
//    cameras.add(camera3);
//
//    //Material
////    MaterialPoint materialPoint = new MaterialPoint(pointSize:5.0);
////    MaterialBase materialBase = new MaterialBase();
////
////    AxisMesh axis = new AxisMesh();
////    meshes.add(axis);
//
//    PointMesh point = new PointMesh()
//      ..name = 'point'
//      ..translation = new Vector3(-5.0, 0.0, -3.0);
//    meshes.add(point);
//
//    TriangleMesh triangle = new TriangleMesh()
//      ..name = 'triangle'
//      ..translation = new Vector3(0.0, 0.0, -5.0);
//    meshes.add(triangle);
//
//    QuadMesh quad = new QuadMesh()
//      ..name = "quad"
//      ..translation = new Vector3(5.0, 0.0, -5.0);
//    meshes.add(quad);
//
//    PyramidMesh pyramid = new PyramidMesh()
//      ..name = "pyramid"
//      ..translation = new Vector3(-5.0, 0.0, 0.0);
//    meshes.add(pyramid);
//
//    CubeMesh cube = new CubeMesh()
//      ..name = "cube"
//      ..translation = new Vector3(0.0, 0.0, 0.0);
//    meshes.add(cube);
//
//    SphereMesh sphere = new SphereMesh()
//      ..name = "sphere"
//      ..translation = new Vector3(5.0, 0.0, 0.0);
//    meshes.add(sphere);
//
//  }
//}
