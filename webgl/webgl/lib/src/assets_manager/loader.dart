import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:webgl/src/assets_manager/load_progress_event.dart';
import 'package:webgl/src/utils/utils_http.dart';

export 'loader_factory.dart';

abstract class Loader<T> {

  final StreamController<LoadProgressEvent> onLoadProgressStreamController = new StreamController<LoadProgressEvent>.broadcast();
  Stream<LoadProgressEvent> get onLoadProgress => onLoadProgressStreamController.stream;

  LoadProgressEvent _progressEvent;

  Loader();

  String filePath;

  @protected
  Future<Blob> loadFileAsBlob(){
    assert(filePath != null||(throw 'filePath must be set before'));

    Completer<Blob> completer = new Completer<Blob>();

    String assetsPath = UtilsHttp.getWebPath(filePath);

    print('temp : $assetsPath');

    Random random = new Random();
    HttpRequest request = new HttpRequest()..responseType = 'blob';
    request.open('POST', '$assetsPath?please-dont-cache=${random.nextInt(1000)}',
        async: true);
    request.timeout = 2000;
    request.onLoadEnd.listen((_)async  {
      if (request.status < 200 || request.status > 299) {
        String fsErr =
            'Error: HTTP Status ${request.status} on resource: $assetsPath';
        window.alert('Fatal error getting text ressource (see console)');
        print(fsErr);
        return completer.completeError(fsErr);
      } else {

        Blob blob = request.response;
        completer.complete(blob);
      }
    });
    request.onProgress.listen((ProgressEvent event){
      updateLoadProgress(event, filePath);
    });
    request.send();

    return completer.future;
  }

  @mustCallSuper
  Future<T> load(){
    assert(filePath != null||(throw 'FilePath must be set before'));
  }
  @mustCallSuper
  T loadSync(){
    assert(filePath != null||(throw 'FilePath must be set before'));
  }
  @override
  Future<int> getFileSize() {

    assert(filePath != null||(throw 'FilePath must be set before'));

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
  void updateLoadProgress(ProgressEvent event, String filePath) {
    _progressEvent = new LoadProgressEvent(event, filePath);
    onLoadProgressStreamController.add(_progressEvent);
  }
}

