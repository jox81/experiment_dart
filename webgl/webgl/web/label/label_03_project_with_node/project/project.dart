import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/asset_library.dart';
import 'package:webgl/gltf.dart';
import 'package:webgl/src/textures/text_style.dart';

class LabelProject extends GLTFProject{

  int radius = 5;
  num speed = 0.001;

  LabelProject._();
  static Future<LabelProject> build() async {
    await AssetLibrary.loadDefault();
    return new LabelProject._().._setup();
  }

  void _setup() {

    scene = new GLTFScene();
    scene.backgroundColor = new Vector4(0.839, 0.815, 0.713, 1.0);

    mainCamera = new
    GLTFCameraPerspective(radians(37.0), 0.1, 1000.0)
      ..targetPosition =  new Vector3.zero()
      ..translation = new Vector3(20.0, 20.0, 20.0);

    GLTFNode axis = new GLTFNode.axis();
    scene.addNode(axis);

    //> create label texture
    TextStyle textStyle = new TextStyle();
    labelNode = new GLTFNode.label("Hello World !", 128, 64, textStyle);
    //
//    labelNode.rotate(new Quaternion.axisAngle(new Vector3(1.0, 0.0, 0.0), radians(90)));
//    labelNode.rotation = new Quaternion.axisAngle(new Vector3(0.0, 1.0, 0.0), radians(90));

    scene.addNode(labelNode);
  }
  GLTFNode labelNode;

  bool isPlaying = false;
  void update({num currentTime : 0.0}) {
    if(!isPlaying){
      isPlaying = true;

    }
    Vector3 cameraPosition = new Vector3(
        Math.sin(currentTime * speed) * radius,
        1.0,
        Math.cos(currentTime * speed) * radius);


//    labelNode.rotation = new Quaternion.axisAngle(new Vector3(1.0, 0.0, 0.0), radians((currentTime * 0.1) % 360));
//    mainCamera.translation = cameraPosition;


//    labelNode.translate(new Vector3(0.0, 0.0, 0.0));
  }
  void play(){

  }
}