import 'dart:html';
import 'src/application.dart';
import 'src/camera.dart';
import 'src/materials.dart';
import 'package:vector_math/vector_math.dart';
import 'src/mesh.dart';
import 'src/light.dart';
import 'src/texture.dart';
import 'src/utils.dart';
import 'dart:async';

Application application;

main() {
  CanvasElement canvas = querySelector('#glCanvas');
  application = new Application(canvas);

  application.setupScene(setupScene);

  //application.updateScene()
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
  application.ambientLight.color.setFrom(Gui.getAmbientColor());

  DirectionalLight directionalLight = new DirectionalLight()
    ..color.setFrom(Gui.getDirectionalColor())
    ..direction.setFrom(Gui.getDirectionalPosition());
  application.light = directionalLight;

  //Materials
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
  application.materials.add(materialBaseTextureNormal);

  //Meshes
//   create triangle
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
  await materialBaseTextureNormal.addTexture("images/crate.gif");
  cube.material = materialBaseTextureNormal;
  application.meshes.add(cube);

  materialBaseTextureNormal..useLighting = Gui.getUseLighting();


//  SusanModel
  Mesh susanMesh = await createSusanModel();
  application.meshes.add(susanMesh);

  //Animation
  num _lastTime = 0.0;
  application.updateScene((num time) {
    // rotate
    double animationStep = time - _lastTime;
    triangle.transform.rotateZ((radians(60.0) * animationStep) / 1000.0);
    squareX.transform.rotateX((radians(180.0) * animationStep) / 1000.0);
    pyramid..transform.rotateY((radians(90.0) * animationStep) / 1000.0);
    cube.transform.rotateY((radians(45.0) * animationStep) / 1000.0);
    _lastTime = time;

    materialBaseTextureNormal..useLighting = Gui.getUseLighting();

    application.ambientLight..color.setFrom(Gui.getAmbientColor());
    directionalLight
      ..direction.setFrom(Gui.getDirectionalPosition())
      ..color.setFrom(Gui.getDirectionalColor());
  });
}

Future createSusanModel() async {
  //SusanModel
  TextureMap susanTexture = await Utils.loadTextureMap('objects/susan/susan_texture.png');
  var susanJson = await Utils.loadJSONResource('objects/susan/susan.json');
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

class Gui {
  static bool getUseLighting() {
    InputElement elmLighting;
    elmLighting = querySelector("#lighting");
    return elmLighting.checked;
  }

  static Vector3 getDirectionalPosition() {
    //Div lighting
    InputElement elmLightDirectionX, elmLightDirectionY, elmLightDirectionZ;

    elmLightDirectionX = querySelector("#lightDirectionX");
    elmLightDirectionY = querySelector("#lightDirectionY");
    elmLightDirectionZ = querySelector("#lightDirectionZ");

    num dX = 0.0;
    num dY = 0.0;
    num dZ = 0.0;

    Vector3 directionalPosition;

    try {
      dX = double.parse(elmLightDirectionX.value);
      dY = double.parse(elmLightDirectionY.value);
      dZ = double.parse(elmLightDirectionZ.value);
      directionalPosition = new Vector3(dX, dY, dZ);
    } catch (exception) {}

    return directionalPosition;
  }

  static Vector3 getDirectionalColor() {
    //Div lighting
    InputElement elmDirectionalR, elmDirectionalG, elmDirectionalB;

    elmDirectionalR = querySelector("#directionalR");
    elmDirectionalG = querySelector("#directionalG");
    elmDirectionalB = querySelector("#directionalB");

    num dR = 0.0;
    num dG = 0.0;
    num dB = 0.0;

    Vector3 directionalColor;
    try {
      dR = double.parse(elmDirectionalR.value);
      dG = double.parse(elmDirectionalG.value);
      dB = double.parse(elmDirectionalB.value);
      directionalColor = new Vector3(dR, dG, dB);
    } catch (exception) {}

    return directionalColor;
  }

  static Vector3 getAmbientColor() {
    //Div lighting
    InputElement elmAmbientR, elmAmbientG, elmAmbientB;

    elmAmbientR = querySelector("#ambientR");
    elmAmbientG = querySelector("#ambientG");
    elmAmbientB = querySelector("#ambientB");

    num aR = 0.0;
    num aG = 0.0;
    num aB = 0.0;

    Vector3 ambientColor;

    try {
      aR = double.parse(elmAmbientR.value);
      aG = double.parse(elmAmbientG.value);
      aB = double.parse(elmAmbientB.value);
      ambientColor = new Vector3(aR, aG, aB);
    } catch (exception) {}

    return ambientColor;
  }
}
