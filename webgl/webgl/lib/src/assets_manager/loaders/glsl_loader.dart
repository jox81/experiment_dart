import 'package:webgl/src/assets_manager/loader.dart';
import 'package:webgl/src/assets_manager/loaders/text_loader.dart';

class GLSLLoader extends Loader<String>{
  GLSLLoader();

  @override
  Future<String> load(covariant String filePath) async {
    return await new TextLoader().load(filePath);
  }

  @override
  String loadSync(covariant String filePath) {
    return new TextLoader().loadSync(filePath);
  }
}