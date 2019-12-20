import 'dart:async';
import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/camera/types/perspective_camera.dart';
import 'package:webgl/src/engine/engine.dart';
import 'package:webgl/src/gltf/controller/node_conrtoller_type/drive_2d_node_controller.dart';
import 'package:webgl/src/gltf/interaction/node_interactionnable.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/materials.dart';
import 'package:webgl/src/gltf/scene.dart';
import 'package:webgl/asset_library.dart';
import 'package:webgl/src/utils/utils_geometry.dart';
import 'package:webgl/src/utils/utils_textures.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

class CubeMapProject extends GLTFProject{

  static Future loadAssets() async {
    await AssetLibrary.loadDefault();
    await AssetLibrary.cubeMaps.load(CubeMapName.pisa);
  }

  static Future<CubeMapProject> build() async {
    await CubeMapProject.loadAssets();
    return await new CubeMapProject._().._setup();
  }

  CubeMapProject._();

  Future _setup() async{

    NodeInteractionnable nodeInteractionnable = new NodeInteractionnable();
    nodeInteractionnable.controller = new Drive2dNodeController();
    addInteractable(nodeInteractionnable);

    canvas.onMouseDown.listen((MouseEvent event){
      GLTFNode node = UtilsGeometry.findNodeFromMouseCoords(Engine.mainCamera as GLTFCameraPerspective, event.client.x, event.client.y, nodes);
      if(node != null) {
        nodeInteractionnable.node = node;
        print('node switch > ${node.name}');
        print('${event.client.x}, ${event.client.y}');
      }
    });

    scene = new GLTFScene();
    scene.backgroundColor = new Vector4(0.839, 0.815, 0.713, 1.0);

    //Cameras
    GLTFCameraPerspective camera = new
    GLTFCameraPerspective(radians(37.0), 0.1, 1000.0)
      ..targetPosition = new Vector3.zero()
      ..translation = new Vector3(20.0, 20.0, 20.0);
    Engine.mainCamera = camera;

    List<List<ImageElement>> cubeMapImages = AssetLibrary.cubeMaps.pisa;
    WebGLTexture cubeMapTexture =
    TextureUtils.createCubeMapFromImages(cubeMapImages, flip: false);

    MaterialSkyBox materialSkyBox = new MaterialSkyBox();
    materialSkyBox.skyboxTexture = cubeMapTexture;

    CubeGLTFNode skyBoxNode = new CubeGLTFNode()
      ..material = materialSkyBox
      ..name = 'quadDepth'
      ..matrix.scale(1.0);
    scene.addNode(skyBoxNode);

    Material material;

//    material = new MaterialPoint();
//    material = new MaterialBase();
    material = new MaterialReflection()..skyboxTexture = cubeMapTexture;

    GridGLTFNode gridNode = new GridGLTFNode();
    scene.addNode(gridNode);

    SphereGLTFNode sphereNode = new SphereGLTFNode()
      ..material = material
      ..name = 'sphere'
      ..matrix.translate(0.0, 0.0, 0.0)
      ..matrix.scale(1.0);
    scene.addNode(sphereNode);

    QuadGLTFNode planeNode = new QuadGLTFNode()
      ..material = material
      ..name = 'plane'
      ..matrix.translate(2.0, 0.0, 0.0)
      ..matrix.scale(1.0)
      ..matrix.rotateX(radians(-90.0));
    scene.addNode(planeNode);

    QuadGLTFNode cubeNode = new QuadGLTFNode()
      ..material = material
      ..name = 'cube'
      ..matrix.translate(0.0, 1.0, 2.0)
      ..matrix.scale(1.0);
    scene.addNode(cubeNode);

    PyramidGLTFNode nodePyramid = new PyramidGLTFNode()
      ..material = material
      ..name = 'pyramid'
      ..matrix.translate(7.0, 1.0, 0.0);
    scene.addNode(nodePyramid);
  }
}
