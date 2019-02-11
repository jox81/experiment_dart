import 'dart:async';
import 'package:webgl/src/assets_manager/loader.dart';
import 'dart:convert';
import 'package:webgl/src/assets_manager/loaders/text_loader.dart';

class JsonLoader extends Loader<Map<String, Object>>{
  JsonLoader();

  @override
  Future<Map<String, Object>> load() async {
    Completer completer = new Completer<Map<String, Object>>();
    TextLoader loader = new TextLoader()
      ..onLoadProgress.listen(onLoadProgressStreamController.add)
      ..filePath = filePath;
    String result = await loader.load();
    try {
      final Map<String, Object> json = jsonDecode(result) as Map<String, Object>;
      completer.complete(json);
    } catch (e) {
      completer.completeError(e);
    }

    return completer.future as Future<Map<String, Object>> ;
  }

  @override
  Map<String, Object> loadSync() {
    // TODO: implement loadSync
    throw new Exception('not yet implemented');
  }
}