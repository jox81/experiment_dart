import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'package:webgl/src/assets_manager/load_progress_event.dart';
import 'package:webgl/src/assets_manager/loader.dart';

class TextLoader extends FileLoader<String> {
  TextLoader();

  @override
  Future load() async {
    Blob blob = await loadFileAsBlob();

    FileReader fileReader = new FileReader()
      ..onLoadEnd.listen((ProgressEvent event) {
        progressEvent = new LoadProgressEvent(event, filePath);
      });

    fileReader.readAsText(blob);
    await fileReader.onLoadEnd.first;

    result = fileReader.result as String;
    onLoadEndStreamController.add(progressEvent);
  }

  @override
  void loadSync() {
    Completer completer = new Completer<String>();

    Random random = new Random();
    var request = new HttpRequest();
    request.open(
        'POST', '${filePath}?please-dont-cache=${random.nextInt(1000)}',
        async: false);
    request.timeout = 2000;
    request.onProgress.listen((ProgressEvent event) {
      updateLoadProgress(event, filePath);
    });
    request.onLoadEnd.listen((_) {
      if (request.status < 200 || request.status > 299) {
        String fsErr =
            'Error: HTTP Status ${request.status} on resource ' + filePath;
        window.alert('Fatal error getting text ressource (see console)');
        print(fsErr);
        return completer.completeError(fsErr);
      } else {
        completer.complete(request.responseText);
      }
    });
    request.send();

    result = request.responseText;
  }
}
