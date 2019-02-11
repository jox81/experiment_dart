import 'package:webgl/src/assets_manager/loader.dart';
import 'package:webgl/src/assets_manager/loaders/text_loader.dart';

class GLSLLoader extends Loader<String>{
  GLSLLoader();

  @override
  Future<String> load() async {
    TextLoader textLoader = new TextLoader()
      ..onLoadProgress.listen(onLoadProgressStreamController.add)
      ..filePath = filePath;
    return await textLoader.load();
  }

  @override
  String loadSync() {
    TextLoader textLoader = new TextLoader()
      ..onLoadProgress.listen(onLoadProgressStreamController.add)
      ..filePath = filePath;
    return textLoader.loadSync();
  }
}