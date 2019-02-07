import 'dart:async';
import 'dart:html';
import 'package:webgl/src/assets_manager/loader/loader.dart';
import 'package:webgl/src/utils/utils_http.dart';

class ImageLoader extends Loader<ImageElement>{
  ImageLoader(String path) : super(path);

  @override
  Future<ImageElement> load() {
    Completer completer = new Completer<ImageElement>();

    String assetsPath = UtilsHttp.getWebPath(path);

    ImageElement image;
    image = new ImageElement()
      ..src = assetsPath
      ..onLoad.listen((e) {
        if(!completer.isCompleted) {
          completer.complete(image);
        }
      })
      ..onError.listen((Event event){
        print('Error : url : $path | assetsPath : $assetsPath');
      });

    return completer.future as Future<ImageElement>;
  }

  @override
  ImageElement loadSync() {
    // TODO: implement loadSync
    return null;
  }
}