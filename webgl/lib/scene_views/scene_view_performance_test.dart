import 'dart:async';
import 'package:vector_math/vector_math.dart';
import 'package:datgui/datgui.dart' as dat;
import 'package:webgl/src/animation_property.dart';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/mesh.dart';
import 'package:webgl/src/light.dart';
import 'dart:math';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/interaction.dart';
import 'package:webgl/src/interface/IScene.dart';

class SceneViewPerformanceTest extends Scene implements IEditScene{

  /// implements ISceneViewBase
  String message = 'test';
  int count = 0;
  Map<String, EditableProperty> get properties =>{
    'message' : new EditableProperty<String>(()=> message, (String v)=> message = v),
    'count' : new EditableProperty<int>(()=> count, (int v)=> count = v),
    'useLighting' : new EditableProperty<bool>(()=> useLighting, (bool v)=> useLighting = v),
    'ambientColorR' : new EditableProperty<num>(()=> ambientColor.r, (num v)=> ambientColor.r = v),
    'ambientColorG' : new EditableProperty<num>(()=> ambientColor.g, (num v)=> ambientColor.g = v),
    'ambientColorB' : new EditableProperty<num>(()=> ambientColor.b, (num v)=> ambientColor.b = v),
    'directionalPositionX' : new EditableProperty<num>(()=> directionalPosition.x, (num v)=> directionalPosition.x = v),
    'directionalPositionY' : new EditableProperty<num>(()=> directionalPosition.y, (num v)=> directionalPosition.y = v),
    'directionalPositionZ' : new EditableProperty<num>(()=> directionalPosition.z, (num v)=> directionalPosition.z = v),
    'directionalColorR' : new EditableProperty<num>(()=> directionalColor.r, (num v)=> directionalColor.r = v),
    'directionalColorG' : new EditableProperty<num>(()=> directionalColor.g, (num v)=> directionalColor.g = v),
    'directionalColorB' : new EditableProperty<num>(()=> directionalColor.b, (num v)=> directionalColor.b = v),
  };

  bool useLighting = true;
  Vector3 directionalPosition = new Vector3(-0.25,-0.125,-0.25);
  Vector3 ambientColor = new Vector3.all(0.0);
  Vector3 directionalColor = new Vector3(0.8, 0.8, 0.8);

  final num viewAspectRatio;

  SceneViewPerformanceTest(Application application):this.viewAspectRatio = application.viewAspectRatio,super(application);

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
    Camera camera = new Camera(radians(37.0), 0.1, 1000.0)
      ..aspectRatio = viewAspectRatio
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(20.0, 30.0, -50.0)
      ..cameraController = new CameraController(gl.canvas);
    mainCamera = camera;

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
    int count = 1;
    int randomWidth = 20;

    for (int i = 0; i < count; i++) {
      //Create Cube
      Mesh cube = new Mesh.Cube();
      cube.transform.translate(random.nextInt(randomWidth) - randomWidth / 2,
          random.nextInt(randomWidth) - randomWidth / 2,
          random.nextInt(randomWidth) - randomWidth / 2);
      cube.material = materialPBR;
      meshes.add(cube);
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

