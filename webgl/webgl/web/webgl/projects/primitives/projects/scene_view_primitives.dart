import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/asset_library.dart';
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
import 'package:webgl/src/gltf/camera/types/perspective_camera.dart';
import 'package:webgl/src/utils/utils_geometry.dart';

class PrimitivesProject extends GLTFProject {

  static Future loadAssets() async {
    await AssetLibrary.loadDefault();
  }

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

  NodeInteractionnable nodeInteractionnable = new NodeInteractionnable();

  PrimitivesProject._();
  static Future<PrimitivesProject> build() async {
    await PrimitivesProject.loadAssets();
    return await new PrimitivesProject._()
      .._setup();
  }

  Future _setup() async {
    nodeInteractionnable.controller = new ColorNodeController();
    addInteractable(nodeInteractionnable);

    canvas.onMouseDown.listen((MouseEvent event){
      GLTFNode node = UtilsGeometry.findNodeFromMouseCoords(mainCamera, event.client.x, event.client.y, nodes);
      if(node != null) {
        nodeInteractionnable.node = node;
        print('node switch > ${node.name}');
        print('${event.client.x}, ${event.client.y}');
      }
    });

    scene = new GLTFScene();
    scene.backgroundColor = new Vector4(0.839, 0.815, 0.713, 1.0);

    Engine.mainCamera = new
    GLTFCameraPerspective(radians(37.0), 0.1, 1000.0)
      ..targetPosition = new Vector3.zero()
      ..translation = new Vector3(20.0, 20.0, 20.0);

    //> materials

    Material material = materialBaseColor;
//  GLTFPBRMaterial baseMaterial = gLTFPBRMaterial;
//  Material material = materialLibrary.materialReflection;
//  MaterialPoint materialPoint = materialLibrary.matrerialPoint;
    //  project.materials.add(material); // Todo (jpu) : don't add ?

//  CubeGLTFNode skyBoxNode = new CubeGLTFNode()
//    ..material = materialLibrary.materialSkyBox;/// ! vu ceci, il faut que l'objet qui a ce matériaux soit rendu en premier
//    ..name = 'quadDepth'
//    ..matrix.scale(2.0);
//  scene.addNode(skyBoxNode);

    //> meshes

    PointGLTFNode nodePoint = new PointGLTFNode()
      ..material = materialPoint
      ..name = 'point'
      ..translation = new Vector3(5.0, 0.0, 0.0);
    scene.addNode(nodePoint);

    // Todo (jpu) :This doesn't show, use another material ? what material doesn't work ?
    LineGLTFNode nodeLine = new LineGLTFNode([
      new Vector3.all(0.0),
      new Vector3(10.0, 0.0, 0.0),
      new Vector3(10.0, 0.0, 10.0),
      new Vector3(10.0, 10.0, 10.0),
    ])
      ..material = material
      ..name = 'multiline'
      ..translation = new Vector3(-5.0, 0.0, -5.0);
    scene.addNode(nodeLine);

    TriangleGLTFNode nodeTriangle = new TriangleGLTFNode()
      ..material = material
      ..name = 'triangle'
      ..translation = new Vector3(0.0, 0.0, -5.0);
    scene.addNode(nodeTriangle);

    QuadGLTFNode nodeQuad = new QuadGLTFNode()
      ..material = material
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

    CubeGLTFNode nodeCube = new CubeGLTFNode()
      ..material = new MaterialBaseColor(new Vector4(1.0, 0.0, 1.0, 1.0))
      ..name = 'cube'
      ..translation = new Vector3(0.0, 0.0, 0.0);
    scene.addNode(nodeCube);

    // Todo (jpu) : bug with other primitives with MaterialBaseVertexColor
    SphereGLTFNode nodeSphere = new SphereGLTFNode()
      ..material = material
      ..name = 'sphere'
      ..translation = new Vector3(5.0, 0.0, 0.0);
    scene.addNode(nodeSphere);
  }
}
