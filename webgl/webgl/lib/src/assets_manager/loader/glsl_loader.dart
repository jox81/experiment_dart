import 'package:webgl/src/assets_manager/loader/loader.dart';
import 'package:webgl/src/assets_manager/loader/text_loader.dart';

class GLSLLoader extends Loader<String>{
  GLSLLoader(String path) : super(path);

  @override
  Future<String> load() async {
    return await new TextLoader(path).load();
  }

  @override
  String loadSync() {
    return new TextLoader(path).loadSync();
  }

}