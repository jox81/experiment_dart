import 'dart:html';
import 'renderer_kronos_scene.dart';
import 'dart:web_gl' as webgl;

class GLFunctionCall {
  Function function;
  List<dynamic> vals;
}

class GlobalState {
  String vertSource;
  String fragSource;

  Map<String, GLFunctionCall> attributes = new Map();
  Map<String, GLFunctionCall> uniforms = new Map();

  int sRGBifAvailable; // else : webgl.RGBA

  webgl.ExtShaderTextureLod hasLODExtension;
  webgl.OesStandardDerivatives hasDerivativesExtension;

  KronosScene scene;
}

class ScaleVal{
  double IBL;

  Element activeElement;
  Element pinnedElement;

  bool pinned;
}

class Position<T>{
  T x;
  T y;
  Position({this.x, this.y});
}

class ImageInfo{
  String uri;
  int samplerId;
  int colorSpace;

  bool clamp;
}

class MainInfos{
  static double translate;
  static double roll;
  static double pitch;
}
