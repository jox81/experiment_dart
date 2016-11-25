import 'dart:async';
import 'dart:math';
import 'package:vector_math/vector_math.dart';
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

class SceneViewBase extends Scene implements IEditScene{

  /// implements ISceneViewBase
  Map<String, EditableProperty> get properties =>{
    'fov' : new EditableProperty<num>(()=> mainCamera.fOV, (num v)=> mainCamera.fOV = v),
    'camera Pos x' : new EditableProperty<num>(()=> mainCamera.position.x, (num v)=> mainCamera.position.x = v),
    'camera Pos y' : new EditableProperty<num>(()=> mainCamera.position.y, (num v)=> mainCamera.position.y = v),
    'camera Pos z' : new EditableProperty<num>(()=> mainCamera.position.z, (num v)=> mainCamera.position.z = v),
    'useLighting' : new EditableProperty<bool>(()=> useLighting, (bool v)=> useLighting = v),
    'ambientColorR' : new EditableProperty<num>(()=> ambientColor.r, (num v)=> ambientColor.r = v),
    'ambientColorG' : new EditableProperty<num>(()=> ambientColor.g, (num v)=> ambientColor.g = v),
    'ambientColorB' : new EditableProperty<num>(()=> ambientColor.b, (num v)=> ambientColor.b = v),
    'ambientColor' : new EditableProperty<Vector3>(()=> ambientColor, (Vector3 v)=> ambientColor = v),
    'directionalPositionX' : new EditableProperty<num>(()=> directionalPosition.x, (num v)=> directionalPosition.x = v),
    'directionalPositionY' : new EditableProperty<num>(()=> directionalPosition.y, (num v)=> directionalPosition.y = v),
    'directionalPositionZ' : new EditableProperty<num>(()=> directionalPosition.z, (num v)=> directionalPosition.z = v),
    'directionalColorR' : new EditableProperty<num>(()=> directionalColor.r, (num v)=> directionalColor.r = v),
    'directionalColorG' : new EditableProperty<num>(()=> directionalColor.g, (num v)=> directionalColor.g = v),
    'directionalColorB' : new EditableProperty<num>(()=> directionalColor.b, (num v)=> directionalColor.b = v),
    'addMesh' : new EditableProperty<Function>(()=> addMesh, null),
  };

  bool useLighting = true;
  Vector3 directionalPosition = new Vector3(-0.25,-0.125,-0.25);
  Vector3 ambientColor = new Vector3.all(0.0);
  Vector3 directionalColor = new Vector3(0.8, 0.8, 0.8);

  //

  num get viewAspectRatio => application.viewAspectRatio;

  SceneViewBase(Application application): super(application);

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
    Camera camera = await
    Camera.create(radians(37.0), 0.1, 1000.0)
      ..aspectRatio = viewAspectRatio
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(100.0, 50.0, 0.0)
      ..cameraController = new CameraController(gl.canvas);
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
    MaterialPoint materialPoint = new MaterialPoint(4.0);
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

    Mesh point = await createPoint(materialPoint)
      ..transform.translate(8.0, 5.0, 10.0);
    meshes.add(point);

    //Line
    Mesh line = new Mesh.Line([
      new Vector3.all(0.0),
      new Vector3(10.0, 0.0, 0.0),
      new Vector3(10.0, 0.0, 10.0),
      new Vector3(10.0, 10.0, 10.0),
    ])
    ..material = materialBaseColor;
    meshes.add(line);

    // create square
    Mesh square = new Mesh.Rectangle()
      ..transform.translate(3.0, 0.0, 0.0)
      ..transform.rotateX(radians(90.0))
      ..material = materialBaseColor;
    meshes.add(square);

    // create triangle
    Mesh triangle = new Mesh.Triangle()
      ..name = 'triangle'
      ..transform.translate(0.0, 0.0, 4.0)
      ..material = materialBase;
    meshes.add(triangle);

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
//      ..transform.rotateX(radians(-90.0))
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

  void addMesh(){

    Random random = new Random();

    // create cube
    Mesh centerCube = new Mesh.Cube()
      ..transform.translate(random.nextDouble() * 10, random.nextDouble() * 10, random.nextDouble() * 10)
      ..transform.scale(0.1, 0.1, 0.1)
      ..material = materials.firstWhere((m)=> m is MaterialBaseColor );
    meshes.add(centerCube);
  }

}
