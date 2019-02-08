import 'dart:async';
import 'dart:html';
import 'package:webgl/src/assets_manager/loader.dart';
import 'package:webgl/src/utils/utils_http.dart';

class ImageLoader extends Loader<ImageElement>{
  ImageLoader();

  ///Load a single image from an URL
  @override
  Future<ImageElement> load(covariant String filePath) {
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