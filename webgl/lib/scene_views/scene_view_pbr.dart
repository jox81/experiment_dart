import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/animation_property.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/meshes.dart';
import 'package:webgl/src/light.dart';
import 'dart:async';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/interface/IScene.dart';

class SceneViewPBR extends Scene{


  SceneViewPBR();

  @override
  UpdateFunction updateFunction;

  @override
  UpdateUserInput updateUserInputFunction;

  @override
  setupUserInput() {

    updateUserInputFunction = (){
      interaction.update();
    };

    updateUserInputFunction();

  }

  @override
  Future setupScene() async {

    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

    //Cameras
    // field of view is 45°, width-to-height ratio, hide things closer than 0.1 or further than 100
    Camera camera = new Camera(radians(45.0), 0.1, 1000.0)
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(0.0, 10.0, 5.0)
      ..cameraController = new CameraController();
    Context.mainCamera = camera;

    //Lights
    PointLight pointlLight = new PointLight()
      ..position = new Vector3(10.0, 10.0, 10.0);
    light = pointlLight;

    //Materials
//  MaterialBase materialBase = new MaterialBase();
//  application.materials.add(materialBase);

    MaterialPBR materialPBR = new MaterialPBR(pointlLight);
    materials.add(materialPBR);

    //Sphere
    SphereModel sphere = new SphereModel(radius: 1.0, segmentV: 48, segmentH: 48);
    sphere.transform.translate(0.0, 0.0, 0.0);
    sphere.material = materialPBR;
    //sphere.mode = RenderingContext.LINES;
    models.add(sphere);

    // Animation
    num _lastTime = 0.0;
    updateFunction = (num time) {
      // rotate
      double animationStep = time - _lastTime;
      //... animation here

      _lastTime = time;
    };
  }
}