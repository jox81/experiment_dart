import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'package:webgl/src/assets_manager/loader.dart';
import 'package:webgl/src/utils/utils_http.dart';

class ImageLoader extends Loader<ImageElement>{
  ImageLoader();

  ///Load a single image from an URL
  @override
  Future<ImageElement> load(covariant String filePath) {
    Completer<ImageElement> completer = new Completer<ImageElement>();

    String assetsPath = UtilsHttp.getWebPath(filePath);
    print('url : $filePath | assetsPath : $assetsPath');

    Random random = new Random();
    HttpRequest request = new HttpRequest()..responseType = 'arraybuffer';
    request.timeout = 2000;
    request.open('GET', '$assetsPath?please-dont-cache=${random.nextInt(1000)}',
        async: true);
    request.onProgress.listen((ProgressEvent event){
      updateLoadProgress(event, filePath);
    });
    request.onLoadEnd.listen((_) {
      if (request.status < 200 || request.status > 299) {
        String fsErr =
            'Error: HTTP Status ${request.status} on resource: $assetsPath';
        window.alert('Fatal error getting text ressource (see console)');
        print(fsErr);
        return completer.completeError(fsErr);
      } else {
        Blob blob = new Blob([request.response]);
        completer.complete(loadBlobAsImg(blob));
      }
    });
    request.send();

    return completer.future;
  }

  Future<ImageElement> loadBlobAsImg(Blob blob) async {
    ImageElement image = new ImageElement();
    String dataUri = await loadBlobAsDataUri(blob);
    var loaded = image.onLoad.first;
    image.src = dataUri;
    return loaded.then((_) => image);
  }

  Future<String> loadBlobAsDataUri(Blob blob) async{
    var fileReader = new FileReader();
    fileReader.readAsDataUrl(blob);
    ProgressEvent event = await fileReader.onLoad.first;
    return fileReader.result;
  }

//  loadBlobAsImg(blob).then((img) => canvas.drawImage(img));

  ///Load a single image from an URL
  @override
  Future<ImageElement> loadDirect(covariant String filePath) {
    Completer completer = new Completer<ImageElement>();

    String assetsPath = UtilsHttp.getWebPath(filePath);

    ImageElement image;
    image = new ImageElement()
      ..src = assetsPath
      ..onLoad.listen((e) {
        if(!completer.isCompleted) {
          updateLoadProgress(null, filePath);
          completer.complete(image);
        }
      })
      ..onError.listen((Event event){
        print('Error : url : $filePath | assetsPath : $assetsPath');
      });

    return completer.future as Future<ImageElement>;
  }

  @override
  ImageElement loadSync(covariant String filePath) {
    String assetsPath = UtilsHttp.getWebPath(filePath);

    return new ImageElement()
      ..src = assetsPath
    ..onLoad.listen((e){
      updateLoadProgress(null, filePath);
    });
  }

  List<ImageElement> loadImages(List<String> paths) {
    List<ImageElement> images = [];

    for(String url in paths) {
      images.add(loadSync(url));
    }

    return images;
  }
}