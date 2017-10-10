import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/scene.dart';
@MirrorsUsed(
    targets: const [
      WebglEdit,
    ],
    override: '*')
import 'dart:mirrors';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

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

  // >> Test String

  //getter + setter
  String _testString01 = 'testString01';
  String get testString01 => _testString01;
  set testString01(String value) => _testString01 = value;

  //getter only
  String _testString02 = "testString02";
  String get testString02 => _testString02;

  // >> Test num

  //getter + setter
  num _testNum01 = 1.0;
  num get testNum01 => _testNum01;
  set testNum01(num value) => _testNum01 = value;

  //getter only
  num _testNum02 = 2.0;
  num get testNum02 => _testNum02;

  // >> Test bool

  //getter + setter
  bool _testBool01 = true;
  bool get testBool01 => _testBool01;
  set testBool01(bool value) => _testBool01 = value;

  //getter only
  bool _testBool02 = false;
  bool get testBool02 => _testBool02;

  // >> Test WebGLEnum

  //getter + setter
  EnableCapabilityType _enableCapabilityType = EnableCapabilityType.DEPTH_TEST;
  EnableCapabilityType get testWebGLEnum01 => _enableCapabilityType;
  set testWebGLEnum01(EnableCapabilityType value) {
    _enableCapabilityType = value;
    print('### $value');
  }

  //getter only
  EnableCapabilityType get testWebGLEnum02 => EnableCapabilityType.CULL_FACE;

  // >> Functions

  void getFunc01Test(num count, {num optionalCount:3}){
    print('count:${count}, optionalCount:${optionalCount}');
  }

  num getFunc02Test(num count, {num optionalCount:3}){
    return count + optionalCount;
  }

  Vector2 getFunc04Test(Vector3 vec3, Vector2 vec2, {bool useVec2 : false, Vector2 vec2Opt, Vector3 vec3Opt, num test : 10.5}){
    print('vec3:$vec3');
    print('vec2:$vec2');
    print('vec3Opt:$vec3Opt');
    print('vec2Opt:$vec2Opt');
    print('test:$test');
    return vec3.xy +vec2;// (useVec2?vec2:new Vector2.zero());
  }
}