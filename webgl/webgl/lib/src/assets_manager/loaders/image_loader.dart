import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'package:webgl/src/assets_manager/loader.dart';
import 'package:webgl/src/utils/utils_http.dart';

class ImageLoader extends Loader<ImageElement>{
  ImageLoader();

  ///Load a single image from an URL
  @override
  Future<ImageElement> load() async {
    Blob blob = await loadFileAsBlob();
    return _loadBlobAsImg(blob);
  }

  Future<ImageElement> _loadBlobAsImg(Blob blob) async {
    ImageElement image = new ImageElement();
    String dataUri = await _loadBlobAsDataUri(blob);
    image.src = dataUri;
    await image.onLoad.first;
    return image;
  }

  Future<String> _loadBlobAsDataUri(Blob blob) async{
    FileReader fileReader = new FileReader();
    fileReader.readAsDataUrl(blob);
    await fileReader.onLoadEnd.first;
    return fileReader.result;
  }

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
  ImageElement loadSync() {
    super.loadSync();
    String assetsPath = UtilsHttp.getWebPath(filePath);

    return new ImageElement()
      ..src = assetsPath
    ..onLoad.listen((e){
      updateLoadProgress(null, filePath);
    });
  }

  List<ImageElement> loadImages(List<String> filePaths) {
    List<ImageElement> images = [];

    for(String filePath in filePaths) {
      this.filePath = filePath;
      images.add(loadSync());
    }

    return images;
  }
}