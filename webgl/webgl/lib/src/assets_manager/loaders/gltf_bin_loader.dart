import 'dart:typed_data';
import 'package:webgl/src/assets_manager/loaders/bytebuffer_loader.dart';
import 'package:webgl/src/assets_manager/loader.dart';

class GLTFBinLoader extends Loader<Uint8List>{
  GLTFBinLoader();

  @override
  Future<Uint8List> load() async {
    ByteBufferLoader byteBufferLoader = new ByteBufferLoader()
      ..onLoadProgress.listen(onLoadProgressStreamController.add)
      ..filePath = filePath;
    return new Uint8List.view(await byteBufferLoader.load());
  }

  @override
  Uint8List loadSync() {
    // TODO: implement loadSync
    throw new Exception('not yet implemented');
  }
}