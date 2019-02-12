import 'dart:async';
import 'package:webgl/src/assets_manager/load_progress_event.dart';
import 'package:webgl/src/assets_manager/loader.dart';
import 'dart:convert';
import 'package:webgl/src/assets_manager/loaders/text_loader.dart';

class JsonLoader extends FileLoader<Map<String, Object>>{
  JsonLoader();

  @override
  Future load() async {
    TextLoader fileLoader = new TextLoader()
      ..onLoadProgress.listen(onLoadProgressStreamController.add)
      ..onLoadEnd.listen((LoadProgressEvent event) {
        progressEvent = event;
      })
      ..filePath = filePath;

    fileLoader.load();
    await fileLoader.onLoadEnd.first;

    try {
      final Map<String, Object> json = jsonDecode(fileLoader.result) as Map<String, Object>;

      result = json;
      onLoadEndStreamController.add(progressEvent);

    } catch (e) {
    }
  }

  @override
  void loadSync() {
    throw new Exception('not yet implemented');
  }
}