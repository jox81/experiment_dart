import 'dart:async';
import 'package:webgl/src/assets_manager/loader/loader.dart';
import 'dart:convert';
import 'package:webgl/src/assets_manager/loader/text_loader.dart';

class JsonLoader extends Loader<Map<String, Object>>{
  JsonLoader(String path) : super(path);

  @override
  Future<Map<String, Object>> load() async {
    Completer completer = new Completer<Map<String, Object>>();
    String result = await new TextLoader(path).load();
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
    return null;
  }
}