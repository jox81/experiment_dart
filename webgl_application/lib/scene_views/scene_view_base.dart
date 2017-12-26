import 'dart:async';
import 'package:vector_math/vector_math.dart';
import 'package:webgl_application/scene_views/test_anim.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/light.dart';
import 'package:webgl/src/material/materials.dart';
import 'package:webgl/src/time/time.dart';
import 'package:webgl/src/geometry/mesh.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/utils/utils_assets.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
@MirrorsUsed(
    targets: const [
      SceneViewBase  ,
    ],
    override: '*')
import 'dart:mirrors';

class SceneViewBase extends Scene{

//  @override
//  bool isEditing = true;

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
    CameraPerspective(radians(37.0), 0.1, 1000.0)
      ..targetPosition = new Vector3.zero()
      ..translation = new Vector3(20.0, 20.0, 20.0);

    //Lights
    ambientLight.color.setFrom(ambientColor);

    DirectionalLight directionalLight = new DirectionalLight()
      ..color.setFrom(directionalColor)
      ..direction.setFrom(directionalColor);
    lights.add(directionalLight);

    PointLight pointLight = new PointLight()
      ..color.setFrom(directionalColor)
      ..translation = new Vector3(20.0, 20.0, 20.0);
    lights.add(pointLight);

    //Materials
    MaterialPoint materialPoint = new MaterialPoint(pointSize:5.0 ,color:new Vector4(1.0,1.0,0.0,1.0))
      ..name = "pointMat";
    materials.add(materialPoint);

    MaterialBase materialBase = new MaterialBase();
    materials.add(materialBase);

    MaterialBaseColor materialBaseColor = new MaterialBaseColor(
        new Vector4(1.0, 1.0, 0.0, 1.0));
    materials.add(materialBaseColor);

    MaterialBaseVertexColor materialBaseVertexColor = new MaterialBaseVertexColor();
    materials.add(materialBaseVertexColor);

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
        ..translation = new Vector3(8.0, 5.0, 10.0)
    ..material = materialPoint;
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
      ..matrix.translate(3.0, 0.0, 0.0)
      ..matrix.rotateX(radians(90.0))
      ..material = materialBaseColor;
    models.add(square);

    // create triangle
    TriangleModel triangle = new TriangleModel()
      ..name = 'triangle'
      ..matrix.translate(0.0, 0.0, 4.0)
      ..material = materialBase;
    models.add(triangle);

    // create cube
    CubeModel centerCube = new CubeModel()
      ..matrix.translate(0.0, 0.0, 0.0)
      ..matrix.scale(0.1, 0.1, 0.1)
      ..material = materialBaseColor;
    models.add(centerCube);

    // create square
    QuadModel squareX = new QuadModel()
      ..matrix.translate(0.0, 3.0, 0.0)
      ..material = materialBaseVertexColor;
    squareX.primitive
      ..colors = new List()
      ..colors.addAll([1.0, 0.0, 0.0, 1.0])
      ..colors.addAll([1.0, 1.0, 0.0, 1.0])
      ..colors.addAll([1.0, 0.0, 1.0, 1.0])
      ..colors.addAll([0.0, 1.0, 1.0, 1.0]);
    models.add(squareX);

    //create Pyramide
    PyramidModel pyramid = new PyramidModel()
      ..matrix.translate(7.0, 1.0, 0.0)
      ..material = materialBaseVertexColor;
    models.add(pyramid);

    //Create Cube
    CubeModel cube = new CubeModel();
    cube.matrix.translate(-4.0, 1.0, 0.0);
    materialBaseTextureNormal.texture =
    await TextureUtils.createTexture2DFromFile("./images/crate.gif");
    cube
      ..material = materialBaseTextureNormal
      ..addComponent(new TestAnim());

    models.add(cube);

    //SusanModel
    var susanJson = await UtilsAssets.loadJSONResource('./objects/susan/susan.json');
    MaterialBaseTexture susanMaterialBaseTexture = new MaterialBaseTexture()
      ..texture = await TextureUtils.createTexture2DFromFile(
          './objects/susan/susan_texture.png');
    JsonObject jsonModel = new JsonObject(susanJson)
      ..matrix.translate(10.0, 0.0, -5.0)
      ..matrix.rotateX(radians(-90.0))
      ..material = susanMaterialBaseTexture
      ..addComponent(new TestAnim());
    models.add(jsonModel);

    //Sphere
    SphereModel sphere = new SphereModel(radius: 2.5, segmentV: 48, segmentH: 48)
      ..matrix.translate(0.0, 0.0, -10.0)
      ..material = materialPBR;
    //sphere.mode = RenderingContext.LINES;
    models.add(sphere);

    //Animation
    updateSceneFunction = () {

      squareX.matrix.rotateX((radians(180.0) * Time.deltaTime) / 1000.0);
      pyramid.matrix.rotateY((radians(90.0) * Time.deltaTime) / 1000.0);

      materialBaseTextureNormal..useLighting = useLighting;

      ambientLight..color.setFrom(ambientColor);
      directionalLight
        ..direction.setFrom(directionalPosition)
        ..color.setFrom(directionalColor);

      //
    };

  }
}
