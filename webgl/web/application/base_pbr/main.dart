import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'packages/datgui/datgui.dart' as dat;
import 'package:webgl/src/application.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/mesh.dart';
import 'package:webgl/src/light.dart';

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
  new Camera(radians(45.0), application.viewAspectRatio, 0.1, 1000.0)
    ..aspectRatio = application.viewAspectRatio
    ..targetPosition = new Vector3.zero()
    ..position = new Vector3(0.0, 10.0, 5.0);
  CameraController cameraController = new CameraController()
    ..onChange = (num xRot, num yRot){
      camera.rotateCamera(xRot, yRot);
    };
  application.mainCamera = camera;

  //Lights
  PointLight pointlLight = new PointLight()
  ..position = new Vector3(10.0,10.0,10.0);
  application.light = pointlLight;

  //Materials
//  MaterialBase materialBase = new MaterialBase();
//  application.materials.add(materialBase);

  MaterialPBR materialPBR = await MaterialPBR.create(pointlLight);
  application.materials.add(materialPBR);

  //Sphere
  Mesh sphere = Mesh.createSphere(radius:1.0, segmentV :48, segmentH: 48);
  sphere.transform.translate(0.0, 0.0, 0.0);
  sphere.material = materialPBR;
  //sphere.mode = GL.LINES;
  application.meshes.add(sphere);

  // Animation
  num _lastTime = 0.0;
  application.updateScene((num time) {
    // rotate
    double animationStep = time - _lastTime;
    //... animation here
    _lastTime = time;
  });
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
