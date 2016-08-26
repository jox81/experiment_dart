import 'dart:html';
import 'package:webgl/src/application.dart';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/mesh.dart';
import 'package:webgl/src/camera.dart';
import 'dart:async';

Application application;

main() {
  CanvasElement canvas = querySelector('#glCanvas');
  canvas.width = document.body.clientWidth;
  canvas.height = document.body.clientHeight;

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
    ..position = new Vector3(20.0, 30.0, -50.0)
    ..cameraController = new CameraControllerOrbit();
  application.mainCamera = camera;

  //Material
  MaterialPoint materialPoint = await MaterialPoint.create(5.0);
  application.materials.add(materialPoint);

  MaterialBase materialBase = await MaterialBase.create();
  application.materials.add(materialBase);

  Mesh axis = await createAxis();
  Mesh points = await createPoints(materialPoint);

  Mesh axis2 = await createAxis()
  ..transform.translate(5.0,0.0,0.0);

  // create cube
  Mesh centerCube = new Mesh.Cube()
  ..mode = GL.LINE_STRIP;
  centerCube.transform = axis2.transform;
  centerCube.material = materialBase;
  application.meshes.add(centerCube);

  //Animation
  num _lastTime = 0.0;
  application.updateScene((num time) {
    // rotate
    double animationStep = time - _lastTime;
    //... animation here
    _lastTime = time;
  });
}

//Points
Future<Mesh> createPoints(MaterialPoint materialPoint) async {

  //Material
  MaterialPoint materialPoint = await MaterialPoint.create(5.0);
  application.materials.add(materialPoint);

  Mesh mesh = new Mesh()
  ..mode = GL.POINTS
  ..vertices = [
    0.0,0.0,0.0,
    1.0,0.0,0.0,
    0.0,1.0,0.0,
    0.0,0.0,1.0,
  ]
  ..colors = [
    1.0,1.0,0.0,1.0,
    1.0,0.0,0.0,1.0,
    0.0,1.0,0.0,1.0,
    0.0,0.0,1.0,1.0,
  ]
  ..material = materialPoint;

  application.meshes.add(mesh);

  return mesh;
}

Future<Mesh> createAxis() async {

  //Material
  MaterialPoint materialPoint = await MaterialPoint.create(5.0);
  application.materials.add(materialPoint);

  Mesh mesh = new Mesh()
    ..mode = GL.LINES
    ..vertices = [
      0.0,0.0,0.0,
      1.0,0.0,0.0,
      0.0,0.0,0.0,
      0.0,1.0,0.0,
      0.0,0.0,0.0,
      0.0,0.0,1.0,
    ]
    ..colors = [
      1.0,0.0,0.0,1.0,
      1.0,0.0,0.0,1.0,
      0.0,1.0,0.0,1.0,
      0.0,1.0,0.0,1.0,
      0.0,0.0,1.0,1.0,
      0.0,0.0,1.0,1.0,
    ]
    ..material = materialPoint;

  application.meshes.add(mesh);

  return mesh;
}

