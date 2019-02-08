import 'package:webgl/asset_library.dart';

class ShaderInfos {
  final ShaderName shaderName;
  String vertexShaderPath;
  String fragmentShaderPath;

  ShaderInfos(this.shaderName, this.vertexShaderPath, this.fragmentShaderPath);
}