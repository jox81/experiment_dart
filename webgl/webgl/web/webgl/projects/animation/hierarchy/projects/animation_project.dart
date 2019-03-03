import 'dart:async';
import 'dart:html' hide Animation;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/asset_library.dart';
import 'package:webgl/engine.dart';
import 'package:webgl/materials.dart';
import 'package:webgl/src/gltf/controller/node_conrtoller_type/color_node_controller.dart';
import 'package:webgl/src/gltf/interaction/node_interactionnable.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/gltf/scene.dart';
import 'package:webgl/src/gltf/camera/types/perspective_camera.dart';
import 'package:webgl/src/utils/utils_geometry.dart';
import 'bloc.dart';

class AnimationProject extends GLTFProject {

  static Future loadAssets() async {
    await AssetLibrary.loadDefault();
  }

  MaterialBaseColor _materialBaseColor;
  MaterialBaseColor get materialBaseColor => _materialBaseColor ??= new MaterialBaseColor(new Vector4(1.0, 0.0, 0.0, 1.0));

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
      GLTFNode node = UtilsGeometry.findNodeFromMouseCoords(Engine.mainCamera, event.client.x, event.client.y, nodes);
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
      ..translation = new Vector3(0.0, 20.0, 20.0);

    for (var i = -5; i < 5; ++i) {
      Bloc bloc = new Bloc()
      ..translation = new Vector3(1.1 * i, 0.0, 0.0);
      scene.addNode(bloc);
    }
  }
}