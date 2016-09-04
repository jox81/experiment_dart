import 'dart:async';
import 'package:vector_math/vector_math.dart';
import 'package:datgui/datgui.dart' as dat;
import 'package:webgl/src/application.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/mesh.dart';
import 'package:webgl/src/light.dart';
import 'dart:math';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/interaction.dart';
import 'package:webgl/src/interface/IScene.dart';

class SceneViewPerformanceTest extends Scene {

  num viewAspectRatio;

  Vector3 directionalPosition;
  Vector3 ambientColor, directionalColor;
  bool useLighting;

  SceneViewPerformanceTest(this.viewAspectRatio):super();

  @override
  UpdateFunction updateFunction;

  @override
  UpdateUserInput updateUserInputFunction;

  setupUserInput() {

    GuiSetup guisetup = GuiSetup.setup();

    Interaction interaction = new Interaction(scene);

    //UserInput
    updateUserInputFunction = (){
      ambientColor = guisetup.getAmbientColor;
      directionalColor = guisetup.getDirectionalColor;
      directionalPosition = guisetup.getDirectionalPosition;
      useLighting = guisetup.getUseLighting;

      interaction.update();
    };

    updateUserInputFunction();

  }

  Future setupScene() async {

    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

    //Cameras
    // field of view is 45°, width-to-height ratio, hide things closer than 0.1 or further than 100
    Camera camera =
    new Camera(radians(37.0), 0.1, 1000.0)
      ..aspectRatio = viewAspectRatio
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(20.0, 30.0, -50.0)
      ..cameraController = new CameraController();
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
//  materialBaseTextureNormal..useLighting = guisetup.getUseLighting;
//  await materialBaseTextureNormal.addTexture("../images/crate.gif");
//  application.materials.add(materialBaseTextureNormal);

    MaterialPBR materialPBR = await MaterialPBR.create(pointLight);
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

//    materialBaseTextureNormal..useLighting = guisetup.getUseLighting;
//
//    application.ambientLight..color.setFrom(guisetup.getAmbientColor);
//    directionalLight
//      ..direction.setFrom(guisetup.getDirectionalPosition)
//      ..color.setFrom(guisetup.getDirectionalColor);
    };
  }

}

class GuiSetup {

  static GuiSetup setup() {
    //GUI
    GuiSetup guisetup = new GuiSetup();
    dat.GUI gui = new dat.GUI();
    gui.add(guisetup, 'message');
    gui.add(guisetup, 'getUseLighting');

    dat.GUI f2 = gui.addFolder("Lighting Position");
    f2.add(guisetup, 'getDirectionalPositionX',-100.0,100.0);
    f2.add(guisetup, 'getDirectionalPositionY',-100.0,100.0);
    f2.add(guisetup, 'getDirectionalPositionZ',-100.0,100.0);

    dat.GUI directionalColor = gui.addFolder("Directionnal color");
    directionalColor.add(guisetup, 'getDirectionalColorR',0.001,1.001);//needed until now to round 0 int or 1 int to double
    directionalColor.add(guisetup, 'getDirectionalColorG',0.001,1.001);
    directionalColor.add(guisetup, 'getDirectionalColorB',0.001,1.001);

    dat.GUI ambiantColor = gui.addFolder("Ambiant color");
    ambiantColor.add(guisetup, 'getDirectionalColorR',0.001,1.001);//needed until now to round 0 int or 1 int to double
    ambiantColor.add(guisetup, 'getDirectionalColorG',0.001,1.001);
    ambiantColor.add(guisetup, 'getDirectionalColorB',0.001,1.001);

    return guisetup;
  }

  String message = '';
  bool getUseLighting = true;

  Vector3 getDirectionalPosition = new Vector3(-0.25,-0.125,-0.25);
  double get getDirectionalPositionX => getDirectionalPosition.x;
  set getDirectionalPositionX(double value){ getDirectionalPosition.x = value;}
  double get getDirectionalPositionY => getDirectionalPosition.y;
  set getDirectionalPositionY(double value){ getDirectionalPosition.y = value;}
  double get getDirectionalPositionZ => getDirectionalPosition.z;
  set getDirectionalPositionZ(double value){ getDirectionalPosition.z = value;}

  Vector3 getDirectionalColor = new Vector3(0.8, 0.8, 0.8);
  double get getDirectionalColorR => getDirectionalColor.r;
  set getDirectionalColorR(double value){ getDirectionalColor.r = value;}
  double get getDirectionalColorG => getDirectionalColor.g;
  set getDirectionalColorG(double value){ getDirectionalColor.g = value;}
  double get getDirectionalColorB => getDirectionalColor.b;
  set getDirectionalColorB(double value){ getDirectionalColor.b = value;}

  Vector3 getAmbientColor = new Vector3(0.2,0.2,0.2);
  double get getAmbientColorR => getAmbientColor.r;
  set getAmbientColorR(double value){ getAmbientColor.r = value;}
  double get getAmbientColorG => getAmbientColor.g;
  set getAmbientColorG(double value){ getAmbientColor.g = value;}
  double get getAmbientColorB => getAmbientColor.b;
  set getAmbientColorB(double value){ getAmbientColor.b = value;}

}
