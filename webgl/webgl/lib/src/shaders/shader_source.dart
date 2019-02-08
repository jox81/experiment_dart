import 'package:webgl/src/shaders/shader_infos.dart';
import 'package:webgl/asset_library.dart';

class ShaderSource {
  final ShaderInfos _shaderInfos;

  ShaderName get shaderName => _shaderInfos.shaderName;
  String get vertexShaderPath => _shaderInfos.vertexShaderPath;
  String get fragmentShaderPath => _shaderInfos.fragmentShaderPath;

  String vsCode;
  String fsCode;

  ShaderSource(this._shaderInfos);
}