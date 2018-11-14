import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/material.dart';
import 'package:webgl/src/gltf/mesh.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/pbr_metallic_roughness.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/renderer/materials.dart';
import 'package:webgl/src/gltf/scene.dart';
import 'package:webgl/src/textures/utils_textures.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
import 'package:webgl/src/light/light.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/camera/camera.dart';

Future<GLTFProject> projectPrimitives() async {
  GLTFProject project = new GLTFProject.create()..baseDirectory = 'primitives/';

  GLTFScene scene = new GLTFScene();
  scene.backgroundColor = new Vector4(0.8, 0.2, 1.0, 1.0);// Todo (jpu) : ?
  project.addScene(scene);
  project.scene = scene;

  Context.mainCamera = new
  CameraPerspective(radians(37.0), 0.1, 1000.0)
    ..targetPosition = new Vector3.zero()
    ..translation = new Vector3(20.0, 20.0, 20.0);

  GLTFPBRMaterial baseMaterial = getTestGLTFPBRMaterial();
  RawMaterial material = await getTestRawMaterial();

//  project.materials.add(material); // Todo (jpu) : don't add ?

  MaterialPoint materialPoint = new MaterialPoint(pointSize:10.0, color:new Vector4(0.0, 0.66, 1.0, 1.0));

  GLTFMesh meshPoint = new GLTFMesh.point()
    ..primitives[0].material = materialPoint;
  project.meshes.add(meshPoint);
  GLTFNode nodePoint = new GLTFNode()
    ..mesh = meshPoint
    ..name = 'point'
    ..translation = new Vector3(5.0, 0.0, 0.0);
  scene.addNode(nodePoint);
  project.addNode(nodePoint);

  // Todo (jpu) :This doesn't show, use another material ? what material doesn't work ?
  GLTFMesh meshLine = new GLTFMesh.line([
    new Vector3.all(0.0),
    new Vector3(10.0, 0.0, 0.0),
    new Vector3(10.0, 0.0, 10.0),
    new Vector3(10.0, 10.0, 10.0),
  ])
    ..primitives[0].material = material;
  project.meshes.add(meshLine);
  GLTFNode nodeLine = new GLTFNode()
    ..mesh = meshLine
    ..name = 'multiline'
    ..translation = new Vector3(-5.0, 0.0, -5.0);
  scene.addNode(nodeLine);
  project.addNode(nodeLine);

  GLTFMesh meshTriangle = new GLTFMesh.triangle()
    ..primitives[0].material = material;
  project.meshes.add(meshTriangle);
  GLTFNode nodeTriangle = new GLTFNode()
    ..mesh = meshTriangle
    ..name = 'triangle'
    ..translation = new Vector3(0.0, 0.0, -5.0);
  scene.addNode(nodeTriangle);
  project.addNode(nodeTriangle);

  GLTFMesh meshQuad = new GLTFMesh.quad()
    ..primitives[0].material = material;
  project.meshes.add(meshQuad);
  GLTFNode nodeQuad = new GLTFNode()
    ..mesh = meshQuad
    ..name = 'quad'
    ..translation = new Vector3(5.0, 0.0, -5.0);
  scene.addNode(nodeQuad);
  project.addNode(nodeQuad);

  GLTFMesh meshPyramid = new GLTFMesh.pyramid()
    ..primitives[0].material = material;
  project.meshes.add(meshPyramid);
  GLTFNode nodePyramid = new GLTFNode()
    ..mesh = meshPyramid
    ..name = 'pyramid'
    ..translation = new Vector3(-5.0, 0.0, 0.0);
  scene.addNode(nodePyramid);
  project.addNode(nodePyramid);

  GLTFMesh meshCube = new GLTFMesh.cube()
    ..primitives[0].material = material;
  project.meshes.add(meshCube);
  GLTFNode nodeCube = new GLTFNode()
    ..mesh = meshCube
    ..name = 'cube'
    ..translation = new Vector3(0.0, 0.0, 0.0);
  scene.addNode(nodeCube);
  project.addNode(nodeCube);

  // Todo (jpu) : bug with other primitives with MaterialBaseVertexColor
  GLTFMesh meshSphere = new GLTFMesh.sphere(meshPrimitiveInfos : new MeshPrimitiveInfos(useColors: false))
    ..primitives[0].material = material;
  project.meshes.add(meshSphere);
  GLTFNode nodeSphere = new GLTFNode()
    ..mesh = meshSphere
    ..name = 'sphere'
    ..translation = new Vector3(5.0, 0.0, 0.0);
  scene.addNode(nodeSphere);
  project.addNode(nodeSphere);

  return project;
}

GLTFPBRMaterial getTestGLTFPBRMaterial() {

  GLTFPBRMaterial baseMaterial;
  baseMaterial = new GLTFPBRMaterial(
      pbrMetallicRoughness: new GLTFPbrMetallicRoughness(
          baseColorFactor: new Float32List.fromList([1.0,1.0,1.0,1.0]),
          baseColorTexture: null,//GLTFTextureInfo.createTexture(project, 'testTexture.png'),
          metallicFactor: 0.0,
          roughnessFactor: 1.0
      )
  );
  //  project.materials.add(baseMaterial);

  return baseMaterial;
}

Future<RawMaterial> getTestRawMaterial() async {

  AmbientLight ambientLight = new AmbientLight()
    ..color = new Vector3(1.0,1.0,1.0);
  DirectionalLight directionalLight = new DirectionalLight()
    ..direction = new Vector3(-0.25,-0.125,-0.25)
    ..color = new Vector3(0.8, 0.8, 0.8);

  PointLight pointLight = new PointLight()
  ..color.setFrom(directionalLight.color)
  ..translation = new Vector3(20.0, 20.0, 20.0);

  bool useLighting = true;

  Uri uriImage = new Uri.file("./projects/images/uv_grid.jpg");
  ImageElement imageUV = await TextureUtils.loadImage(uriImage.path);
  WebGLTexture texture = await TextureUtils.createTexture2DFromImageElement(imageUV)
    ..textureWrapS = TextureWrapType.REPEAT
    ..textureWrapT = TextureWrapType.REPEAT;

  List<List<ImageElement>> cubeMapImages =
  await TextureUtils.loadCubeMapImages('pisa');
  WebGLTexture cubeMapTexture =
  TextureUtils.createCubeMapFromImages(cubeMapImages, flip: false);

  RawMaterial material;

//  material = new MaterialBase();

//  material = new MaterialBaseColor(new Vector4(1.0, 0.0, 0.0, 1.0));

//  material = new MaterialBaseVertexColor();
//  material = new MaterialBaseTexture()..texture = texture;

  material = new MaterialReflection()..skyboxTexture = cubeMapTexture;

  // Todo (jpu) : test changing lights
//  material = new MaterialBaseTextureNormal()
//    ..texture = texture
//    ..ambientColor = ambientLight.color
//    ..directionalLight = directionalLight
//    ..useLighting = useLighting;

//  material = new MaterialSkyBox();// Todo (jpu) : test this
//  material = new MaterialDepthTexture();// Todo (jpu) : test this

  // Todo (jpu) : see console : WebGL: INVALID_OPERATION: useProgram: program not valid
//  material = new MaterialPragmaticPBR(pointLight);

//  material = new MaterialDotScreen();// Todo (jpu) : test this
//  material = new MaterialSAO();// Todo (jpu) : test this

  return material;
}