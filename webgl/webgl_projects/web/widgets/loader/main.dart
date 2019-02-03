import 'dart:async';
import 'dart:html';
import 'package:webgl/engine.dart';
import 'package:webgl/src/assets_manager/assets_manager.dart';
import 'package:webgl_projects/loader.dart';

Future main() async {

  CanvasElement canvas = new CanvasElement();
  GLTFEngine engine = new GLTFEngine(canvas);

  Loader loader = new Loader();

  AssetsManager assetsManager = new AssetsManager();
  assetsManager.onLoadProgress.listen((LoadProgressEvent loadprogressEvent){
    loader.showProgress(loadprogressEvent);
    print("name : ${loadprogressEvent.name}");
    print("lengthComputable : ${loadprogressEvent.progressEvent.lengthComputable}");
    print("loaded : ${loadprogressEvent.progressEvent.loaded} octets");
    print("total : ${loadprogressEvent.progressEvent.total} octets");
    print("% : ${loadprogressEvent.progressEvent.loaded / loadprogressEvent.progressEvent.total * 100}");
  });

  String gltf = '/gltf/projects/archi/model_01/model_01.gltf';
  await assetsManager.loadGLTFProject(gltf);

  String bin = '/webgl/projects/jerome/projects/maison/maison_ivoz.bin';
  await assetsManager.loadGltfBinResource(bin);

  print('done');
}