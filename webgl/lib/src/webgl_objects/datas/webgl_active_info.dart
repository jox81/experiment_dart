import 'dart:web_gl' as WebGL;
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
@MirrorsUsed(
    targets: const [
      WebGLActiveInfo,
    ],
    override: '*')
import 'dart:mirrors';

///The WebGLActiveInfo represents the information returned from the getActiveAttrib and getActiveUniform calls in a WebGlProgram.
class WebGLActiveInfo{

  final WebGL.ActiveInfo _webGLActiveInfo;

  WebGLActiveInfo.fromWebGL(this._webGLActiveInfo);

  ///The name of the requested variable.
  String get name => _webGLActiveInfo.name;

  ///The data type of the requested variable.
  ShaderVariableType get type => ShaderVariableType.getByIndex(_webGLActiveInfo.type) as ShaderVariableType;

  ///The size of the requested variable.
  int get size => _webGLActiveInfo.size;

  @override
  String toString(){
    return 'name : $name, \ntype : $type, \nsize : $size ';
  }
}