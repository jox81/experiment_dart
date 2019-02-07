import 'dart:html';

import 'package:webgl/src/assets_manager/loader/load_progress_event.dart';

abstract class Loader<T> {
  final String path;

  Loader(this.path);

  Future<T> load();
  T loadSync();

  void updateLoadProgress(ProgressEvent event, String url) {
    // Todo (jpu) :
//    LoadProgressEvent existingProgressEvent = _loadedFiles[url];
//    LoadProgressEvent progressEvent = new LoadProgressEvent(this, event, url, existingProgressEvent == null ? _loadedFiles.length : existingProgressEvent.id);
//    _loadedFiles[url] = progressEvent;
//    _onLoadProgressStreamController.add(progressEvent);
  }
}