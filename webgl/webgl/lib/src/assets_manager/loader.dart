import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'package:webgl/src/assets_manager/load_progress_event.dart';
import 'package:webgl/src/utils/utils_http.dart';

export 'loader_factory.dart';

abstract class Loader<T> {
  static List<String> _filesToLoad = new List();
  static List<String> get filesToLoad => _filesToLoad;

  static Map<String, LoadProgressEvent> _loadedFiles = new Map();
  static Map<String, LoadProgressEvent> get loadedFiles => _loadedFiles;

  static StreamController<LoadProgressEvent> _onLoadProgressStreamController = new StreamController<LoadProgressEvent>.broadcast();
  static Stream<LoadProgressEvent> get onLoadProgress => _onLoadProgressStreamController.stream;

//  static int totalFileSize = 1;
  static int get totalFileSize => _loadedFiles.values.map((p)=>p.progressEvent.total).reduce((a,b)=>a+b);

  static int _totalFileCount = 0;
  static int get totalFileCount => _loadedFiles.length;

  static int _totalLoadedSize = 0;
  static int get loadedSize => _loadedFiles.values.map((p)=>p.progressEvent.loaded).reduce((a,b)=>a+b);

  Loader();

  Future<T> load(Object data);
  T loadSync(Object data);


  @override
  Future<int> getFileSize(covariant String filePath) {

    Completer<int> completer = new Completer<int>();

    String assetsPath = UtilsHttp.getWebPath(filePath);

    Random random = new Random();
    HttpRequest request = new HttpRequest()..responseType = 'text';
    request.open('HEAD', '$assetsPath?please-dont-cache=${random.nextInt(1000)}',
        async: true);

    request.timeout = 2000;
    request.onLoadEnd.listen((ProgressEvent event) {
      if (request.status < 200 || request.status > 299) {
        String fsErr =
            'Error: HTTP Status ${request.status} on resource: $assetsPath';
        window.alert('Fatal error getting text ressource (see console)');
        throw (fsErr);
      }else{
        completer.complete(event.total);
      }
    });
    request.send();

    return completer.future;
  }

  void updateLoadProgress(ProgressEvent event, String url) {
    LoadProgressEvent existingProgressEvent = _loadedFiles[url];
    LoadProgressEvent progressEvent = new LoadProgressEvent(event, url, existingProgressEvent == null ? _loadedFiles.length : existingProgressEvent.id);
    _loadedFiles[url] = progressEvent;
    _onLoadProgressStreamController.add(progressEvent);
  }
}

