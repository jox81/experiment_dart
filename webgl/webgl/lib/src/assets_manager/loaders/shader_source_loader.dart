import 'package:webgl/src/assets_manager/loader.dart';
import 'package:webgl/src/assets_manager/loaders/glsl_loader.dart';
import 'package:webgl/src/shaders/shader_infos.dart';
import 'package:webgl/src/shaders/shader_source.dart';
import 'package:webgl/src/utils/utils_http.dart';
import 'package:path/path.dart' as path;

class ShaderSourceLoader extends Loader<ShaderSource>{

  ShaderInfos shaderInfos;

  ShaderSourceLoader();

  @override
  Future<ShaderSource> load() async {
    {
      filePath = '';
      super.load();
      assert(shaderInfos!=null||(throw 'shaderInfos must be set before'));
    }

    ShaderSource shaderSource = new ShaderSource(shaderInfos);

    GLSLLoader loader = new GLSLLoader()
    ..onLoadProgress.listen(onLoadProgressStreamController.add);
    shaderSource.vsCode = await (loader..filePath = shaderSource.vertexShaderPath).load();
    shaderSource.fsCode = await (loader..filePath = shaderSource.fragmentShaderPath).load();

    return shaderSource;
  }

  @override
  ShaderSource loadSync() {
    super.loadSync();
    // TODO: implement loadSync
    throw new Exception('not yet implemented');
  }

  Future<List<ShaderSource>> loadAll(List<ShaderInfos> shadersInfos) async {
    List<Future<ShaderSource>> futures = <Future<ShaderSource>>[];

    List<ShaderSource> shaderSources = [];
    for (ShaderInfos shaderInfos in shadersInfos) {
      futures.add(() async{
        ShaderSourceLoader shaderSourceLoader = new ShaderSourceLoader()
          ..onLoadProgress.listen(onLoadProgressStreamController.add)
          ..shaderInfos = shaderInfos;
        ShaderSource shaderSource = await shaderSourceLoader.load();
        shaderSources.add(shaderSource);
      }());
    }

    await Future.wait<dynamic>(futures);

    return shaderSources;
  }
}