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
  application.ambientLight.color.setFrom(guisetup.getAmbientColor);

  DirectionalLight directionalLight = new DirectionalLight()
    ..color.setFrom(guisetup.getDirectionalColor)
    ..direction.setFrom(guisetup.getDirectionalPosition);
  application.light = directionalLight;

  //Materials
  MaterialPoint materialPoint = new MaterialPoint(4.0);
  application.materials.add(materialPoint);

  MaterialBase materialBase = new MaterialBase();
  application.materials.add(materialBase);

  MaterialBaseColor materialBaseColor = new MaterialBaseColor(new Vector3(1.0, 1.0, 0.0));
  application.materials.add(materialBaseColor);

  MaterialBaseVertexColor materialBaseVertexColor = new MaterialBaseVertexColor();
  application.materials.add(materialBaseVertexColor);

  MaterialBaseTexture materialBaseTexture = new MaterialBaseTexture();
  application.materials.add(materialBaseTexture);

  MaterialBaseTextureNormal materialBaseTextureNormal =
  new MaterialBaseTextureNormal()
    ..ambientColor = application.ambientLight.color
    ..directionalLight = directionalLight;
  materialBaseTextureNormal..useLighting = guisetup.getUseLighting;
  application.materials.add(materialBaseTextureNormal);

  //Meshes
  // create triangle
  Mesh triangle = Mesh.createTriangle();
  triangle.transform.translate(0.0, 0.0, 4.0);
  triangle.material = materialBase;
  application.meshes.add(triangle);

  // create square
  Mesh square = Mesh.createRectangle();
  square.transform.translate(3.0, 0.0, 0.0);
  square.transform.rotateX(radians(90.0));
  square.material = materialBaseColor;
  application.meshes.add(square);

  // create cube
  Mesh centerCube = Mesh.createCube();
  centerCube.transform.translate(0.0, 0.0, 0.0);
  centerCube.transform.scale(0.05, 0.05, 0.05);
  centerCube.material = materialBaseColor;
  application.meshes.add(centerCube);

  // create square
  Mesh squareX = Mesh.createRectangle();
  squareX.transform.translate(0.0, 3.0, 0.0);
  squareX.colors = new List();
  squareX.colors.addAll([1.0, 0.0, 0.0, 1.0]);
  squareX.colors.addAll([1.0, 1.0, 0.0, 1.0]);
  squareX.colors.addAll([1.0, 0.0, 1.0, 1.0]);
  squareX.colors.addAll([0.0, 1.0, 1.0, 1.0]);
  squareX.material = materialBaseVertexColor;
  application.meshes.add(squareX);

  //create Pyramide
  Mesh pyramid = Mesh.createPyramid();
  pyramid.transform.translate(3.0, -2.0, 0.0);
  pyramid.material = materialBaseVertexColor;
  application.meshes.add(pyramid);

  //Create Cube
  Mesh cube = Mesh.createCube();
  cube.transform.translate(-4.0, 1.0, 0.0);
  await materialBaseTextureNormal.addTexture("../images/crate.gif");
  cube.material = materialBaseTextureNormal;
  application.meshes.add(cube);

  // SusanModel
  Mesh susanMesh = await createSusanModel();
  application.meshes.add(susanMesh);

  //Sphere
  Mesh sphere = Mesh.createSphere(radius:10.0, segmentV :1, segmentH: 3);
  sphere.transform.translate(0.0, 0.0, 0.0);
  sphere.material = materialPoint;
  sphere.mode = GL.POINTS;
  application.meshes.add(sphere);


  // Animation
  num _lastTime = 0.0;
  application.updateScene((num time) {
    // rotate
    double animationStep = time - _lastTime;
    triangle.transform.rotateZ((radians(60.0) * animationStep) / 1000.0);
    squareX.transform.rotateX((radians(180.0) * animationStep) / 1000.0);
    pyramid..transform.rotateY((radians(90.0) * animationStep) / 1000.0);
    cube.transform.rotateY((radians(45.0) * animationStep) / 1000.0);
    _lastTime = time;

    materialBaseTextureNormal..useLighting = guisetup.getUseLighting;

    application.ambientLight..color.setFrom(guisetup.getAmbientColor);
    directionalLight
      ..direction.setFrom(guisetup.getDirectionalPosition)
      ..color.setFrom(guisetup.getDirectionalColor);
  });
}

Future createSusanModel() async {
  //SusanModel
  TextureMap susanTexture = await Utils.loadTextureMap('../objects/susan/susan_texture.png');
  var susanJson = await Utils.loadJSONResource('../objects/susan/susan.json');
  Mesh susanMesh = new Mesh();
  susanMesh.transform.translate(5.0, 0.0, 0.0);
  susanMesh.transform.rotateX(radians(90.0));
  susanMesh.transform.rotateY(radians(180.0));
  susanMesh.vertices = susanJson['meshes'][0]['vertices'];
  susanMesh.indices = susanJson['meshes'][0]['faces']
      .expand((i) => i)
      .toList();
  susanMesh.textureCoords = susanJson['meshes'][0]['texturecoords'][0];
  susanMesh.vertexNormals = susanJson['meshes'][0]['normals'];
  MaterialBaseTexture susanMaterialBaseTexture = new MaterialBaseTexture()
    ..textureMap = susanTexture;
  application.materials.add(susanMaterialBaseTexture);
  susanMesh.material = susanMaterialBaseTexture;

  return susanMesh;
}

class GuiSetup {

  static GuiSetup setup() {
    //GUI
    GuiSetup guisetup = new GuiSetup();
    dat.GUI gui = new dat.GUI();
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
