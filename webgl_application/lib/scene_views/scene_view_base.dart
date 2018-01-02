import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gtlf/mesh.dart';
import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/renderer/kronos_material.dart';
import 'package:webgl/src/gtlf/scene.dart';
import 'package:webgl_application/scene_views/test_anim.dart';
import 'package:webgl/src/camera/camera.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/light/light.dart';
import 'package:webgl/src/utils/utils_assets.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

GLTFProject projectSceneViewBase() {

  bool useLighting = true;

  GLTFProject project = new GLTFProject();
  GLTFScene scene = new GLTFScene()
      ..backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);
  project.addScene(scene);
  project.scene = scene;


  // Todo (jpu) :
  //Cameras
  // field of view is 45°, width-to-height ratio, hide things closer than 0.1 or further than 100
//  Context.mainCamera = new
//  CameraPerspective(radians(37.0), 0.1, 1000.0)
//    ..targetPosition = new Vector3.zero()
//    ..translation = new Vector3(20.0, 20.0, 20.0);

  // Todo (jpu) :
  //Lights
  AmbientLight ambientLight = new AmbientLight()
    ..color = new Vector3(0.9, 0.9, 0.9);
  DirectionalLight directionalLight = new DirectionalLight()
    ..direction = new Vector3(-0.25,-0.125,-0.25)
    ..color = new Vector3(0.8, 0.8, 0.8);
  project.lights.add(directionalLight);

  PointLight pointLight = new PointLight()
    ..color.setFrom(directionalLight.color)
    ..translation = new Vector3(20.0, 20.0, 20.0);
  project.lights.add(pointLight);

  //Materials
  MaterialPoint materialPoint = new MaterialPoint(pointSize:5.0, color:new Vector4(1.0,1.0,0.0,1.0))
    ..name = "pointMat";
//  project.materials.add(material); // Todo (jpu) : don't add ?

  MaterialBase materialBase = new MaterialBase();
//  project.materials.add(materialBase); // Todo (jpu) : don't add ?

  MaterialBaseColor materialBaseColor = new MaterialBaseColor(
      new Vector4(1.0, 1.0, 0.0, 1.0));
//  project.materials.add(materialBaseColor); // Todo (jpu) : don't add ?

  MaterialBaseVertexColor materialBaseVertexColor = new MaterialBaseVertexColor();
//  project.materials.add(materialBaseVertexColor); // Todo (jpu) : don't add ?

  MaterialBaseTextureNormal materialBaseTextureNormal =
  new MaterialBaseTextureNormal()
    ..ambientColor = ambientLight.color
    ..directionalLight = directionalLight;
  materialBaseTextureNormal..useLighting = useLighting;
  //  project.materials.add(materialBaseTextureNormal); // Todo (jpu) : don't add ?

  MaterialPragmaticPBR materialPBR = new MaterialPragmaticPBR(pointLight);
//  project.materials.add(materialBaseVertexColor); // Todo (jpu) : don't add ?

  //Meshes
  // Todo (jpu) :
