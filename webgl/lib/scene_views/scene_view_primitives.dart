import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/camera.dart';
import 'dart:async';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/scene.dart';
@MirrorsUsed(
    targets: const [
      SceneViewPrimitives,
    ],
    override: '*')
import 'dart:mirrors';

class SceneViewPrimitives extends Scene{

  Camera camera;
//  Camera camera2;
//  Camera camera3;

  int cameraIndex = 0;

  SceneViewPrimitives();

  //Todo : move to global
  void switchCamera(){
    cameraIndex += 1;
    cameraIndex %= cameras.length;
    Context.mainCamera = cameras[cameraIndex];
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

//    camera2 = new Camera(radians(37.0), 0.5, 10.0)
//      ..targetPosition = new Vector3(-5.0, 0.0, 0.0)
//      ..position = new Vector3(2.0, 2.0, 2.0)
//      ..cameraController = new CameraController()
//      ..showGizmo = true;
//    models.add(camera2);

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
//
//    AxisModel axis = new AxisModel();
//    models.add(axis);

    MaterialBaseColor materialBaseColor = new MaterialBaseColor(new Vector4(1.0,1.0,0.0, 1.0));
    materials.add(materialBaseColor);

    PointModel point = new PointModel()
      ..name = 'point'
      ..position = new Vector3(-5.0, 0.0, -5.0);
    models.add(point);

    TriangleModel triangle = new TriangleModel()
      ..name = 'triangle'
      ..position = new Vector3(0.0, 0.0, -5.0);
    models.add(triangle);

    QuadModel quad = new QuadModel()
      ..name = "quad"
      ..position = new Vector3(5.0, 0.0, -5.0);
    models.add(quad);

    PyramidModel pyramid = new PyramidModel()
      ..name = "pyramid"
      ..position = new Vector3(-5.0, 0.0, 0.0);
    models.add(pyramid);

    CubeModel cube = new CubeModel()
      ..name = "cube"
      ..position = new Vector3(0.0, 0.0, 0.0);
    models.add(cube);

    SphereModel sphere = new SphereModel()
      ..name = "sphere"
      ..position = new Vector3(5.0, 0.0, 0.0);
    models.add(sphere);

//    Map susanJson = await Utils.loadJSONResource('../objects/susan/susan.json');
//
//    JsonObject jsonModel = new JsonObject(susanJson)
//      ..name = "jsonModel"
//      ..transform.rotateX(radians(-90.0));
//    models.add(jsonModel);

  }
}
