import 'package:webgl/src/assets_manager/loader.dart';
import 'package:webgl/src/assets_manager/loaders/glsl_loader.dart';
import 'package:webgl/src/shaders/shader_infos.dart';
import 'package:webgl/src/shaders/shader_source.dart';
import 'package:webgl/src/utils/utils_http.dart';
import 'package:path/path.dart' as path;

class ShaderSourceLoader extends Loader<ShaderSource>{

  ShaderSourceLoader();

  @override
  Future<ShaderSource> load(covariant ShaderInfos shaderInfos) async {
    String _webPath = UtilsHttp.useWebPath ? UtilsHttp.webPath : Uri.base.origin;
    String _currentPackage = path.join(_webPath, 'packages/webgl');

    shaderInfos.vertexShaderPath = path.join(_currentPackage, shaderInfos.vertexShaderPath);
    shaderInfos.fragmentShaderPath = path.join(_currentPackage, shaderInfos.fragmentShaderPath);

    ShaderSource shaderSource = new ShaderSource(shaderInfos);

    shaderSource.vsCode = await new GLSLLoader().load(shaderSource.vertexShaderPath);
    shaderSource.fsCode = await new GLSLLoader().load(shaderSource.fragmentShaderPath);

    return shaderSource;
  }

  @override
  ShaderSource loadSync(covariant ShaderInfos shaderInfos) {
    // TODO: implement loadSync
    throw new Exception('not yet implemented');
  }

  Future<List<ShaderSource>> loadAll(List<ShaderInfos> shadersInfos) async {
    List<Future<ShaderSource>> futures = <Future<ShaderSource>>[];

    List<ShaderSource> shaderSources = [];
    for (ShaderInfos shaderInfos in shadersInfos) {
      futures.add(() async{
        ShaderSource shaderSource = await new ShaderSourceLoader().load(shaderInfos);
        shaderSources.add(shaderSource);
      }());
    }

    await Future.wait<dynamic>(futures);

    return shaderSources;
  }
}