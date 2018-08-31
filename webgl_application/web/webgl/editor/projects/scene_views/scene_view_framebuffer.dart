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
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

GLTFProject projectFrameBuffer() {
  GLTFProject project = new GLTFProject.create()..baseDirectory = 'primitives/';

  GLTFScene scene = new GLTFScene();
  scene.backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);// Todo (jpu) : ?
  project.scene = scene;

  GLTFPBRMaterial material = new GLTFPBRMaterial(
      pbrMetallicRoughness: new GLTFPbrMetallicRoughness(
          baseColorFactor: new Float32List.fromList([1.0,1.0,1.0,1.0]),
          baseColorTexture: null,//GLTFTextureInfo.createTexture(project, 'testTexture.png'),
          metallicFactor: 0.0,
          roughnessFactor: 1.0
      )
  );
  project.materials.add(material);

  List<WebGLTexture> renderedTextures = TextureUtils.buildRenderedTextures();

  //

  MaterialBaseTexture materialBaseTextureNormal =
  new MaterialBaseTexture()
    ..texture = renderedTextures[0];

  GLTFMesh colorMeshQuad = new GLTFMesh.quad(meshPrimitiveInfos : new MeshPrimitiveInfos(useNormals: false))
    ..primitives[0].material = materialBaseTextureNormal;
  GLTFNode colorNodeQuad = new GLTFNode()
    ..mesh = colorMeshQuad
    ..name = 'quadColor'
    ..translation = new Vector3(0.0, 1.0, 0.0)
    ..rotation = new Quaternion.axisAngle(new Vector3(0.0, 0.0, 1.0), radians(90.0));;
  scene.addNode(colorNodeQuad);
  //

  MaterialDepthTexture materialDepthTextureNormal =
  new MaterialDepthTexture()
    ..texture = renderedTextures[1];

  GLTFMesh depthMeshQuad = new GLTFMesh.quad(meshPrimitiveInfos : new MeshPrimitiveInfos(useNormals: false))
    ..primitives[0].material = materialDepthTextureNormal;
  GLTFNode depthNodeQuad = new GLTFNode()
    ..mesh = depthMeshQuad
    ..name = 'quadDepth'
    ..translation = new Vector3(0.0, -1.0, 0.0)
    ..rotation = new Quaternion.axisAngle(new Vector3(0.0, 0.0, 1.0), radians(90.0));
  scene.addNode(depthNodeQuad);

  return project;
}
