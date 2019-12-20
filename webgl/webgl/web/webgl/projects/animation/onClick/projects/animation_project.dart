import 'dart:async';
import 'dart:html' hide Animation;
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/asset_library.dart';
import 'package:webgl/engine.dart';
import 'package:webgl/materials.dart';
import 'package:webgl/src/animation/animation.dart';
import 'package:webgl/src/gltf/controller/node_conrtoller_type/color_node_controller.dart';
import 'package:webgl/src/gltf/interaction/node_interactionnable.dart';
import 'package:webgl/src/gltf/pbr_metallic_roughness.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/gltf/scene.dart';
import 'package:webgl/src/gltf/camera/types/perspective_camera.dart';
import 'package:webgl/src/utils/utils_geometry.dart';
import 'package:webgl/src/utils/utils_time.dart';

class AnimationProject extends GLTFProject {

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

  AnimationProject._();
  static Future<AnimationProject> build() async {
    await AnimationProject.loadAssets();
    return await new AnimationProject._()
      .._setup();
  }

  Future _setup() async {
    nodeInteractionnable.controller = new ColorNodeController();
    addInteractable(nodeInteractionnable);

    canvas.onMouseDown.listen((MouseEvent event){
      GLTFNode node = UtilsGeometry.findNodeFromMouseCoords(Engine.mainCamera as GLTFCameraPerspective, event.client.x, event.client.y, nodes);
      if(node != null) {
        nodeInteractionnable.node = node;
        node.onClickController.add(event);
        print('node switch > ${node.name}');
        print('${event.client.x}, ${event.client.y}');
      }
    });

    scene = new GLTFScene();
    scene.backgroundColor = new Vector4(0.839, 0.815, 0.713, 1.0);

    mainCamera = new
    GLTFCameraPerspective(radians(37.0), 0.1, 1000.0)
      ..targetPosition = new Vector3.zero()
      ..translation = new Vector3(20.0, 20.0, 20.0);

    //> materials

    nodeCube = new CubeGLTFNode()
      ..material = new MaterialBaseColor(new Vector4(0.0, 0.0, 1.0, 1.0))
      ..name = 'cube'
      ..translation = new Vector3(0.0, 0.0, 0.0);
    scene.addNode(nodeCube);

    nodeCube2 = new CubeGLTFNode()
      ..material = new MaterialBaseColor(new Vector4(1.0, 1.0, 0.0, 1.0))
      ..name = 'cube2'
      ..translation = new Vector3(0.0, 0.0, 3.0);
    scene.addNode(nodeCube2);

    nodeCube.parent = nodeCube2;

    nodeCube2.onClick.listen((e){
      print("node2 clicked !!!");
      Animation animation = new Animation.startEnd(5.0, 0.0, 1.0, ease: Ease.easeOutBounce)
        ..onUpdate.listen((double value){
          nodeCube2.translation = new Vector3(0.0, value, 3.0);
          print('  animation : $value');
        });
      animation.play();
    });

    nodeCube.onClick.listen((e){
      print("node clicked !!!");
      Animation animation = new Animation.startEnd(10.0, 0.0, 2.0, ease: Ease.easeOutBounce)
        ..onUpdate.listen((num value){
          nodeCube.translation = new Vector3(0.0, 0.0, 3.0 + value);
          print('  animation : $value');
        });
      animation.play();
    });
  }

  CubeGLTFNode nodeCube;
  CubeGLTFNode nodeCube2;

  bool isPlaying = false;

  @override
  void update({num currentTime: 0.0}) async {
    if(!isPlaying){
      isPlaying = true;

      await moveCube();

      await delayedFuture(5);
    }
  }

  Future moveCube() async {
    Animation animation1 = new Animation.startEnd(0.0, 5.0, 2.0, ease: Ease.easeInQuadratic)
    ..onUpdate.listen((double value){
      nodeCube.translation = new Vector3(value, 2.0, 0.0);
    });
    animation1.play();

    Animation animation3 = new Animation.startEnd(0.0, 5.0, 2.0, ease: Ease.easeOutBounce)
    ..onUpdate.listen((double value){
      nodeCube2.translation = new Vector3(value, 0.0, 3.0);
      print('  animation3 : $value');
    });
    animation3.play();
  }
}