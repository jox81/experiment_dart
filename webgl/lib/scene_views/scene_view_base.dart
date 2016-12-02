import 'dart:async';
import 'dart:math';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/animation_property.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/globals/context.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/light.dart';
import 'package:webgl/src/texture_utils.dart';
import 'package:webgl/src/utils.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/interface/IScene.dart';

class SceneViewBase extends Scene{

  /// implements ISceneViewBase
  Map<String, EditableProperty> get properties =>{
    'fov' : new EditableProperty<num>(num, ()=> Context.mainCamera.fOV, (num v)=> Context.mainCamera.fOV = v),
    'camera Pos x' : new EditableProperty<num>(num, ()=> Context.mainCamera.position.x, (num v)=> Context.mainCamera.position.x = v),
    'camera Pos y' : new EditableProperty<num>(num, ()=> Context.mainCamera.position.y, (num v)=> Context.mainCamera.position.y = v),
    'camera Pos z' : new EditableProperty<num>(num, ()=> Context.mainCamera.position.z, (num v)=> Context.mainCamera.position.z = v),
    'useLighting' : new EditableProperty<bool>(bool, ()=> useLighting, (bool v)=> useLighting = v),
    'ambientColorR' : new EditableProperty<num>(num, ()=> ambientColor.r, (num v)=> ambientColor.r = v),
    'ambientColorG' : new EditableProperty<num>(num, ()=> ambientColor.g, (num v)=> ambientColor.g = v),
    'ambientColorB' : new EditableProperty<num>(num, ()=> ambientColor.b, (num v)=> ambientColor.b = v),
    'ambientColor' : new EditableProperty<Vector3>(Vector3, ()=> ambientColor, (Vector3 v)=> ambientColor = v),
    'directionalPositionX' : new EditableProperty<num>(num, ()=> directionalPosition.x, (num v)=> directionalPosition.x = v),
    'directionalPositionY' : new EditableProperty<num>(num, ()=> directionalPosition.y, (num v)=> directionalPosition.y = v),
    'directionalPositionZ' : new EditableProperty<num>(num, ()=> directionalPosition.z, (num v)=> directionalPosition.z = v),
    'directionalColorR' : new EditableProperty<num>(num, ()=> directionalColor.r, (num v)=> directionalColor.r = v),
    'directionalColorG' : new EditableProperty<num>(num, ()=> directionalColor.g, (num v)=> directionalColor.g = v),
    'directionalColorB' : new EditableProperty<num>(num, ()=> directionalColor.b, (num v)=> directionalColor.b = v),
    'addMesh' : new EditableProperty<Function>(Function, ()=> addMesh, null),
  };

  bool useLighting = true;
  Vector3 directionalPosition = new Vector3(-0.25,-0.125,-0.25);
  Vector3 ambientColor = new Vector3.all(0.0);
  Vector3 directionalColor = new Vector3(0.8, 0.8, 0.8);

  //

  SceneViewBase();

  @override
  UpdateFunction updateFunction;

  @override
  UpdateUserInput updateUserInputFunction;

