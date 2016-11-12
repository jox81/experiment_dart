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
import 'package:webgl/src/primitives.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/interface/IScene.dart';

class SceneViewBase extends Scene {

  bool isSetuped = false;

  final num viewAspectRatio;

  Vector3 directionalPosition;
  Vector3 ambientColor, directionalColor;

  bool useLighting;

  SceneViewBase(Application application):this.viewAspectRatio = application.viewAspectRatio, super();

  @override
  UpdateFunction updateFunction;

  @override
  UpdateUserInput updateUserInputFunction;

  @override
  setupUserInput() {

    GuiSetup guisetup = GuiSetup.setup();

    //UserInput
    updateUserInputFunction = (){
      ambientColor = guisetup.ambientColor;
      directionalColor = guisetup.directionalColor;
      directionalPosition = guisetup.directionalPosition;
      useLighting = guisetup.useLighting;

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
    new Camera(radians(37.0), 0.1, 1000.0)
      ..aspectRatio = viewAspectRatio
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(50.0, 50.0, 50.0)
      ..cameraController = new CameraController();
    mainCamera = camera;

    //Lights
    ambientLight.color.setFrom(ambientColor);

    DirectionalLight directionalLight = new DirectionalLight()
      ..color.setFrom(directionalColor)
      ..direction.setFrom(directionalColor);
    light = directionalLight;

    PointLight pointLight = new PointLight()
      ..color.setFrom(directionalColor)
      ..position = new Vector3(20.0, 20.0, 20.0);
    light = pointLight;

    //Materials
    MaterialPoint materialPoint = await MaterialPoint.create(4.0);
    materials.add(materialPoint);

    MaterialBase materialBase = await MaterialBase.create();
    materials.add(materialBase);

    MaterialBaseColor materialBaseColor = await MaterialBaseColor.create(
        new Vector3(1.0, 1.0, 0.0));
    materials.add(materialBaseColor);

    MaterialBaseVertexColor materialBaseVertexColor = await MaterialBaseVertexColor
        .create();
    materials.add(materialBaseVertexColor);

    MaterialBaseTexture materialBaseTexture = await MaterialBaseTexture
        .create();
    materials.add(materialBaseTexture);

    MaterialBaseTextureNormal materialBaseTextureNormal =
    await MaterialBaseTextureNormal.create()
      ..ambientColor = ambientLight.color
      ..directionalLight = directionalLight;
    materialBaseTextureNormal..useLighting = useLighting;
    materials.add(materialBaseTextureNormal);

    MaterialPBR materialPBR = await MaterialPBR.create(pointLight);
    materials.add(materialPBR);

    //Meshes
    Mesh axis = await createAxis(this)
      ..name = 'origin';

    // create triangle
    Mesh triangle = new Mesh.Triangle()
      ..name = 'triangle'
      ..transform.translate(0.0, 0.0, 4.0)
      ..material = materialBase;
    meshes.add(triangle);

    // create square
    Mesh square = new Mesh.Rectangle()
      ..transform.translate(3.0, 0.0, 0.0)
      ..transform.rotateX(radians(90.0))
      ..material = materialBaseColor;
    meshes.add(square);

    // create cube
    Mesh centerCube = new Mesh.Cube()
      ..transform.translate(0.0, 0.0, 0.0)
      ..transform.scale(0.1, 0.1, 0.1)
      ..material = materialBaseColor;
    meshes.add(centerCube);

    // create square
    Mesh squareX = new Mesh.Rectangle()
      ..transform.translate(0.0, 3.0, 0.0)
      ..colors = new List()
      ..colors.addAll([1.0, 0.0, 0.0, 1.0])
      ..colors.addAll([1.0, 1.0, 0.0, 1.0])
      ..colors.addAll([1.0, 0.0, 1.0, 1.0])
      ..colors.addAll([0.0, 1.0, 1.0, 1.0])
      ..material = materialBaseVertexColor;
    meshes.add(squareX);

    //create Pyramide
    Mesh pyramid = new Mesh.Pyramid()
      ..transform.translate(3.0, -2.0, 0.0)
      ..material = materialBaseVertexColor;
    meshes.add(pyramid);

    //Create Cube
    Mesh cube = new Mesh.Cube();
    cube.transform.translate(-4.0, 1.0, 0.0);
    materialBaseTextureNormal.texture =
    await TextureUtils.createTextureFromFile("../images/crate.gif");
    cube.material = materialBaseTextureNormal;
    meshes.add(cube);

    //SusanModel
    var susanJson = await Utils.loadJSONResource('../objects/susan/susan.json');
    Mesh susanMesh = new Mesh()
      ..transform.translate(10.0, 0.0, 0.0)
      ..transform.rotateX(radians(-90.0))
      ..vertices = susanJson['meshes'][0]['vertices']
      ..indices = susanJson['meshes'][0]['faces']
        .expand((i) => i)
        .toList()
      ..textureCoords = susanJson['meshes'][0]['texturecoords'][0]
      ..vertexNormals = susanJson['meshes'][0]['normals'];
    MaterialBaseTexture susanMaterialBaseTexture = await MaterialBaseTexture
        .create()
      ..texture = await TextureUtils.createTextureFromFile(
          '../objects/susan/susan_texture.png');
    susanMesh.material = susanMaterialBaseTexture;
    materials.add(susanMaterialBaseTexture);
    meshes.add(susanMesh);

    //Sphere
    Mesh sphere = new Mesh.Sphere(radius: 2.5, segmentV: 48, segmentH: 48)
      ..transform.translate(0.0, 0.0, -10.0)
      ..material = materialPBR;
    //sphere.mode = GL.LINES;
    meshes.add(sphere);

    //Animation
    num _lastTime = 0.0;
    updateFunction = (num time) {
      double animationStep = time - _lastTime;
      //Do Animation here

      triangle.transform.rotateZ((radians(60.0) * animationStep) / 1000.0);
      squareX.transform.rotateX((radians(180.0) * animationStep) / 1000.0);
      pyramid..transform.rotateY((radians(90.0) * animationStep) / 1000.0);
      cube.transform.rotateY((radians(45.0) * animationStep) / 1000.0);

      materialBaseTextureNormal..useLighting = useLighting;

      ambientLight..color.setFrom(ambientColor);
      directionalLight
        ..direction.setFrom(directionalPosition)
        ..color.setFrom(directionalColor);

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
    gui.add(guisetup, 'useLighting');

    dat.GUI f2 = gui.addFolder("Lighting Position");
    f2.add(guisetup, 'directionalPositionX',-100.0,100.0);
    f2.add(guisetup, 'directionalPositionY',-100.0,100.0);
    f2.add(guisetup, 'directionalPositionZ',-100.0,100.0);

    dat.GUI directionalColor = gui.addFolder("Directionnal color");
    directionalColor.add(guisetup, 'directionalColorR',0.001,1.001);//needed until now to round 0 int or 1 int to double
    directionalColor.add(guisetup, 'directionalColorG',0.001,1.001);
    directionalColor.add(guisetup, 'directionalColorB',0.001,1.001);

    dat.GUI ambiantColor = gui.addFolder("Ambiant color");
    ambiantColor.add(guisetup, 'directionalColorR',0.001,1.001);//needed until now to round 0 int or 1 int to double
    ambiantColor.add(guisetup, 'directionalColorG',0.001,1.001);
    ambiantColor.add(guisetup, 'directionalColorB',0.001,1.001);

    return guisetup;
  }

  String message = '';
  bool useLighting = true;

  Vector3 directionalPosition = new Vector3(-0.25,-0.125,-0.25);
  double get directionalPositionX => directionalPosition.x;
  set directionalPositionX(double value){ directionalPosition.x = value;}
  double get directionalPositionY => directionalPosition.y;
  set directionalPositionY(double value){ directionalPosition.y = value;}
  double get directionalPositionZ => directionalPosition.z;
  set directionalPositionZ(double value){ directionalPosition.z = value;}

  Vector3 directionalColor = new Vector3(0.8, 0.8, 0.8);
  double get directionalColorR => directionalColor.r;
  set directionalColorR(double value){ directionalColor.r = value;}
  double get directionalColorG => directionalColor.g;
  set directionalColorG(double value){ directionalColor.g = value;}
  double get directionalColorB => directionalColor.b;
  set directionalColorB(double value){ directionalColor.b = value;}

  Vector3 ambientColor = new Vector3(0.2,0.2,0.2);
  double get ambientColorR => ambientColor.r;
  set ambientColorR(double value){ ambientColor.r = value;}
  double get ambientColorG => ambientColor.g;
  set ambientColorG(double value){ ambientColor.g = value;}
  double get ambientColorB => ambientColor.b;
  set ambientColorB(double value){ ambientColor.b = value;}

}
