import 'dart:html';
import 'dart:async';
import 'package:vector_math/vector_math.dart';
import 'packages/datgui/datgui.dart' as dat;
import 'package:webgl/src/application.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/mesh.dart';
import 'package:webgl/src/light.dart';
import 'package:webgl/src/texture.dart';
import 'package:webgl/src/utils.dart';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'dart:math';

Application application;
GuiSetup guisetup;

main() {
  CanvasElement canvas = querySelector('#glCanvas');
  canvas.width = document.body.clientWidth;
  canvas.height = document.body.clientHeight;

  //GUI
  guisetup = GuiSetup.setup();

  //Application
  application = new Application(canvas);
  application.setupScene(setupScene);
  application.renderAnimation();
}

setupScene() async {
  application.backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

  //Cameras
  // field of view is 45°, width-to-height ratio, hide things closer than 0.1 or further than 100
  Camera camera =
  new Camera(radians(37.0), application.viewAspectRatio, 0.1, 1000.0)
    ..aspectRatio = application.viewAspectRatio
    ..targetPosition = new Vector3.zero()
    ..position = new Vector3(20.0, 30.0, -50.0)
    ..cameraController = new CameraControllerOrbit();
  application.mainCamera = camera;

  //Lights
  application.ambientLight.color.setFrom(guisetup.getAmbientColor);

  DirectionalLight directionalLight = new DirectionalLight()
    ..color.setFrom(guisetup.getDirectionalColor)
    ..direction.setFrom(guisetup.getDirectionalPosition);
  application.light = directionalLight;

  PointLight pointLight = new PointLight()
  ..color.setFrom(guisetup.getDirectionalColor)
  ..position = new Vector3(20.0,20.0,20.0);
  application.light = pointLight;

  //Materials

//  MaterialBaseTextureNormal materialBaseTextureNormal =
//  await MaterialBaseTextureNormal.create()
//    ..ambientColor = application.ambientLight.color
//    ..directionalLight = directionalLight;
//  materialBaseTextureNormal..useLighting = guisetup.getUseLighting;
//  await materialBaseTextureNormal.addTexture("../images/crate.gif");
//  application.materials.add(materialBaseTextureNormal);

  MaterialPBR materialPBR = await MaterialPBR.create(pointLight);
  application.materials.add(materialPBR);

  //Meshes

  Random random = new Random();
  int count = 1;
  int randomWidth = 20;

  for(int i = 0; i < count; i++) {
    //Create Cube
    Mesh cube = new Mesh.Cube();
    cube.transform.translate(random.nextInt(randomWidth) - randomWidth/2, random.nextInt(randomWidth) - randomWidth/2, random.nextInt(randomWidth) - randomWidth/2);
    cube.material = materialPBR;
    application.meshes.add(cube);
  }
  // Animation
  num _lastTime = 0.0;
  application.updateScene((num time) {
    // rotate
    double animationStep = time - _lastTime;
//    cube.transform.rotateY((radians(45.0) * animationStep) / 1000.0);
    _lastTime = time;

//    materialBaseTextureNormal..useLighting = guisetup.getUseLighting;
//
//    application.ambientLight..color.setFrom(guisetup.getAmbientColor);
//    directionalLight
//      ..direction.setFrom(guisetup.getDirectionalPosition)
//      ..color.setFrom(guisetup.getDirectionalColor);
  });
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