  @override
  setupUserInput() {

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
    Context.mainCamera = new
    Camera(radians(37.0), 0.1, 1000.0)
      ..aspectRatio = Context.viewAspectRatio
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(20.0, 20.0, 20.0)
      ..cameraController = new CameraController();

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
    MaterialPoint materialPoint = new MaterialPoint(pointSize:4.0);
    materials.add(materialPoint);

    MaterialBase materialBase = new MaterialBase();
    materials.add(materialBase);

    MaterialBaseColor materialBaseColor = new MaterialBaseColor(
        new Vector4(1.0, 1.0, 0.0, 1.0));
    materials.add(materialBaseColor);

    MaterialBaseVertexColor materialBaseVertexColor = new MaterialBaseVertexColor();
    materials.add(materialBaseVertexColor);

    MaterialBaseTexture materialBaseTexture = new MaterialBaseTexture();
    materials.add(materialBaseTexture);

    MaterialBaseTextureNormal materialBaseTextureNormal =
    new MaterialBaseTextureNormal()
      ..ambientColor = ambientLight.color
      ..directionalLight = directionalLight;
    materialBaseTextureNormal..useLighting = useLighting;
    materials.add(materialBaseTextureNormal);

    MaterialPBR materialPBR = new MaterialPBR(pointLight);
    materials.add(materialPBR);

    //Meshes
    AxisModel axis = new AxisModel();
    models.add(axis);

    PointModel point = new PointModel()
        ..position.setValues(8.0, 5.0, 10.0);
    models.add(point);

    //Line
    MultiLineModel line = new MultiLineModel([
      new Vector3.all(0.0),
      new Vector3(10.0, 0.0, 0.0),
      new Vector3(10.0, 0.0, 10.0),
      new Vector3(10.0, 10.0, 10.0),
    ]);
    models.add(line);

    // create square
    QuadModel square = new QuadModel()
      ..transform.translate(3.0, 0.0, 0.0)
      ..transform.rotateX(radians(90.0))
      ..material = materialBaseColor;
    models.add(square);

    // create triangle
    TriangleModel triangle = new TriangleModel()
      ..name = 'triangle'
      ..transform.translate(0.0, 0.0, 4.0)
      ..material = materialBase;
    models.add(triangle);

    // create cube
    CubeModel centerCube = new CubeModel()
      ..transform.translate(0.0, 0.0, 0.0)
      ..transform.scale(0.1, 0.1, 0.1)
      ..material = materialBaseColor;
    models.add(centerCube);

    // create square
    QuadModel squareX = new QuadModel()
      ..transform.translate(0.0, 3.0, 0.0)
      ..material = materialBaseVertexColor;
    squareX.mesh
      ..colors = new List()
      ..colors.addAll([1.0, 0.0, 0.0, 1.0])
      ..colors.addAll([1.0, 1.0, 0.0, 1.0])
      ..colors.addAll([1.0, 0.0, 1.0, 1.0])
      ..colors.addAll([0.0, 1.0, 1.0, 1.0]);

    models.add(squareX);

    //create Pyramide
    PyramidModel pyramid = new PyramidModel()
      ..transform.translate(7.0, 1.0, 0.0)
      ..material = materialBaseVertexColor;
    models.add(pyramid);

    //Create Cube
    CubeModel cube = new CubeModel();
    cube.transform.translate(-4.0, 1.0, 0.0);
    materialBaseTextureNormal.texture =
    await TextureUtils.createTextureFromFile("../images/crate.gif");
    cube.material = materialBaseTextureNormal;
    models.add(cube);

    //SusanModel
    var susanJson = await Utils.loadJSONResource('../objects/susan/susan.json');
    MaterialBaseTexture susanMaterialBaseTexture = new MaterialBaseTexture()
      ..texture = await TextureUtils.createTextureFromFile(
          '../objects/susan/susan_texture.png');
    JsonObject jsonModel = new JsonObject(susanJson)
      ..transform.translate(10.0, 0.0, -5.0)
      ..transform.rotateX(radians(-90.0))
      ..material = susanMaterialBaseTexture;
    models.add(jsonModel);

    //Sphere
    SphereModel sphere = new SphereModel(radius: 2.5, segmentV: 48, segmentH: 48)
      ..transform.translate(0.0, 0.0, -10.0)
      ..material = materialPBR;
    //sphere.mode = GL.LINES;
    models.add(sphere);

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

  void addMesh(){

    Random random = new Random();

    // create cube
    CubeModel centerCube = new CubeModel()
      ..transform.translate(random.nextDouble() * 10, random.nextDouble() * 10, random.nextDouble() * 10)
      ..transform.scale(0.1, 0.1, 0.1)
      ..material = materials.firstWhere((m)=> m is MaterialBaseColor );
    models.add(centerCube);
  }

}
