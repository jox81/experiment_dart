import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/scene.dart';
import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/gltf/mesh/mesh_primitive_infos.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/materials.dart';
import 'package:webgl/lights.dart';
import 'dart:math';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/camera/types/perspective_camera.dart';

GLTFProject projectSceneViewPerformance() {

  bool useLighting = true;

  GLTFProject project = new GLTFProject.create();
  GLTFScene scene = new GLTFScene()
    ..backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);
  project.scene = scene;

  Context.mainCamera = new
  CameraPerspective(radians(37.0), 0.1, 1000.0)
    ..targetPosition = new Vector3.zero()
    ..translation = new Vector3(10.0, 10.0, 10.0);

  String message = 'test';

  Vector3 directionalPosition = new Vector3(-0.25,-0.125,-0.25);
  Vector3 ambientColor = new Vector3.all(0.0);
  Vector3 directionalColor = new Vector3(0.8, 0.8, 0.8);

  // Todo (jpu) :
  //Lights
  AmbientLight ambientLight = new AmbientLight()
    ..color = (ambientColor);

  DirectionalLight directionalLight = new DirectionalLight()
    ..direction = directionalPosition
    ..color = directionalColor;
//    light = directionalLight;// Todo (jpu) :

    PointLight pointLight = new PointLight()
      ..color.setFrom(directionalColor)
      ..translation = new Vector3(20.0, 20.0, 20.0);
//    light = pointLight;

    //Materials
//  MaterialBaseTextureNormal materialBaseTextureNormal =
//  await MaterialBaseTextureNormal.create()
//    ..ambientColor = application.ambientLight.color
//    ..directionalLight = directionalLight;
//  materialBaseTextureNormal..useLighting = useLighting;
//  await materialBaseTextureNormal.addTexture("../images/crate.gif");
//  application.materials.add(materialBaseTextureNormal);

  MaterialBaseColor materialBaseColor = new MaterialBaseColor(
      new Vector4(1.0, 1.0, 0.0, 1.0));

//  MaterialPragmaticPBR materialPBR = new MaterialPragmaticPBR(pointLight);
//  project.materials.add(materialPBR); // Todo (jpu) : don't add ?

    //Meshes
    Random random = new Random();
    int count = 50;
    int randomWidth = 10;

    for (int i = 0; i < count; i++) {
      GLTFMesh meshCenterCube = new GLTFMesh.cube(meshPrimitiveInfos : new MeshPrimitiveInfos(useNormals: false))
        ..primitives[0].material = materialBaseColor;
      GLTFNode nodeCenterCube = new GLTFNode()
        ..mesh = meshCenterCube
        ..name = 'cube'
        ..translation = new Vector3(random.nextInt(randomWidth) - randomWidth / 2,
          random.nextInt(randomWidth) - randomWidth / 2,
          random.nextInt(randomWidth) - randomWidth / 2)
        ..scale = new Vector3(0.1, 0.1, 0.1);
      scene.addNode(nodeCenterCube);
    }

//    // Animation
//    updateSceneFunction = () {
////    cube.transform.rotateY((radians(45.0) * animationStep) / 1000.0);
//
////    materialBaseTextureNormal..useLighting = useLighting;
////
////    application.ambientLight..color.setFrom(ambientColor);
////    directionalLight
////      ..direction.setFrom(directionalPosition)
////      ..color.setFrom(directionalColor);
//    };
//  }
//

  return project;
}