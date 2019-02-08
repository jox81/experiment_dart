import 'package:webgl/src/assets_manager/loader.dart';
import 'package:webgl/src/assets_manager/loaders/glsl_loader.dart';
import 'package:webgl/src/shaders/shader_infos.dart';
import 'package:webgl/src/shaders/shader_source.dart';
import 'package:webgl/src/utils/utils_http.dart';
import 'package:path/path.dart' as path;

class ShaderSourceLoader extends Loader<ShaderSource>{

  final ShaderInfos shaderInfos;

  ShaderSourceLoader(this.shaderInfos) : super(null);

  @override
  Future<ShaderSource> load() async {
    String _webPath = UtilsHttp.useWebPath ? UtilsHttp.webPath : Uri.base.origin;
    String _currentPackage = path.join(_webPath, 'packages/webgl');

    shaderInfos.vertexShaderPath = path.join(_currentPackage, shaderInfos.vertexShaderPath);
    shaderInfos.fragmentShaderPath = path.join(_currentPackage, shaderInfos.fragmentShaderPath);

    ShaderSource shaderSource = new ShaderSource(shaderInfos);

    shaderSource.vsCode = await new GLSLLoader(shaderSource.vertexShaderPath).load();
    shaderSource.fsCode = await new GLSLLoader(shaderSource.fragmentShaderPath).load();

    return shaderSource;
  }

  @override
  ShaderSource loadSync() {
    // TODO: implement loadSync
    return null;
  }
}