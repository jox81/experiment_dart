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
    AxisMesh axis = new AxisMesh();
    meshes.add(axis);

    PointMesh point = new PointMesh()
        ..translation = new Vector3(8.0, 5.0, 10.0)
    ..material = materialPoint;
    meshes.add(point);

    //Line
    MultiLineMesh line = new MultiLineMesh([
      new Vector3.all(0.0),
      new Vector3(10.0, 0.0, 0.0),
      new Vector3(10.0, 0.0, 10.0),
      new Vector3(10.0, 10.0, 10.0),
    ]);
    meshes.add(line);

    // create square
    QuadMesh square = new QuadMesh()
      ..matrix.translate(3.0, 0.0, 0.0)
      ..matrix.rotateX(radians(90.0))
      ..material = materialBaseColor;
    meshes.add(square);

    // create triangle
    TriangleMesh triangle = new TriangleMesh()
      ..name = 'triangle'
      ..matrix.translate(0.0, 0.0, 4.0)
      ..material = materialBase;
    meshes.add(triangle);

    // create cube
    CubeMesh centerCube = new CubeMesh()
      ..matrix.translate(0.0, 0.0, 0.0)
      ..matrix.scale(0.1, 0.1, 0.1)
      ..material = materialBaseColor;
    meshes.add(centerCube);

    // create square
    QuadMesh squareX = new QuadMesh()
      ..matrix.translate(0.0, 3.0, 0.0)
      ..material = materialBaseVertexColor;
    squareX.primitive
      ..colors = new List()
      ..colors.addAll([1.0, 0.0, 0.0, 1.0])
      ..colors.addAll([1.0, 1.0, 0.0, 1.0])
      ..colors.addAll([1.0, 0.0, 1.0, 1.0])
      ..colors.addAll([0.0, 1.0, 1.0, 1.0]);
    meshes.add(squareX);

    //create Pyramide
    PyramidMesh pyramid = new PyramidMesh()
      ..matrix.translate(7.0, 1.0, 0.0)
      ..material = materialBaseVertexColor;
    meshes.add(pyramid);

    //Create Cube
    CubeMesh cube = new CubeMesh();
    cube.matrix.translate(-4.0, 1.0, 0.0);
    materialBaseTextureNormal.texture =
    await TextureUtils.createTexture2DFromFile("./images/crate.gif");
    cube
      ..material = materialBaseTextureNormal
      ..addComponent(new TestAnim());

    meshes.add(cube);

    //SusanMesh
    var susanJson = await UtilsAssets.loadJSONResource('./objects/susan/susan.json');
    MaterialBaseTexture susanMaterialBaseTexture = new MaterialBaseTexture()
      ..texture = await TextureUtils.createTexture2DFromFile(
          './objects/susan/susan_texture.png');
    JsonObject jsonMesh = new JsonObject(susanJson)
      ..matrix.translate(10.0, 0.0, -5.0)
      ..matrix.rotateX(radians(-90.0))
      ..material = susanMaterialBaseTexture
      ..addComponent(new TestAnim());
    meshes.add(jsonMesh);

    //Sphere
    SphereMesh sphere = new SphereMesh(radius: 2.5, segmentV: 48, segmentH: 48)
      ..matrix.translate(0.0, 0.0, -10.0)
      ..material = materialPBR;
    //sphere.mode = RenderingContext.LINES;
    meshes.add(sphere);

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
