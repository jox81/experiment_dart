import 'dart:async';
import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera/types/perspective_camera.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/gltf/contoller/node_conrtoller_type/drive_2d_node_controller.dart';
import 'package:webgl/src/gltf/interaction/node_interactionnable.dart';
import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/mesh/mesh_primitive_infos.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/materials.dart';
import 'package:webgl/src/gltf/scene.dart';
import 'package:webgl/src/utils/utils_textures.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

class CubeMapProject{
  GLTFProject _project;
  GLTFProject get project => _project;

  GLTFNode _sphereNode;
  GLTFNode get sphereNode => _sphereNode;
  NodeInteractionnable nodeInteractionnable = new NodeInteractionnable();

  CubeMapProject._();
  static Future<CubeMapProject> build() async {
    return await new CubeMapProject._().._setup();
  }

  Future _setup() async{
    _project = new GLTFProject.create()..baseDirectory = 'primitives/';

    nodeInteractionnable.controller = new Drive2dNodeController();
    _project.addInteractable(nodeInteractionnable);
    GLTFScene scene = new GLTFScene();
    scene.backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0); // Todo (jpu) : ?
    _project.scene = scene;

//    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

    //Cameras
    CameraPerspective camera = new CameraPerspective(radians(37.0), 0.1, 100.0)
      ..targetPosition = new Vector3.zero()
      ..translation = new Vector3(0.0, 5.0, -10.0);
    Context.mainCamera = camera;

    List<List<ImageElement>> cubeMapImages =
        await TextureUtils.loadCubeMapImages('pisa');
    WebGLTexture cubeMapTexture =
    TextureUtils.createCubeMapFromImages(cubeMapImages, flip: false);

    MaterialSkyBox materialSkyBox = new MaterialSkyBox();
    materialSkyBox.skyboxTexture = cubeMapTexture;

    GLTFMesh skyBoxMesh = new GLTFMesh.cube(meshPrimitiveInfos : new MeshPrimitiveInfos(useNormals: false))
      ..primitives[0].material = materialSkyBox;
    GLTFNode skyBoxNode = new GLTFNode()
      ..mesh = skyBoxMesh
      ..name = 'quadDepth'
      ..matrix.scale(1.0);
    scene.addNode(skyBoxNode);

    Material material;

//    material = new MaterialPoint();
//    material = new MaterialBase();
    material = new MaterialReflection()..skyboxTexture = cubeMapTexture;

//    GridMesh grid = new GridMesh();
//    meshes.add(grid);

    GLTFMesh sphereMesh = new GLTFMesh.sphere(
        radius: 1.0, segmentV: 32, segmentH: 32, meshPrimitiveInfos : new MeshPrimitiveInfos(useNormals: false))
      ..primitives[0].material = material;
    _sphereNode = new GLTFNode()
      ..mesh = sphereMesh
      ..name = 'sphere'
      ..matrix.translate(0.0, 0.0, 0.0)
      ..matrix.scale(1.0);
    scene.addNode(sphereNode);

    GLTFMesh planeMesh = new GLTFMesh.quad(meshPrimitiveInfos : new MeshPrimitiveInfos(useNormals: false))
      ..primitives[0].material = material;
    GLTFNode planeNode = new GLTFNode()
      ..mesh = planeMesh
      ..name = 'plane'
      ..matrix.translate(2.0, 0.0, 0.0)
      ..matrix.scale(1.0)
      ..matrix.rotateX(radians(-90.0));
    scene.addNode(planeNode);

    GLTFMesh cubeMesh = new GLTFMesh.quad(meshPrimitiveInfos : new MeshPrimitiveInfos(useNormals: false))
      ..primitives[0].material = material;
    GLTFNode cubeNode = new GLTFNode()
      ..mesh = cubeMesh
      ..name = 'cube'
      ..matrix.translate(0.0, 1.0, 2.0)
      ..matrix.scale(1.0);
    scene.addNode(cubeNode);

    GLTFMesh meshPyramid = new GLTFMesh.pyramid(meshPrimitiveInfos : new MeshPrimitiveInfos(useNormals: false))
      ..primitives[0].material = material;
    GLTFNode nodePyramid = new GLTFNode()
      ..mesh = meshPyramid
      ..name = 'pyramid'
      ..matrix.translate(7.0, 1.0, 0.0);
    scene.addNode(nodePyramid);
  }
}
