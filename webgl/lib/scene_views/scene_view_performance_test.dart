import 'dart:async';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/light.dart';
import 'dart:math';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/interface/IScene.dart';

class SceneViewPerformanceTest extends Scene{

  /// implements ISceneViewBase
  String message = 'test';
  int count = 0;

  bool useLighting = true;
  Vector3 directionalPosition = new Vector3(-0.25,-0.125,-0.25);
  Vector3 ambientColor = new Vector3.all(0.0);
  Vector3 directionalColor = new Vector3(0.8, 0.8, 0.8);

  SceneViewPerformanceTest();

  @override
  Future setupScene() async {

    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

    //Cameras
    // field of view is 45°, width-to-height ratio, hide things closer than 0.1 or further than 100
    Camera camera = new Camera(radians(37.0), 0.1, 1000.0)
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(20.0, 30.0, -50.0)
      ..cameraController = new CameraController();
    Context.mainCamera = camera;

    //Lights
    ambientLight.color.setFrom(ambientColor);

    DirectionalLight directionalLight = new DirectionalLight()
      ..color.setFrom(directionalColor)
      ..direction.setFrom(directionalPosition);
    light = directionalLight;

    PointLight pointLight = new PointLight()
      ..color.setFrom(directionalColor)
      ..position = new Vector3(20.0, 20.0, 20.0);
    light = pointLight;

    //Materials

//  MaterialBaseTextureNormal materialBaseTextureNormal =
//  await MaterialBaseTextureNormal.create()
//    ..ambientColor = application.ambientLight.color
//    ..directionalLight = directionalLight;
//  materialBaseTextureNormal..useLighting = useLighting;
//  await materialBaseTextureNormal.addTexture("../images/crate.gif");
//  application.materials.add(materialBaseTextureNormal);

    MaterialPBR materialPBR = new MaterialPBR(pointLight);
    materials.add(materialPBR);

    //Meshes

    Random random = new Random();
    int count = 50;
    int randomWidth = 2 ;

    for (int i = 0; i < count; i++) {
      //Create Cube
      CubeModel cube = new CubeModel()
        ..position = new Vector3(random.nextInt(randomWidth) - randomWidth / 2,
          random.nextInt(randomWidth) - randomWidth / 2,
          random.nextInt(randomWidth) - randomWidth / 2)
        ..material = materialPBR;
      models.add(cube);
    }
    // Animation
    num _lastTime = 0.0;
    updateFunction = (num time) {
      double animationStep = time - _lastTime;
      // Do animation
//    cube.transform.rotateY((radians(45.0) * animationStep) / 1000.0);
      _lastTime = time;

//    materialBaseTextureNormal..useLighting = useLighting;
//
//    application.ambientLight..color.setFrom(ambientColor);
//    directionalLight
//      ..direction.setFrom(directionalPosition)
//      ..color.setFrom(directionalColor);
    };
  }

}

