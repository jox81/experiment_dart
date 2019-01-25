import 'dart:async';
import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/gltf/mesh/mesh_primitive_infos.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/materials.dart';
import 'package:webgl/src/gltf/scene.dart';
import 'package:webgl/src/utils/utils_textures.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/camera/types/perspective_camera.dart';

Future<GLTFProject> projectPrimitivesTextured() async {
  GLTFProject project = new GLTFProject.create();

  GLTFScene scene = new GLTFScene();
  scene.backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);// Todo (jpu) : ?
  project.addScene(scene);
  project.scene = scene;

  Context.mainCamera = new
  CameraPerspective(radians(37.0), 0.1, 1000.0)
    ..targetPosition = new Vector3.zero()
    ..translation = new Vector3(20.0, 20.0, 20.0);

  Uri uriImage = new Uri.file("packages/webgl/images/utils/uv.png");
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

  MaterialBaseTexture material = new MaterialBaseTexture()
    ..texture = texture;

  // Todo (jpu) : should use normals
  GLTFMesh meshTriangle = new GLTFMesh.triangle(meshPrimitiveInfos : new MeshPrimitiveInfos())
    ..primitives[0].material = material;
  project.meshes.add(meshTriangle);
  GLTFNode nodeTriangle = new GLTFNode()
    ..mesh = meshTriangle
    ..name = 'triangle'
    ..translation = new Vector3(0.0, 0.0, -5.0);
  scene.addNode(nodeTriangle);
  project.addNode(nodeTriangle);

  // Todo (jpu) : should use normals
  GLTFMesh meshQuad = new GLTFMesh.quad(meshPrimitiveInfos : new MeshPrimitiveInfos())
    ..primitives[0].material = material;
  project.meshes.add(meshQuad);
  GLTFNode nodeQuad = new GLTFNode()
    ..mesh = meshQuad
    ..name = 'quad'
    ..translation = new Vector3(5.0, 0.0, -5.0);
  scene.addNode(nodeQuad);
  project.addNode(nodeQuad);

  // Todo (jpu) : should use normals
  GLTFMesh meshPyramid = new GLTFMesh.pyramid(meshPrimitiveInfos : new MeshPrimitiveInfos())
    ..primitives[0].material = material;
  project.meshes.add(meshPyramid);
  GLTFNode nodePyramid = new GLTFNode()
    ..mesh = meshPyramid
    ..name = 'pyramid'
    ..translation = new Vector3(-5.0, 0.0, 0.0);
  scene.addNode(nodePyramid);
  project.addNode(nodePyramid);

  // Todo (jpu) : should use normals
  GLTFMesh meshCube = new GLTFMesh.cube(meshPrimitiveInfos : new MeshPrimitiveInfos())
    ..primitives[0].material = material;
  project.meshes.add(meshCube);
  GLTFNode nodeCube = new GLTFNode()
    ..mesh = meshCube
    ..name = 'cube'
    ..translation = new Vector3(0.0, 0.0, 0.0);
  scene.addNode(nodeCube);
  project.addNode(nodeCube);

  // Todo (jpu) : should use normals
  GLTFMesh meshSphere = new GLTFMesh.sphere(meshPrimitiveInfos : new MeshPrimitiveInfos())
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