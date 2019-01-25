import 'package:webgl/src/webgl_objects/datas/webgl_active_info.dart';

class ProgramInfo{
  int attributeCount = 0;
  List<WebGLActiveInfo> attributes = new List();

  int uniformCount = 0;
  List<WebGLActiveInfo> uniforms = new List();
}