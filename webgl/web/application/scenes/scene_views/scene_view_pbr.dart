import 'package:vector_math/vector_math.dart';
import 'package:datgui/datgui.dart' as dat;
import 'package:webgl/src/application.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/mesh.dart';
import 'package:webgl/src/light.dart';
import 'dart:async';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/interaction.dart';
import 'package:webgl/src/interface/IScene.dart';

class SceneViewPBR extends Scene {

  num viewAspectRatio;

  SceneViewPBR(this.viewAspectRatio):super();

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
      ..position = new Vector3(0.0, 10.0, 5.0)
      ..cameraController = new CameraController();
    mainCamera = camera;

    //Lights
    PointLight pointlLight = new PointLight()
      ..position = new Vector3(10.0, 10.0, 10.0);
    light = pointlLight;

    //Materials
//  MaterialBase materialBase = new MaterialBase();
//  application.materials.add(materialBase);

    MaterialPBR materialPBR = await MaterialPBR.create(pointlLight);
    materials.add(materialPBR);

    //Sphere
    Mesh sphere = new Mesh.Sphere(radius: 1.0, segmentV: 48, segmentH: 48);
    sphere.transform.translate(0.0, 0.0, 0.0);
    sphere.material = materialPBR;
    //sphere.mode = GL.LINES;
    meshes.add(sphere);

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

class GuiSetup {

  static GuiSetup setup() {
    //GUI
    GuiSetup guisetup = new GuiSetup();
    dat.GUI gui = new dat.GUI();

    //Setup
    //...

    return guisetup;
  }

}
