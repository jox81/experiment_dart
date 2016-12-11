import 'package:webgl/src/animation_property.dart';
import 'package:webgl/src/application.dart';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/globals/context.dart';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/meshes.dart';
import 'package:webgl/src/camera.dart';
import 'dart:async';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/interaction.dart';
import 'package:webgl/src/interface/IScene.dart';
import 'package:webgl/src/utils.dart';

class SceneViewPrimitives extends Scene{

  //Todo : créer une liste déroulante de choix des meshes dans angular

  Camera camera;
  Camera camera2;
  Camera camera3;

  int cameraIndex = 0;

  void switchCamera(){
    cameraIndex += 1;
    cameraIndex %= cameras.length;
    Context.mainCamera = cameras[cameraIndex];
  }

  void testEdit(){
    currentSelection = new CustomEditElement(new Vector3(1.0,2.0,3.0));
  }

  SceneViewPrimitives(){

  }

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
    camera = new Camera(radians(45.0), 5.0, 1000.0)
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(5.0, 7.5, 10.0)
      ..cameraController = new CameraController()
      ..showGizmo = true;
    models.add(camera);
    Context.mainCamera = camera;

    camera2 = new Camera(radians(37.0), 0.5, 10.0)
      ..targetPosition = new Vector3(-5.0, 0.0, 0.0)
      ..position = new Vector3(2.0, 2.0, 2.0)
      ..cameraController = new CameraController()
      ..showGizmo = true;
    models.add(camera2);

//    camera3 = new Camera(radians(37.0), 1.0, 100.0)
//      ..aspectRatio = Context.viewAspectRatio
//      ..targetPosition = new Vector3(-5.0, 0.0, 0.0)
//      ..position = new Vector3(10.0, 10.0, 10.0)
//      ..cameraController = new CameraController()
//      ..showGizmo = true;
//    models.add(camera3);

    //Material
//    MaterialPoint materialPoint = new MaterialPoint(pointSize:5.0);
//    MaterialBase materialBase = new MaterialBase();

    AxisModel axis = new AxisModel();
    models.add(axis);

//    models.add(
//        new PointModel()
//          ..name = 'point1'
//          ..position = new Vector3(1.0, 0.0, 1.0)
//    );
//
//    models.add(
//        new PointModel()
//          ..name = 'point2'
//          ..position.setFrom(new Vector3(1.0, 0.0, 1.0))
//    );

//    models.add(new TriangleModel()
//      ..name = 'triangle1'
//      ..position = new Vector3(1.0, 0.0, 3.0));

//    QuadModel quad = new QuadModel()
//      ..name = "quad"
//      ..position = new Vector3(2.0, 0.0, 0.0);
//    models.add(quad);

//    PyramidModel pyramid = new PyramidModel()
//      ..name = "pyramid"
//      ..position = new Vector3(5.0, 5.0, 0.0);
//    models.add(pyramid);

//    CubeModel cube = new CubeModel()
//      ..name = "cube"
//      ..position = new Vector3(-5.0, 5.0, 0.0);
//    models.add(cube);

//    SphereModel sphere = new SphereModel()
//      ..name = "sphere"
//      ..position = new Vector3(-5.0, -5.0, 0.0);
//    models.add(sphere);

//    Map susanJson = await Utils.loadJSONResource('../objects/susan/susan.json');
//
//    JsonObject jsonModel = new JsonObject(susanJson)
//      ..name = "jsonModel"
//      ..transform.rotateX(radians(-90.0));
//    models.add(jsonModel);

    //Animation
    num _lastTime = 0.0;
    updateFunction = (num time) {
      // rotate
      double animationStep = time - _lastTime;
      //... animation here
      _lastTime = time;
    };
  }
}



