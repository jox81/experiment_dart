import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'package:webgl/src/assets_manager/loader/loader.dart';
import 'package:webgl/src/utils/utils_http.dart';

class TextLoader extends Loader<String>{

  TextLoader(String path):super(path);

  @override
  Future<String> load() {
    Completer completer = new Completer<String>();

    String assetsPath = UtilsHttp.getWebPath(path);

    Random random = new Random();
    HttpRequest request = new HttpRequest();
    request.open('GET', '$assetsPath?please-dont-cache=${random.nextInt(1000)}', async:true);
    request.onProgress.listen((ProgressEvent event){
      updateLoadProgress(event, path);
    });
    request.timeout = 20000;
    request..onLoadEnd.listen((_) {
      if (request.status < 200 || request.status > 299) {
        String fsErr = 'Error: HTTP Status ${request.status} on resource: $assetsPath';
        window.alert('Fatal error getting text ressource (see console)');
        print(fsErr);
        return completer.completeError(fsErr);
      } else {
        completer.complete(request.responseText);
      }
    })
      ..onError.listen((ProgressEvent event){
        print('Error : url : $path | assetsPath : $assetsPath');
      });
    request.send();

    return completer.future as Future<String>;
  }

  String loadSync(){

    Completer completer = new Completer<String>();

    Random random = new Random();
    var request = new HttpRequest();
    request.open('GET', '${path}?please-dont-cache=${random.nextInt(1000)}', async:false);
    request.timeout = 2000;
    request.onProgress.listen((ProgressEvent event){
      updateLoadProgress(event, path);
    });
    request.onLoadEnd.listen((_) {
      if (request.status < 200 || request.status > 299) {
        String fsErr = 'Error: HTTP Status ${request.status} on resource ' + path;
        window.alert('Fatal error getting text ressource (see console)');
        print(fsErr);
        return completer.completeError(fsErr);
      } else {
        completer.complete(request.responseText);
      }
    });
    request.send();

    return request.responseText;
  }
}