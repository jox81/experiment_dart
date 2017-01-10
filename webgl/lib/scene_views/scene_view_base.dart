import 'dart:async';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/light.dart';
import 'package:webgl/src/utils.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

class SceneViewBase extends Scene{

  SceneViewBase();

  @override
  Future setupScene() async {

    bool useLighting = true;
    Vector3 directionalPosition = new Vector3(-0.25,-0.125,-0.25);
    Vector3 ambientColor = new Vector3.all(0.0);
    Vector3 directionalColor = new Vector3(0.8, 0.8, 0.8);

    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

    //Cameras
    // field of view is 45°, width-to-height ratio, hide things closer than 0.1 or further than 100
    Context.mainCamera = new
    Camera(radians(37.0), 0.1, 1000.0)
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
        ..position = new Vector3(8.0, 5.0, 10.0);
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
    await TextureUtils.getTextureFromFile("./images/crate.gif");
    cube.material = materialBaseTextureNormal;
    models.add(cube);

    //SusanModel
    var susanJson = await Utils.loadJSONResource('./objects/susan/susan.json');
    MaterialBaseTexture susanMaterialBaseTexture = new MaterialBaseTexture()
      ..texture = await TextureUtils.getTextureFromFile(
          './objects/susan/susan_texture.png');
    JsonObject jsonModel = new JsonObject(susanJson)
      ..transform.translate(10.0, 0.0, -5.0)
      ..transform.rotateX(radians(-90.0))
      ..material = susanMaterialBaseTexture;
    models.add(jsonModel);

    //Sphere
    SphereModel sphere = new SphereModel(radius: 2.5, segmentV: 48, segmentH: 48)
      ..transform.translate(0.0, 0.0, -10.0)
      ..material = materialPBR;
    //sphere.mode = RenderingContext.LINES;
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
}
