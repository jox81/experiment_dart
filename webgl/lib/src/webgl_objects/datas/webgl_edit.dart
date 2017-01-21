import 'package:webgl/src/context.dart';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/scene.dart';
@MirrorsUsed(
    targets: const [
      WebglEdit,
    ],
    override: '*')
import 'dart:mirrors';

class WebglEdit extends IEditElement {
  final Scene scene;

  static WebglEdit _instance;
  WebglEdit._init(this.scene);

  static WebglEdit instance(Scene scene){
    if(_instance == null){
      _instance = new WebglEdit._init(scene);
    }
    return _instance;
  }

  void getRenderingContext(){
    scene.currentSelection = gl;
  }

  void getContextAttributs(){
    scene.currentSelection = gl.contextAttributes;
  }

  void getActiveFrameBuffer(){
    scene.currentSelection = gl.activeFrameBuffer;
  }

  void getCurrentProgram(){
    scene.currentSelection = gl.currentProgram;
  }

  void getActiveTexture(){
    scene.currentSelection = gl.activeTexture;
  }

  num _test01 = 1.0;
  num get test01 => _test01;
  set test01(num value) => _test01 = value;

  num _test02 = 2.0;
  get test02 => _test02;

}