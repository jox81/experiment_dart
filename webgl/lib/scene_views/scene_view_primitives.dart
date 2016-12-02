import 'package:webgl/src/animation_property.dart';
import 'package:webgl/src/application.dart';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/globals/context.dart';
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

  Vector4 test = new Vector4.all(1.0);

  Camera camera;
  Camera camera2;
  Camera camera3;

//  Map<String, EditableProperty> get properties =>{
//    'fov' : new EditableProperty<num>(num,()=> degrees(camera2.fOV), (num v)=> camera2.fOV = radians(v)),
//    'camera Pos x' : new EditableProperty<num>(num,()=> camera2.position.x, (num v)=> camera2.position = new Vector3(v, camera2.position.y, camera2.position.z)),
//    'camera Pos y' : new EditableProperty<num>(num,()=> camera2.position.y, (num v)=> camera2.position = new Vector3(camera2.position.x, v, camera2.position.z)),
//    'camera Pos z' : new EditableProperty<num>(num,()=> camera2.position.z, (num v)=> camera2.position = new Vector3(camera2.position.x, camera2.position.y, v)),
//    'camera target Pos x' : new EditableProperty<num>(num,()=> camera2.targetPosition.x, (num v)=> camera2.targetPosition = new Vector3(v, camera2.targetPosition.y, camera2.targetPosition.z)),
//    'camera target Pos y' : new EditableProperty<num>(num,()=> camera2.targetPosition.y, (num v)=> camera2.targetPosition = new Vector3(camera2.targetPosition.x, v, camera2.targetPosition.z)),
//    'camera target Pos z' : new EditableProperty<num>(num,()=> camera2.targetPosition.z, (num v)=> camera2.targetPosition = new Vector3(camera2.targetPosition.x, camera2.targetPosition.y, v)),
//    'show Gizmo' : new EditableProperty<bool>(bool,()=> camera2.showGizmo, (bool v)=> camera2.showGizmo = v),
//    'switchCamera' : new EditableProperty<Function>(Function,()=> switchCamera, null),
//  };

  int cameraIndex = 0;
  void switchCamera(){
    cameraIndex += 1;
    cameraIndex %= cameras.length;
    Context.mainCamera = cameras[cameraIndex];
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
      ..aspectRatio = Context.viewAspectRatio
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(20.0, 30.0, 50.0)
      ..cameraController = new CameraController()
      ..showGizmo = true;
    models.add(camera);
    Context.mainCamera = camera;

    camera2 = new Camera(radians(37.0), 5.0, 100.0)
      ..aspectRatio = Context.viewAspectRatio
      ..targetPosition = new Vector3(-5.0, 0.0, 0.0)
      ..position = new Vector3(10.0, 10.0, 10.0)
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


    TriangleModel triangleModel = new TriangleModel()
      ..name = 'triangle'
      ..position = new Vector3(1.0, 0.0, 3.0);
    models.add(triangleModel);


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



