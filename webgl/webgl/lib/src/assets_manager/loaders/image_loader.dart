import 'dart:async';
import 'dart:html';
import 'package:webgl/src/assets_manager/load_progress_event.dart';
import 'package:webgl/src/assets_manager/loader.dart';
import 'package:webgl/src/utils/utils_http.dart';

class ImageLoader extends FileLoader<ImageElement>{
  ImageLoader();

  ///Load a single image from an URL
  @override
  Future load() async {
    Blob blob = await loadFileAsBlob();
    ImageElement image = await _loadBlobAsImg(blob);

    result = image;
    onLoadEndStreamController.add(progressEvent);
  }

  Future<ImageElement> _loadBlobAsImg(Blob blob) async {
    ImageElement image = new ImageElement();
    String dataUri = await _loadBlobAsDataUri(blob);
    image.src = dataUri;
    await image.onLoad.first;
    return image;
  }

  Future<String> _loadBlobAsDataUri(Blob blob) async{
    FileReader fileReader = new FileReader()
      ..onLoad.listen((ProgressEvent event){
        progressEvent = new LoadProgressEvent(event, filePath);
      })
      ..onError.listen((ProgressEvent event){
        throw '_loadBlobAsDataUri error';
      });
    fileReader.readAsDataUrl(blob);
    await fileReader.onLoadEnd.first;
    return fileReader.result;
  }

  ///Load a single image from an URL
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
  void loadSync() {
    String assetsPath = UtilsHttp.getWebPath(filePath);

    result =  new ImageElement()
      ..src = assetsPath
    ..onLoad.listen((e){
      updateLoadProgress(null, filePath);
    });
  }

  List<ImageElement> loadImages(List<String> filePaths) {
    List<ImageElement> images = [];

    for(String filePath in filePaths) {
      this.filePath = filePath;
      loadSync();
      images.add(result);
    }

    return images;
  }
}