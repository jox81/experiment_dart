import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/asset_library.dart';
import 'package:webgl/engine.dart';
import 'package:webgl/materials.dart';
import 'package:webgl/src/gltf/pbr_metallic_roughness.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/gltf/scene.dart';
import 'package:webgl/src/gltf/camera/types/perspective_camera.dart';

class PrimitivesProject extends GLTFProject {

  static Future<PrimitivesProject> build() async {
    await PrimitivesProject.loadAssets();
    return await new PrimitivesProject._()
      .._setup();
  }

  static Future loadAssets() async {
    await AssetLibrary.loadDefault();
  }

  PrimitivesProject._();

  Future _setup() async {

    scene = new GLTFScene();
    scene.backgroundColor = new Vector4(0.839, 0.815, 0.713, 1.0);

    Engine.mainCamera = new
    GLTFCameraPerspective(radians(37.0), 0.1, 1000.0)
      ..targetPosition = new Vector3.zero()
      ..translation = new Vector3(20.0, 20.0, 20.0);

    //> meshes

    CubeGLTFNode nodeCube = new CubeGLTFNode()
      ..material = new MaterialBaseColor(new Vector4(1.0, 0.0, 1.0, 1.0))
      ..name = 'cube'
      ..translation = new Vector3(0.0, 0.0, 0.0)
      ..onClick.listen((e){
        print('clicked');
      });
    scene.addNode(nodeCube);
  }
}
