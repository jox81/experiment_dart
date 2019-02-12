import 'package:webgl/src/assets_manager/load_progress_event.dart';
import 'package:webgl/src/assets_manager/loader.dart';
import 'package:webgl/src/assets_manager/loaders/text_loader.dart';

class GLSLLoader extends FileLoader<String>{
  GLSLLoader();

  @override
  Future load() async {
    TextLoader textLoader = new TextLoader()
      ..onLoadEnd.listen((LoadProgressEvent event) {
        progressEvent = event;
      })
      ..onLoadProgress.listen(onLoadProgressStreamController.add)
      ..filePath = filePath;

    textLoader.load();
    await textLoader.onLoadEnd.first;

    result = textLoader.result;
    onLoadEndStreamController.add(progressEvent);
  }

  @override
  void loadSync() {
    TextLoader textLoader = new TextLoader()
      ..onLoadProgress.listen(onLoadProgressStreamController.add)
      ..filePath = filePath;

    textLoader.loadSync();
    result = textLoader.result;

    onLoadEndStreamController.add(progressEvent);
  }
}