import 'package:webgl/src/animation_property.dart';
import 'package:webgl/src/application.dart';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/mesh.dart';
import 'package:webgl/src/camera.dart';
import 'dart:async';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/interaction.dart';
import 'package:webgl/src/interface/IScene.dart';

class SceneViewPrimitives extends Scene implements IEditScene{

  Map<String, EditableProperty> get properties =>{};

  final num viewAspectRatio;

  SceneViewPrimitives(Application application):this.viewAspectRatio = application.viewAspectRatio,super(application);

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
    Camera camera =
    new Camera(radians(45.0), 0.1, 1000.0)
      ..aspectRatio = viewAspectRatio
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(20.0, 30.0, 50.0)
      ..cameraController = new CameraController(gl.canvas);
    mainCamera = camera;

    //Material
    MaterialPoint materialPoint = await MaterialPoint.create(5.0);
    materials.add(materialPoint);

    MaterialBase materialBase = await MaterialBase.create();
    materials.add(materialBase);

    Mesh axis = await createAxis();
    Mesh points = await createPoints(materialPoint);

    Mesh axis2 = await createAxis()
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

  //Points
  Future<Mesh> createPoints(MaterialPoint materialPoint) async {
    //Material
    MaterialPoint materialPoint = await MaterialPoint.create(5.0);
    materials.add(materialPoint);

    Mesh mesh = new Mesh()
      ..mode = GL.POINTS
      ..vertices = [
        0.0, 0.0, 0.0,
        1.0, 0.0, 0.0,
        0.0, 1.0, 0.0,
        0.0, 0.0, 1.0,
      ]
      ..colors = [
        1.0, 1.0, 0.0, 1.0,
        1.0, 0.0, 0.0, 1.0,
        0.0, 1.0, 0.0, 1.0,
        0.0, 0.0, 1.0, 1.0,
      ]
      ..material = materialPoint;

    meshes.add(mesh);

    return mesh;
  }

  Future<Mesh> createAxis() async {
    //Material
    MaterialPoint materialPoint = await MaterialPoint.create(5.0);
    materials.add(materialPoint);

    Mesh mesh = new Mesh()
      ..mode = GL.LINES
      ..vertices = [
        0.0, 0.0, 0.0,
        1.0, 0.0, 0.0,
        0.0, 0.0, 0.0,
        0.0, 1.0, 0.0,
        0.0, 0.0, 0.0,
        0.0, 0.0, 1.0,
      ]
      ..colors = [
        1.0, 0.0, 0.0, 1.0,
        1.0, 0.0, 0.0, 1.0,
        0.0, 1.0, 0.0, 1.0,
        0.0, 1.0, 0.0, 1.0,
        0.0, 0.0, 1.0, 1.0,
        0.0, 0.0, 1.0, 1.0,
      ]
      ..material = materialPoint;

    meshes.add(mesh);

    return mesh;
  }
}