//  AxisMesh axis = new AxisMesh();
//  meshes.add(axis);

  //
  GLTFMesh point = new GLTFMesh.point()
  ..primitives[0].material = materialPoint;
  project.meshes.add(point);
  GLTFNode nodePoint = new GLTFNode()
    ..mesh = point
    ..translation = new Vector3(8.0, 5.0, 10.0);;
  scene.addNode(nodePoint);
  project.addNode(nodePoint);

  //
  GLTFMesh meshLine = new GLTFMesh.line([
    new Vector3.all(0.0),
    new Vector3(10.0, 0.0, 0.0),
    new Vector3(10.0, 0.0, 10.0),
    new Vector3(10.0, 10.0, 10.0),
  ]);
  project.meshes.add(meshLine);
  GLTFNode nodeLine = new GLTFNode()
    ..mesh = meshLine
    ..name = 'multiline'
    ..translation = new Vector3(-5.0, 0.0, -5.0);
  scene.addNode(nodeLine);
  project.addNode(nodeLine);

  //
  GLTFMesh meshTriangle = new GLTFMesh.triangle(withNormals: false)
    ..primitives[0].material = materialBase;
  project.meshes.add(meshTriangle);
  GLTFNode nodeTriangle = new GLTFNode()
    ..mesh = meshTriangle
    ..name = 'triangle'
    ..translation = new Vector3(0.0, 0.0, 4.0);
  scene.addNode(nodeTriangle);
  project.addNode(nodeTriangle);

  //
  GLTFMesh meshQuad = new GLTFMesh.quad(withNormals: false)
    ..primitives[0].material = materialBaseColor;
  project.meshes.add(meshQuad);
  GLTFNode nodeQuad = new GLTFNode()
    ..mesh = meshQuad
    ..name = 'quad'
    ..matrix.translate(3.0, 0.0, 0.0)
    ..matrix.rotateX(radians(90.0));
  scene.addNode(nodeQuad);
  project.addNode(nodeQuad);

  //
  GLTFMesh meshCenterCube = new GLTFMesh.cube(withNormals: false)
    ..primitives[0].material = materialBaseColor;
  project.meshes.add(meshCenterCube);
  GLTFNode nodeCenterCube = new GLTFNode()
    ..mesh = meshCenterCube
    ..name = 'cube'
    ..translation = new Vector3(0.0, 0.0, 0.0)
    ..scale = new Vector3(0.1, 0.1, 0.1);
  scene.addNode(nodeCenterCube);
  project.addNode(nodeCenterCube);


  // create square
  GLTFMesh meshSquareX = new GLTFMesh.quad(withNormals: false)
    ..primitives[0].material = materialBaseVertexColor;
  project.meshes.add(meshSquareX);
  GLTFNode nodeSquareX = new GLTFNode()
    ..mesh = meshSquareX
    ..name = 'squareX'
    ..matrix.translate(0.0, 3.0, 0.0)
    ..matrix.rotateX(radians(90.0));
  scene.addNode(nodeSquareX);
  project.addNode(nodeSquareX);

//  QuadMesh squareX = new QuadMesh()
//    ..matrix.translate(0.0, 3.0, 0.0)
//    ..material = materialBaseVertexColor;
//  squareX.primitive
//    ..colors = new List()
//    ..colors.addAll([1.0, 0.0, 0.0, 1.0])
//    ..colors.addAll([1.0, 1.0, 0.0, 1.0])
//    ..colors.addAll([1.0, 0.0, 1.0, 1.0])
//    ..colors.addAll([0.0, 1.0, 1.0, 1.0]);
//  meshes.add(squareX);
//
//  //create Pyramide
//  PyramidMesh pyramid = new PyramidMesh()
//    ..matrix.translate(7.0, 1.0, 0.0)
//    ..material = materialBaseVertexColor;
//  meshes.add(pyramid);
//
//  //Create Cube
//  CubeMesh cube = new CubeMesh();
//  cube.matrix.translate(-4.0, 1.0, 0.0);
//  materialBaseTextureNormal.texture =
//  await TextureUtils.createTexture2DFromFile("./images/crate.gif");
//  cube
//    ..material = materialBaseTextureNormal
//    ..addComponent(new TestAnim());
//
//  meshes.add(cube);
//
//  //SusanMesh
//  var susanJson = await UtilsAssets.loadJSONResource('./objects/susan/susan.json');
//  MaterialBaseTexture susanMaterialBaseTexture = new MaterialBaseTexture()
//    ..texture = await TextureUtils.createTexture2DFromFile(
//        './objects/susan/susan_texture.png');
//  JsonObject jsonMesh = new JsonObject(susanJson)
//    ..matrix.translate(10.0, 0.0, -5.0)
//    ..matrix.rotateX(radians(-90.0))
//    ..material = susanMaterialBaseTexture
//    ..addComponent(new TestAnim());
//  meshes.add(jsonMesh);
//
//  //Sphere
//  SphereMesh sphere = new SphereMesh(radius: 2.5, segmentV: 48, segmentH: 48)
//    ..matrix.translate(0.0, 0.0, -10.0)
//    ..material = materialPBR;
//  //sphere.mode = RenderingContext.LINES;
//  meshes.add(sphere);

    // Todo (jpu) : ?
    //Animation
//    updateSceneFunction = () {
//
//      squareX.matrix.rotateX((radians(180.0) * Time.deltaTime) / 1000.0);
//      pyramid.matrix.rotateY((radians(90.0) * Time.deltaTime) / 1000.0);
//
//      materialBaseTextureNormal..useLighting = useLighting;
//
//      ambientLight..color.setFrom(ambientColor);
//      directionalLight
//        ..direction.setFrom(directionalPosition)
//        ..color.setFrom(directionalColor);
//
//      //
//    };

  return project;
}
