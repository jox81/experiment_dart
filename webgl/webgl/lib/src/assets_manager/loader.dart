import 'dart:html';
import 'dart:async';
import 'package:webgl/src/assets_manager/load_progress_event.dart';

abstract class Loader<T> {
  static List<String> _filesToLoad = new List();
  static List<String> get filesToLoad => _filesToLoad;

  static Map<String, LoadProgressEvent> _loadedFiles = new Map();
  static Map<String, LoadProgressEvent> get loadedFiles => _loadedFiles;

  static StreamController<LoadProgressEvent> _onLoadProgressStreamController = new StreamController<LoadProgressEvent>.broadcast();
  static Stream<LoadProgressEvent> get onLoadProgress => _onLoadProgressStreamController.stream;

  Loader();

  Future<T> load(Object data);
  T loadSync(Object data);

  void updateLoadProgress(ProgressEvent event, String url) {
    LoadProgressEvent existingProgressEvent = _loadedFiles[url];
    LoadProgressEvent progressEvent = new LoadProgressEvent(event, url, existingProgressEvent == null ? _loadedFiles.length : existingProgressEvent.id);
    _loadedFiles[url] = progressEvent;
    _onLoadProgressStreamController.add(progressEvent);
  }
}