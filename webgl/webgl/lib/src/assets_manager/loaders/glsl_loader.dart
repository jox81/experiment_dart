import 'package:webgl/src/assets_manager/loader.dart';
import 'package:webgl/src/assets_manager/loaders/text_loader.dart';

class GLSLLoader extends Loader<String>{
  GLSLLoader(String filePath) : super(filePath);

  @override
  Future<String> load() async {
    return await new TextLoader(filePath).load();
  }

  @override
  String loadSync() {
    return new TextLoader(filePath).loadSync();
  }

}