import 'dart:async';
import 'package:vector_math/vector_math.dart';
//import 'package:datgui/datgui.dart' as dat;
import 'package:webgl/src/animation_property.dart';
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

abstract class IEditScene{
  Map<String, AnimationProperty> get properties;
}

class SceneViewBase extends Scene implements IEditScene{

  /// implements ISceneViewBase
  String message = 'test';
  int count = 0;
  Map<String, AnimationProperty> get properties =>{
    'message' : new AnimationProperty<String>(()=> message, (String v)=> message = v),
    'count' : new AnimationProperty<int>(()=> count, (int v)=> count = v),
    'useLighting' : new AnimationProperty<bool>(()=> useLighting, (bool v)=> useLighting = v),
    'ambientColorR' : new AnimationProperty<num>(()=> ambientColor.r, (num v)=> ambientColor.r = v),
    'ambientColorG' : new AnimationProperty<num>(()=> ambientColor.g, (num v)=> ambientColor.g = v),
    'ambientColorB' : new AnimationProperty<num>(()=> ambientColor.b, (num v)=> ambientColor.b = v),
    'directionalPositionX' : new AnimationProperty<num>(()=> directionalPosition.x, (num v)=> directionalPosition.x = v),
    'directionalPositionY' : new AnimationProperty<num>(()=> directionalPosition.y, (num v)=> directionalPosition.y = v),
    'directionalPositionZ' : new AnimationProperty<num>(()=> directionalPosition.z, (num v)=> directionalPosition.z = v),
    'directionalColorR' : new AnimationProperty<num>(()=> directionalColor.r, (num v)=> directionalColor.r = v),
    'directionalColorG' : new AnimationProperty<num>(()=> directionalColor.g, (num v)=> directionalColor.g = v),
    'directionalColorB' : new AnimationProperty<num>(()=> directionalColor.b, (num v)=> directionalColor.b = v),
  };

  //


  bool useLighting = true;
  Vector3 directionalPosition = new Vector3(-0.25,-0.125,-0.25);
  Vector3 ambientColor = new Vector3.all(0.0);
  Vector3 directionalColor = new Vector3(0.8, 0.8, 0.8);

  final num viewAspectRatio;

  SceneViewBase(Application application):this.viewAspectRatio = application.viewAspectRatio, super();

  @override
  UpdateFunction updateFunction;

  @override
  UpdateUserInput updateUserInputFunction;

//  GuiSetup guisetup;

  @override
  setupUserInput() {

//    guisetup = GuiSetup.setup(this);

    //UserInput
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

//class GuiSetup {
//
//  static SceneViewBase _scene;
//
//  static GuiSetup setup(SceneViewBase scene) {
//    _scene = scene;
//
//    //GUI
//    GuiSetup guisetup = new GuiSetup();
//    dat.GUI gui = new dat.GUI();
//    gui.add(guisetup, 'message');
//
//    dat.GUI f2 = gui.addFolder("Lighting Position");
//    f2.add(guisetup, 'directionalPositionX',-100.0,100.0);
//    f2.add(guisetup, 'directionalPositionY',-100.0,100.0);
//    f2.add(guisetup, 'directionalPositionZ',-100.0,100.0);
//
//    dat.GUI directionalColor = gui.addFolder("Directionnal color");
//    directionalColor.add(guisetup, 'directionalColorR',0.001,1.001);//needed until now to round 0 int or 1 int to double
//    directionalColor.add(guisetup, 'directionalColorG',0.001,1.001);
//    directionalColor.add(guisetup, 'directionalColorB',0.001,1.001);
//
//    return guisetup;
//  }
//
//
//}
