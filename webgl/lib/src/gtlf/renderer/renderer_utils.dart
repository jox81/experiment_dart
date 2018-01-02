import 'dart:html';

class GLFunctionCall {
  Function function;
  List<dynamic> vals;
}

class GlobalState {
  String vertSource;
  String fragSource;

  Map<String, GLFunctionCall> attributes;
  Map<String, GLFunctionCall> uniforms;

  int sRGBifAvailable; // else : webgl.RGBA

  dynamic hasLODExtension;
  dynamic hasDerivativesExtension;

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
