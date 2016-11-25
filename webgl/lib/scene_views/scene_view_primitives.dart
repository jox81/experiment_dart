import 'package:webgl/src/animation_property.dart';
import 'package:webgl/src/application.dart';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/mesh.dart';
import 'package:webgl/src/camera.dart';
import 'dart:async';
import 'package:webgl/src/primitives.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/interaction.dart';
import 'package:webgl/src/interface/IScene.dart';

class SceneViewPrimitives extends Scene implements IEditScene{

  //Todo : créer une liste déroulante de choix des meshes dans angular
  Camera camera2;
  Map<String, EditableProperty> get properties =>{
    'fov' : new EditableProperty<num>(()=> degrees(camera2.fOV), (num v)=> camera2.fOV = radians(v)),
    'camera Pos x' : new EditableProperty<num>(()=> camera2.position.x, (num v)=> camera2.position = new Vector3(v, camera2.position.y, camera2.position.z)),
    'camera Pos y' : new EditableProperty<num>(()=> camera2.position.y, (num v)=> camera2.position = new Vector3(camera2.position.x, v, camera2.position.z)),
    'camera Pos z' : new EditableProperty<num>(()=> camera2.position.z, (num v)=> camera2.position = new Vector3(camera2.position.x, camera2.position.y, v)),
    'camera target Pos x' : new EditableProperty<num>(()=> camera2.targetPosition.x, (num v)=> camera2.targetPosition = new Vector3(v, camera2.targetPosition.y, camera2.targetPosition.z)),
    'camera target Pos y' : new EditableProperty<num>(()=> camera2.targetPosition.y, (num v)=> camera2.targetPosition = new Vector3(camera2.targetPosition.x, v, camera2.targetPosition.z)),
    'camera target Pos z' : new EditableProperty<num>(()=> camera2.targetPosition.z, (num v)=> camera2.targetPosition = new Vector3(camera2.targetPosition.x, camera2.targetPosition.y, v)),
  };

  final num viewAspectRatio;

  SceneViewPrimitives(Application application):this.viewAspectRatio = application.viewAspectRatio,super(application){
    camera2 = await
    Camera.create(radians(37.0), 1.0, 5.0)
      ..aspectRatio = viewAspectRatio
      ..targetPosition = new Vector3(0.0, 0.0, -10.0)
      ..position = new Vector3.zero();
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
    Camera camera =await
    Camera.create(radians(45.0), 0.1, 1000.0)
      ..aspectRatio = viewAspectRatio
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(20.0, 30.0, 50.0)
      ..cameraController = new CameraController(gl.canvas);
    mainCamera = camera;


    //frustrum
    camera2.gizmo = await FrustrumGizmo.create(camera2);
    meshes.addAll(camera2.gizmo.gizmoMeshes);

    //Material
    MaterialPoint materialPoint = new MaterialPoint(5.0);
    MaterialBase materialBase = await MaterialBase.create();

    Mesh axis = await createAxis(this);
    Mesh points = await createAxisPoints(materialPoint);
    meshes.add(points);

    Mesh axis2 = await createAxis(this)
      ..transform.translate(5.0, 0.0, 0.0);

    // create cube
    Mesh centerCube = new Mesh.Cube()
      ..mode = GL.LINE_STRIP;
    centerCube.transform = axis2.transform;
    centerCube.material = materialBase;
    meshes.add(centerCube);

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



