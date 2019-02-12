import 'package:webgl/src/assets_manager/load_progress_event.dart';
import 'package:webgl/src/assets_manager/loader.dart';
import 'package:webgl/src/assets_manager/loaders/glsl_loader.dart';
import 'package:webgl/src/shaders/shader_infos.dart';
import 'package:webgl/src/shaders/shader_source.dart';

class ShaderSourceLoader extends FileLoader<ShaderSource>{

  ShaderInfos shaderInfos;

  ShaderSourceLoader();

  @override
  Future load() async {
    {
      filePath = '';
      assert(shaderInfos!=null||(throw 'shaderInfos must be set before'));
    }

    ShaderSource shaderSource = new ShaderSource(shaderInfos);

    GLSLLoader vsfileLoader = new GLSLLoader()
    ..onLoadProgress.listen(onLoadProgressStreamController.add)
      ..onLoadEnd.listen((LoadProgressEvent event) {
        progressEvent = event;
      });
    await (vsfileLoader..filePath = shaderSource.vertexShaderPath).load();
    shaderSource.vsCode = vsfileLoader.result;

    GLSLLoader fsfileLoader = new GLSLLoader()
      ..onLoadProgress.listen(onLoadProgressStreamController.add)
      ..onLoadEnd.listen((LoadProgressEvent event) {
        progressEvent = event;
      });
    await (fsfileLoader..filePath = shaderSource.fragmentShaderPath).load();
    shaderSource.fsCode = fsfileLoader.result;

    result = shaderSource;
    onLoadEndStreamController.add(progressEvent);// Todo (jpu) : wrong, should be both files emited, not only one
  }

  @override
  ShaderSource loadSync() {
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

        shaderSourceLoader.load();
        await shaderSourceLoader.onLoadEnd.first;

        ShaderSource shaderSource = shaderSourceLoader.result;
        shaderSources.add(shaderSource);
      }());//parallel loading
    }

    await Future.wait<dynamic>(futures);

    return shaderSources;
  }
}