import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'package:webgl/engine.dart';
import 'package:webgl/src/assets_manager/assets_manager.dart';
import 'package:webgl/src/assets_manager/load_progress_event.dart';
import 'package:webgl_projects/loader.dart';

Future main() async {

  Loader loader = new Loader();

  CanvasElement canvas = new CanvasElement();
  GLTFEngine engine = new GLTFEngine(canvas);
  AssetManager assetManager = Engine.assetManager;
  assetManager.onLoadProgress.listen((LoadProgressEvent loadProgressEvent){
//    loader.showProgress(loadProgressEvent);
  });

  engine.init();

  String gltf = '/gltf/projects/archi/model_01/model_01.gltf';
  await assetManager.loadGLTFProject(gltf);

  String bin = '/webgl/projects/jerome/projects/maison/maison_ivoz.bin';
  await assetManager.loadGltfBinResource(bin);

  print('done');

  loadTextResource(gltf);

  print('loadedFiles length: ${assetManager.loadedFiles.values.length}');
  print('loadedFiles size: ${assetManager.loadedFiles.values.map((p)=> p.progressEvent.total).reduce((v,e)=>v+e)}');

  (assetManager.loadedFiles.values.toList()..sort((a, b) => a.progressEvent.total.compareTo(b.progressEvent.total))).forEach((e){
    print('${e.id} : ${e.progressEvent.total} : ${e.name}');
  });
}

///Load a text resource from a file over the network
Future<String> loadTextResource (String url) {
  Completer completer = new Completer<String>();

  String assetsPath = url;//getWebPath(url);

  Random random = new Random();
  HttpRequest request = new HttpRequest();
  request.open('HEAD', '$assetsPath?please-dont-cache=${random.nextInt(1000)}', async:true);
  request.timeout = 20000;
  request.onLoadEnd.listen((_) {
    if (request.status < 200 || request.status > 299) {
      String fsErr = 'Error: HTTP Status ${request.status} on resource: $assetsPath';
      window.alert('Fatal error getting text ressource (see console)');
      print(fsErr);
      return completer.completeError(fsErr);
    } else {
      var v = request.responseHeaders['content-length'];
      completer.complete(v);
    }
  });
  request.onError.listen((ProgressEvent event){
      print('Error : url : $url | assetsPath : $assetsPath');
    });
  request.send();

  return completer.future as Future<String>;
}