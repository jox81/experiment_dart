import 'dart:typed_data';
import 'package:webgl/src/assets_manager/loaders/bytebuffer_loader.dart';
import 'package:webgl/src/assets_manager/loader.dart';

class GLTFBinLoader extends Loader<Uint8List>{
  GLTFBinLoader();

  @override
  Future<Uint8List> load(covariant String filePath) async {
    return new Uint8List.view(await new ByteBufferLoader().load(filePath));
  }

  @override
  Uint8List loadSync(covariant String filePath) {
    // TODO: implement loadSync
    throw new Exception('not yet implemented');
  }
}