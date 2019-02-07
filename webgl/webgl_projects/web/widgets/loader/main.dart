import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'package:webgl/engine.dart';
import 'package:webgl/src/assets_manager/assets_manager.dart';
import 'package:webgl_projects/loader.dart';

Future main() async {

  CanvasElement canvas = new CanvasElement();
  GLTFEngine engine = new GLTFEngine(canvas);

  Loader loader = new Loader();

  AssetManager assetManager = new AssetManager();
  assetManager.onLoadProgress.listen((LoadProgressEvent loadprogressEvent){
    loader.showProgress(loadprogressEvent);
    print(loadprogressEvent);
  });

  String gltf = '/gltf/projects/archi/model_01/model_01.gltf';
  await assetManager.loadGLTFProject(gltf);

  String bin = '/webgl/projects/jerome/projects/maison/maison_ivoz.bin';
  await assetManager.loadGltfBinResource(bin);

  print('done');

  loadTextResource(gltf);
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