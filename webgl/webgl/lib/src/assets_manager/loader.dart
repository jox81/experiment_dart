import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:webgl/src/assets_manager/load_progress_event.dart';
import 'package:webgl/src/assets_manager/not_loaded_exception.dart';
import 'package:webgl/src/utils/utils_http.dart';

export 'loader_factory.dart';

abstract class FileLoader<T> {
  final StreamController<LoadProgressEvent> onLoadProgressStreamController =
      new StreamController<LoadProgressEvent>.broadcast();
  Stream<LoadProgressEvent> get onLoadProgress =>
      onLoadProgressStreamController.stream;

  //use this only in sub classes
  final StreamController<LoadProgressEvent> onLoadEndStreamController =
      new StreamController<LoadProgressEvent>.broadcast();
  Stream<LoadProgressEvent> get onLoadEnd =>
      onLoadEndStreamController.stream;

  LoadProgressEvent _progressEvent;
  LoadProgressEvent get progressEvent => _progressEvent;
  @protected
  set progressEvent(LoadProgressEvent value) {
    _progressEvent = value;
  }

  FileLoader();

  String filePath;

  T _result;
  T get result => _result ?? (throw new NotLoadedAssetException());

  @protected
  set result(T value) {
    _result = value;
  }

  @protected
  Future<Blob> loadFileAsBlob() {
    assert(filePath != null || (throw new NotLoadedAssetException('filePath must be set before loading')));

    Completer<Blob> completer = new Completer<Blob>();

    String assetsPath = UtilsHttp.getWebPath(filePath);

    print('Loading file : $assetsPath');

    Random random = new Random();
    HttpRequest request = new HttpRequest()..responseType = 'blob';
    request.open(
        'POST', '$assetsPath?please-dont-cache=${random.nextInt(1000)}',
        async: true);
    request.timeout = 2000;
    request.onLoadEnd.listen((ProgressEvent progressEvent) async {
      if (request.status < 200 || request.status > 299) {
        String fsErr =
            'Error: HTTP Status ${request.status} on resource: $assetsPath';
        window.alert('Fatal error getting text ressource (see console)');
        print(fsErr);
        return completer.completeError(fsErr);
      } else {
        Blob blob = request.response as Blob;
        completer.complete(blob);
      }
    });
    request.onProgress.listen((ProgressEvent progressEvent) {
      updateLoadProgress(progressEvent, filePath);
    });
    request.send();

    return completer.future;
  }

  Future load();
  void loadSync();

  Future<int> getFileSize() {
    assert(filePath != null || (throw new NotLoadedAssetException('filePath must be set before loading')));

    Completer<int> completer = new Completer<int>();

    String assetsPath = UtilsHttp.getWebPath(filePath);

    Random random = new Random();
    HttpRequest request = new HttpRequest()..responseType = 'text';
    request.open(
        'HEAD', '$assetsPath?please-dont-cache=${random.nextInt(1000)}',
        async: true);

    request.timeout = 2000;
    request.onLoadEnd.listen((ProgressEvent event) {
      if (request.status < 200 || request.status > 299) {
        String fsErr =
            'Error: HTTP Status ${request.status} on resource: $assetsPath';
        window.alert('Fatal error getting text ressource (see console)');
        throw (fsErr);
      } else {
        _progressEvent = new LoadProgressEvent(event, filePath);
        completer.complete(event.total);
      }
    });
    request.send();

    return completer.future;
  }

  void updateLoadProgress(ProgressEvent progressEvent, String filePath) {
    _progressEvent = new LoadProgressEvent(progressEvent, filePath);
    onLoadProgressStreamController.add(_progressEvent);
  }

  @override
  String toString() {
    return 'FileLoader{filePath: $filePath}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FileLoader &&
              runtimeType == other.runtimeType &&
              filePath == other.filePath;

  @override
  int get hashCode => filePath.hashCode;





}
