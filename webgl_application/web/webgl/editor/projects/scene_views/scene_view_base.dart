import 'dart:async';
import 'dart:html';

import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/mesh.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/renderer/materials.dart';
import 'package:webgl/src/gltf/scene.dart';
import 'package:webgl/src/light/light.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/camera/camera.dart';
import 'package:webgl/src/textures/utils_textures.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

Future<GLTFProject> projectSceneViewBase() async {

  bool useLighting = true;

  GLTFProject project = new GLTFProject.create();
  GLTFScene scene = new GLTFScene()
      ..backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);
  project.scene = scene;

  // Todo (jpu) :
  //Cameras
  // field of view is 45°, width-to-height ratio, hide things closer than 0.1 or further than 100
  Context.mainCamera = new
  CameraPerspective(radians(37.0), 0.1, 1000.0)
    ..targetPosition = new Vector3.zero()
    ..translation = new Vector3(20.0, 20.0, 20.0);

  // Todo (jpu) :
  //Lights
  AmbientLight ambientLight = new AmbientLight()
    ..color = new Vector3(0.9, 0.9, 0.9);
  DirectionalLight directionalLight = new DirectionalLight()
    ..direction = new Vector3(-0.25,-0.125,-0.25)
    ..color = new Vector3(0.8, 0.8, 0.8);

//  PointLight pointLight = new PointLight()
//    ..color.setFrom(directionalLight.color)
//    ..translation = new Vector3(20.0, 20.0, 20.0);

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
    ..directionalLight = directionalLight
    ..useLighting = useLighting;
  //  project.materials.add(materialBaseTextureNormal); // Todo (jpu) : don't add ?

//  MaterialPragmaticPBR materialPBR = new MaterialPragmaticPBR(pointLight);
//  project.materials.add(materialBaseVertexColor); // Todo (jpu) : don't add ?

//  MaterialSAO materialSAO = new MaterialSAO();

  //Meshes

  // Todo (jpu) : problems with the axis not shown
//  GLTFMesh axisMesh = new GLTFMesh.axis()
//    ..primitives[0].material = materialBase;
//  GLTFNode nodeAxis = new GLTFNode()
//    ..mesh = axisMesh
//    ..translation = new Vector3(0.0, 0.0, -10.0);
//  scene.addNode(nodeAxis);

  //
  GLTFMesh pointMesh = new GLTFMesh.point()
  ..primitives[0].material = materialPoint;
  GLTFNode nodePoint = new GLTFNode()
    ..mesh = pointMesh
    ..translation = new Vector3(8.0, 5.0, 10.0);
  scene.addNode(nodePoint);

  //
  GLTFMesh meshLine = new GLTFMesh.line([
    new Vector3.all(0.0),
    new Vector3(10.0, 0.0, 0.0),
    new Vector3(10.0, 0.0, 10.0),
    new Vector3(10.0, 10.0, 10.0),
  ]);
  GLTFNode nodeLine = new GLTFNode()
    ..mesh = meshLine
    ..name = 'multiline'
    ..translation = new Vector3(-5.0, 0.0, -5.0);
  scene.addNode(nodeLine);

  //
  GLTFMesh meshTriangle = new GLTFMesh.triangle(meshPrimitiveInfos : new MeshPrimitiveInfos(useNormals: false))
    ..primitives[0].material = materialBase;
  GLTFNode nodeTriangle = new GLTFNode()
    ..mesh = meshTriangle
    ..name = 'triangle'
    ..translation = new Vector3(0.0, 0.0, 4.0);
  scene.addNode(nodeTriangle);

  //
  GLTFMesh meshQuad = new GLTFMesh.quad(meshPrimitiveInfos : new MeshPrimitiveInfos(useNormals: false))
    ..primitives[0].material = materialBaseColor;
  GLTFNode nodeQuad = new GLTFNode()
    ..mesh = meshQuad
    ..name = 'quad'
    ..matrix.translate(3.0, 0.0, 0.0)
    ..matrix.rotateX(radians(90.0));
  scene.addNode(nodeQuad);

  //
  GLTFMesh meshSquareX = new GLTFMesh.quad(meshPrimitiveInfos : new MeshPrimitiveInfos(useNormals: false))
    ..primitives[0].material = materialBaseVertexColor;
  GLTFNode nodeSquareX = new GLTFNode()
    ..mesh = meshSquareX
    ..name = 'squareX'
    ..matrix.translate(0.0, 3.0, 0.0)
    ..matrix.rotateX(radians(90.0));
  scene.addNode(nodeSquareX);
// Todo (jpu) : add vertex color
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
  GLTFMesh meshCenterCube = new GLTFMesh.cube(meshPrimitiveInfos : new MeshPrimitiveInfos(useNormals: false))
    ..primitives[0].material = materialBaseColor;
  GLTFNode nodeCenterCube = new GLTFNode()
    ..mesh = meshCenterCube
    ..name = 'cube'
    ..translation = new Vector3(0.0, 0.0, 0.0)
    ..scale = new Vector3(0.1, 0.1, 0.1);
  scene.addNode(nodeCenterCube);

  //
  GLTFMesh meshPyramid = new GLTFMesh.pyramid(meshPrimitiveInfos : new MeshPrimitiveInfos(useNormals: false))
    ..primitives[0].material = materialBaseVertexColor;
  GLTFNode nodePyramid = new GLTFNode()
    ..mesh = meshPyramid
    ..name = 'pyramid'
    ..matrix.translate(7.0, 1.0, 0.0);
  scene.addNode(nodePyramid);

  //
  Uri uriImage = new Uri.file("./projects/images/uv_grid.jpg");
  ImageElement imageUV = await TextureUtils.loadImage(uriImage.path);

  WebGLTexture texture = await TextureUtils.createTexture2DFromImageElement(imageUV)
    ..textureWrapS = TextureWrapType.REPEAT
    ..textureWrapT = TextureWrapType.REPEAT
    ..textureMatrix = new Matrix4.columns(
      new Vector4(2.0,1.0,0.0,-2.0),
      new Vector4(0.0,2.0,0.0,-2.0),
      new Vector4(0.0,0.0,1.0,0.0),
      new Vector4(0.0,0.0,0.0,1.0),
    ).transposed();

  materialBaseTextureNormal.texture = texture;

  GLTFMesh meshTexturedCube = new GLTFMesh.cube(meshPrimitiveInfos : new MeshPrimitiveInfos(useNormals: false))
    ..primitives[0].material = materialBaseTextureNormal;
  GLTFNode nodeCube = new GLTFNode()
    ..mesh = meshTexturedCube
    ..name = 'cube_textured'
    ..translation = new Vector3(-4.0, 1.0, 0.0)
    ..scale = new Vector3(1.0,1.0,1.0);
  scene.addNode(nodeCube);
  // Todo (jpu) : add component
//  nodeCube
//    ..addComponent(new TestAnim());

  // Todo (jpu) : add node from json
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
  //
  // Todo (jpu) : problems : see console
//  GLTFMesh meshSphere = new GLTFMesh.sphere(radius: 2.5, segmentV: 48, segmentH: 48, withNormals: false)
//    ..primitives[0].material = materialBaseVertexColor;
//  GLTFNode nodeSphere = new GLTFNode()
//    ..mesh = meshSphere
//    ..name = 'sphere'
//    ..matrix.translate(0.0, 0.0, -10.0);
//  scene.addNode(nodeSphere);

  // Todo (jpu) : render mode LINES
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
