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
    ..position = new Vector3(20.0, 30.0, -50.0);
  CameraController cameraController = new CameraController()
    ..onChange = (num xRot, num yRot){
      camera.rotateCamera(xRot, yRot);
    };
  application.mainCamera = camera;

  //Lights
  PointLight pointlLight = new PointLight()
  ..position = new Vector3(100.0,100.0,10.0);
  application.light = pointlLight;

  //Materials
  MaterialPBR materialPBR = new MaterialPBR(pointlLight.position);
  application.materials.add(materialPBR);

  //Meshes
  ////SusanModel
  Mesh susanMesh = await createSusanModel()
  ..transform.translate(0.0, 0.0, 0.0)
  ..transform.rotateX(radians(90.0))
  ..transform.rotateY(radians(180.0));
  susanMesh.material = materialPBR;
  application.meshes.add(susanMesh);

  // Animation
  num _lastTime = 0.0;
  application.updateScene((num time) {
    // rotate
    double animationStep = time - _lastTime;
    //... animation here
    _lastTime = time;
  });
}

Future createSusanModel() async {
  //SusanModel
  var susanJson = await Utils.loadJSONResource('../objects/susan/susan.json');
  Mesh susanMesh = new Mesh();

  susanMesh.vertices = susanJson['meshes'][0]['vertices'];
  susanMesh.indices = susanJson['meshes'][0]['faces']
      .expand((i) => i)
      .toList();
  susanMesh.vertexNormals = susanJson['meshes'][0]['normals'];

  return susanMesh;
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
