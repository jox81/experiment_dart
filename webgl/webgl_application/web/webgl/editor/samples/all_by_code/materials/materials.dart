import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/materials.dart';
import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/pbr_metallic_roughness.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/assets_manager/library.dart';
import 'package:webgl/src/assets_manager/loaders/image_loader.dart';
import 'package:webgl/src/gltf/scene.dart';
import 'package:webgl/src/mesh/mesh_primitive_infos.dart';
import 'package:webgl/src/gltf/texture_info/texture_info.dart';
import 'package:webgl/src/utils/utils_textures.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

class ProjectLibrary extends Library{
  String testTexturePath = 'materials/testTexture.png';
  ImageElement get testTexture => getImageElement(testTexturePath);

  ProjectLibrary(){
    addImageElementPath(testTexturePath);
  }
}

Future<GLTFProject> projectTestMaterials() async {
  GLTFProject project = new GLTFProject.create()..baseDirectory = 'materials/';

  GLTFScene scene = new GLTFScene();
  scene.backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);// Todo (jpu) : ?
  project.scene = scene;

  GLTFPBRMaterial baseMmaterial = new GLTFPBRMaterial(
      pbrMetallicRoughness: new GLTFPbrMetallicRoughness(
          baseColorFactor: new Float32List.fromList([1.0,1.0,1.0,1.0]),
          baseColorTexture: GLTFTextureInfo.createTexture(project, 'testTexture.png'),
          metallicFactor: 0.0,
          roughnessFactor: 1.0
      )
  );

  ProjectLibrary library = new ProjectLibrary();
  await library.loadAll();

  List<Material> materials = [
    new MaterialPoint(pointSize:5.0, color:new Vector4(0.0, 0.66, 1.0, 1.0)),
    new MaterialBase(),
    new MaterialBaseColor(new Vector4(1.0, 1.0, 0.0, 1.0)),
    new MaterialBaseTexture()..texture = TextureUtils.createTexture2DFromImageElement(library.testTexture),
  ];

  int materialsIndex = 0;
  int drawMode = DrawMode.TRIANGLES;

  Material material = materials.last;
  
  // Todo (jpu) :This doesn't show, use another material
  GLTFMesh meshPoint = new GLTFMesh.point()
    ..primitives[0].material = material;
  GLTFNode nodePoint = new GLTFNode()
  ..mesh = meshPoint
  ..name = 'point'
  ..translation = new Vector3(-5.0, 0.0, -5.0);
  scene.addNode(nodePoint);

  // Todo (jpu) :This doesn't show, use another material
  GLTFMesh meshLine = new GLTFMesh.line([
    new Vector3.all(0.0),
    new Vector3(10.0, 0.0, 0.0),
    new Vector3(10.0, 0.0, 10.0),
    new Vector3(10.0, 10.0, 10.0),
  ])
    ..primitives[0].material = material;
  GLTFNode nodeLine = new GLTFNode()
  ..mesh = meshLine
  ..name = 'multiline'
  ..translation = new Vector3(-5.0, 0.0, -5.0);
  scene.addNode(nodeLine);

  // Todo (jpu) : should use normals
  GLTFMesh meshTriangle = new GLTFMesh.triangle(meshPrimitiveInfos : new MeshPrimitiveInfos(useNormals: false))
    ..primitives[0].material = material
    ..primitives[0].drawMode = drawMode;
  GLTFNode nodeTriangle = new GLTFNode()
  ..mesh = meshTriangle
  ..name = 'triangle'
  ..translation = new Vector3(0.0, 0.0, -5.0);
  scene.addNode(nodeTriangle);

  // Todo (jpu) : should use normals
  GLTFMesh meshQuad = new GLTFMesh.quad(meshPrimitiveInfos : new MeshPrimitiveInfos(useNormals: false))
    ..primitives[0].material = material
    ..primitives[0].drawMode = drawMode;
  GLTFNode nodeQuad = new GLTFNode()
    ..mesh = meshQuad
    ..name = 'quad'
    ..translation = new Vector3(5.0, 0.0, -5.0);
  scene.addNode(nodeQuad);

  // Todo (jpu) : should use normals
  GLTFMesh meshPyramid = new GLTFMesh.pyramid(meshPrimitiveInfos : new MeshPrimitiveInfos(useNormals: false))
    ..primitives[0].material = material
    ..primitives[0].drawMode = drawMode;
  GLTFNode nodePyramid = new GLTFNode()
    ..mesh = meshPyramid
    ..name = 'pyramid'
    ..translation = new Vector3(-5.0, 0.0, 0.0);
  scene.addNode(nodePyramid);

  // Todo (jpu) : should use normals
  GLTFMesh meshCube = new GLTFMesh.cube(meshPrimitiveInfos : new MeshPrimitiveInfos(useNormals: false))
    ..primitives[0].material = material
    ..primitives[0].drawMode = drawMode;
  GLTFNode nodeCube = new GLTFNode()
    ..mesh = meshCube
    ..name = 'cube'
    ..translation = new Vector3(0.0, 0.0, 0.0);
  scene.addNode(nodeCube);

  // Todo (jpu) : should use normals
  GLTFMesh meshSphere = new GLTFMesh.sphere(segmentV: 8, segmentH: 8,meshPrimitiveInfos : new MeshPrimitiveInfos(useNormals: false))
    ..primitives[0].material = material
    ..primitives[0].drawMode = drawMode;
  GLTFNode nodeSphere = new GLTFNode()
    ..mesh = meshSphere
    ..name = 'sphere'
    ..translation = new Vector3(5.0, 0.0, 0.0);
  scene.addNode(nodeSphere);

  return project;
}

// Todo (jpu) : remarques sur comment convertir une scene application en gltf renderer
////    AxisMesh axis = new AxisMesh();
////    meshes.add(axis);
