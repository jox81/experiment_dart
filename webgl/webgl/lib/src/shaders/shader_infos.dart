import 'package:webgl/src/shaders/shader_name.dart';

class ShaderInfos {
  final ShaderName shaderName;
  String vertexShaderPath;
  String fragmentShaderPath;

  ShaderInfos(this.shaderName, this.vertexShaderPath, this.fragmentShaderPath);
}