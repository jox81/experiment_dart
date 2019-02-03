import 'dart:async';
import 'dart:html';
import 'package:webgl/src/assets_manager/assets_manager.dart';
import 'package:webgl_projects/loader.dart';

Future main() async {

  Loader loader = new Loader();

  AssetsManager assetsManager = new AssetsManager();
  assetsManager.onProgress.listen((ProgressEvent progressEvent){
    loader.showProgress(progressEvent);
    print("lengthComputable : ${progressEvent.lengthComputable}");
    print("loaded : ${progressEvent.loaded} octets");
    print("total : ${progressEvent.total} octets");
    print("% : ${progressEvent.loaded / progressEvent.total * 100}");
  });

  String packagesPath = '/gltf/projects/archi/model_01/model_01.gltf';
  assetsManager.loadGLTFProject(packagesPath);
}