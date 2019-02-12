import 'dart:async';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/engine.dart';
import 'package:webgl/materials.dart';
import 'package:webgl/src/gltf/controller/node_conrtoller_type/color_node_controller.dart';
import 'package:webgl/src/gltf/interaction/node_interactionnable.dart';
import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/gltf/pbr_metallic_roughness.dart';
import 'package:webgl/src/mesh/mesh_primitive_infos.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/gltf/scene.dart';
import 'package:webgl/src/camera/types/perspective_camera.dart';

class PrimitivesProject extends GLTFProject {

  GLTFPBRMaterial _gLTFPBRMaterial;
  GLTFPBRMaterial get gLTFPBRMaterial => _gLTFPBRMaterial ??= new GLTFPBRMaterial(
      pbrMetallicRoughness: new GLTFPbrMetallicRoughness(
          baseColorFactor: new Float32List.fromList([1.0,1.0,1.0,1.0]),
          baseColorTexture: null,
          metallicFactor: 0.0,
          roughnessFactor: 1.0
      )
  );

  MaterialBaseColor _materialBaseColor;
  MaterialBaseColor get materialBaseColor => _materialBaseColor ??= new MaterialBaseColor(new Vector4(1.0, 0.0, 0.0, 1.0));

  MaterialPoint _materialPoint;
  MaterialPoint get materialPoint => _materialPoint ??= new MaterialPoint(pointSize:10.0, color:new Vector4(0.0, 0.66, 1.0, 1.0));

  final String baseDirectory = ''; // Todo (jpu) : usage ?

  NodeInteractionnable nodeInteractionnable = new NodeInteractionnable();

  PrimitivesProject._();
  static Future<PrimitivesProject> build() async {
    return await new PrimitivesProject._()
      .._setup();
  }

  Future _setup() async {


    nodeInteractionnable.controller = new ColorNodeController();
    addInteractable(nodeInteractionnable);

    scene = new GLTFScene();
    scene.backgroundColor = new Vector4(0.839, 0.815, 0.713, 1.0);

    Engine.mainCamera = new
    CameraPerspective(radians(37.0), 0.1, 1000.0)
      ..targetPosition = new Vector3.zero()
      ..translation = new Vector3(20.0, 20.0, 20.0);

    //> materials

    Material material = materialBaseColor;
//  GLTFPBRMaterial baseMaterial = gLTFPBRMaterial;
//  Material material = materialLibrary.materialReflection;
//  MaterialPoint materialPoint = materialLibrary.matrerialPoint;
    //  project.materials.add(material); // Todo (jpu) : don't add ?


//  GLTFMesh skyBoxMesh = new GLTFMesh.cube()
//    ..primitives[0].material = materialLibrary.materialSkyBox;/// ! vu ceci, il faut que l'objet qui a ce matériaux soit rendu en premier
//  GLTFNode skyBoxNode = new GLTFNode()
//    ..mesh = skyBoxMesh
//    ..name = 'quadDepth'
//    ..matrix.scale(2.0);
//  scene.addNode(skyBoxNode);

    //> meshes

    GLTFMesh meshPoint = new GLTFMesh.point()
      ..primitives[0].material = materialPoint;
    GLTFNode nodePoint = new GLTFNode()
      ..mesh = meshPoint
      ..name = 'point'
      ..translation = new Vector3(5.0, 0.0, 0.0);
    scene.addNode(nodePoint);

    // Todo (jpu) :This doesn't show, use another material ? what material doesn't work ?
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

    GLTFMesh meshTriangle = new GLTFMesh.triangle()
      ..primitives[0].material = material;
    GLTFNode nodeTriangle = new GLTFNode()
      ..mesh = meshTriangle
      ..name = 'triangle'
      ..translation = new Vector3(0.0, 0.0, -5.0);
    scene.addNode(nodeTriangle);

    GLTFMesh meshQuad = new GLTFMesh.quad()
      ..primitives[0].material = material;
    GLTFNode nodeQuad = new GLTFNode()
      ..mesh = meshQuad
      ..name = 'quad'
      ..translation = new Vector3(5.0, 0.0, -5.0);
    scene.addNode(nodeQuad);

    GLTFMesh meshPyramid = new GLTFMesh.pyramid()
      ..primitives[0].baseMaterial = gLTFPBRMaterial;//use of the base Material ?
    GLTFNode nodePyramid = new GLTFNode()
      ..mesh = meshPyramid
      ..name = 'pyramid'
      ..translation = new Vector3(-5.0, 0.0, 0.0);
    scene.addNode(nodePyramid);

    GLTFMesh meshCube = new GLTFMesh.cube()
      ..primitives[0].material = new MaterialBaseColor(new Vector4(1.0, 0.0, 1.0, 1.0));;
    GLTFNode nodeCube = new GLTFNode()
      ..mesh = meshCube
      ..name = 'cube'
      ..translation = new Vector3(0.0, 0.0, 0.0);
    scene.addNode(nodeCube);

    // Todo (jpu) : bug with other primitives with MaterialBaseVertexColor
    GLTFMesh meshSphere = new GLTFMesh.sphere(
        meshPrimitiveInfos: new MeshPrimitiveInfos(useColors: false))
      ..primitives[0].material = material;
    GLTFNode nodeSphere = new GLTFNode()
      ..mesh = meshSphere
      ..name = 'sphere'
      ..translation = new Vector3(5.0, 0.0, 0.0);
    scene.addNode(nodeSphere);
  }
}
