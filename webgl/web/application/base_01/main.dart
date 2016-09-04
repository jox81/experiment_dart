import 'dart:html';
import 'dart:async';
import 'package:vector_math/vector_math.dart';
import 'package:datgui/datgui.dart' as dat;
import 'package:webgl/src/application.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/mesh.dart';
import 'package:webgl/src/light.dart';
import 'package:webgl/src/texture_utils.dart';
import 'package:webgl/src/utils.dart';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:webgl/src/primitives.dart';
import 'dart:web_gl';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/interaction.dart';

main() async {
  CanvasElement canvas = querySelector('#glCanvas');
  Application application = new Application(canvas);

  SceneView sceneView = new SceneView(application.viewAspectRatio);
  await sceneView.setupScene();

  application.render(sceneView.scene);
}

class SceneView {

  Scene scene;
  num viewAspectRatio;

  SceneView(this.viewAspectRatio) {
    scene = new Scene();
  }

  Future setupScene() async {
    Interaction interaction = new Interaction(scene);
    //GUI
    GuiSetup guisetup = GuiSetup.setup();

    scene.backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

    //Cameras
    // field of view is 45°, width-to-height ratio, hide things closer than 0.1 or further than 100
    Camera camera =
    new Camera(radians(37.0), 0.1, 1000.0)
      ..aspectRatio = viewAspectRatio
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(50.0, 50.0, 50.0)
      ..cameraController = new CameraController();
    scene.mainCamera = camera;

    //Lights
    scene.ambientLight.color.setFrom(guisetup.getAmbientColor);

    DirectionalLight directionalLight = new DirectionalLight()
      ..color.setFrom(guisetup.getDirectionalColor)
      ..direction.setFrom(guisetup.getDirectionalPosition);
    scene.light = directionalLight;

    PointLight pointLight = new PointLight()
      ..color.setFrom(guisetup.getDirectionalColor)
      ..position = new Vector3(20.0, 20.0, 20.0);
    scene.light = pointLight;

    //Materials
    MaterialPoint materialPoint = await MaterialPoint.create(4.0);
    scene.materials.add(materialPoint);

    MaterialBase materialBase = await MaterialBase.create();
    scene.materials.add(materialBase);

    MaterialBaseColor materialBaseColor = await MaterialBaseColor.create(
        new Vector3(1.0, 1.0, 0.0));
    scene.materials.add(materialBaseColor);

    MaterialBaseVertexColor materialBaseVertexColor = await MaterialBaseVertexColor
        .create();
    scene.materials.add(materialBaseVertexColor);

    MaterialBaseTexture materialBaseTexture = await MaterialBaseTexture
        .create();
    scene.materials.add(materialBaseTexture);

    MaterialBaseTextureNormal materialBaseTextureNormal =
    await MaterialBaseTextureNormal.create()
      ..ambientColor = scene.ambientLight.color
      ..directionalLight = directionalLight;
    materialBaseTextureNormal..useLighting = guisetup.getUseLighting;
    scene.materials.add(materialBaseTextureNormal);

    MaterialPBR materialPBR = await MaterialPBR.create(pointLight);
    scene.materials.add(materialPBR);

    //Meshes
    Mesh axis = await createAxis(scene);

    // create triangle
    Mesh triangle = new Mesh.Triangle();
    triangle.transform.translate(0.0, 0.0, 4.0);
    triangle.material = materialBase;
    scene.meshes.add(triangle);

    // create square
    Mesh square = new Mesh.Rectangle();
    square.transform.translate(3.0, 0.0, 0.0);
    square.transform.rotateX(radians(90.0));
    square.material = materialBaseColor;
    scene.meshes.add(square);

    // create cube
    Mesh centerCube = new Mesh.Cube();
    centerCube.transform.translate(0.0, 0.0, 0.0);
    centerCube.transform.scale(0.1, 0.1, 0.1);
    centerCube.material = materialBaseColor;
    scene.meshes.add(centerCube);

    // create square
    Mesh squareX = new Mesh.Rectangle();
    squareX.transform.translate(0.0, 3.0, 0.0);
    squareX.colors = new List();
    squareX.colors.addAll([1.0, 0.0, 0.0, 1.0]);
    squareX.colors.addAll([1.0, 1.0, 0.0, 1.0]);
    squareX.colors.addAll([1.0, 0.0, 1.0, 1.0]);
    squareX.colors.addAll([0.0, 1.0, 1.0, 1.0]);
    squareX.material = materialBaseVertexColor;
    scene.meshes.add(squareX);

    //create Pyramide
    Mesh pyramid = new Mesh.Pyramid();
    pyramid.transform.translate(3.0, -2.0, 0.0);
    pyramid.material = materialBaseVertexColor;
    scene.meshes.add(pyramid);

    //Create Cube
    Mesh cube = new Mesh.Cube();
    cube.transform.translate(-4.0, 1.0, 0.0);
    materialBaseTextureNormal.texture =
    await TextureUtils.createTextureFromFile("../images/crate.gif");
    cube.material = materialBaseTextureNormal;
    scene.meshes.add(cube);

    //SusanModel
    var susanJson = await Utils.loadJSONResource('../objects/susan/susan.json');
    Mesh susanMesh = new Mesh();
    susanMesh.transform.translate(10.0, 0.0, 0.0);
    susanMesh.transform.rotateX(radians(-90.0));
    susanMesh.vertices = susanJson['meshes'][0]['vertices'];
    susanMesh.indices = susanJson['meshes'][0]['faces']
        .expand((i) => i)
        .toList();
    susanMesh.textureCoords = susanJson['meshes'][0]['texturecoords'][0];
    susanMesh.vertexNormals = susanJson['meshes'][0]['normals'];
    MaterialBaseTexture susanMaterialBaseTexture = await MaterialBaseTexture
        .create()
      ..texture = await TextureUtils.createTextureFromFile(
          '../objects/susan/susan_texture.png');
    susanMesh.material = susanMaterialBaseTexture;
    scene.materials.add(susanMaterialBaseTexture);
    scene.meshes.add(susanMesh);

    //Sphere
    Mesh sphere = new Mesh.Sphere(radius: 2.5, segmentV: 48, segmentH: 48);
    sphere.transform.translate(0.0, 0.0, -10.0);
    sphere.material = materialPBR;
    //sphere.mode = GL.LINES;
    scene.meshes.add(sphere);

    // Animation
    num _lastTime = 0.0;
    scene.updateFunction = (num time) {
      double animationStep = time - _lastTime;
      //Do Animation here

      interaction.update(time);
      triangle.transform.rotateZ((radians(60.0) * animationStep) / 1000.0);
      squareX.transform.rotateX((radians(180.0) * animationStep) / 1000.0);
      pyramid..transform.rotateY((radians(90.0) * animationStep) / 1000.0);
      cube.transform.rotateY((radians(45.0) * animationStep) / 1000.0);

      materialBaseTextureNormal..useLighting = guisetup.getUseLighting;

      scene.ambientLight..color.setFrom(guisetup.getAmbientColor);
      directionalLight
        ..direction.setFrom(guisetup.getDirectionalPosition)
        ..color.setFrom(guisetup.getDirectionalColor);

      //
      _lastTime = time;
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
