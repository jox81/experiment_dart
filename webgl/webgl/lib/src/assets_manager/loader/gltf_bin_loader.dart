import 'dart:typed_data';
import 'package:webgl/src/assets_manager/loader/bytebuffer_loader.dart';
import 'package:webgl/src/assets_manager/loader/loader.dart';

class GLTFBinLoader extends Loader<Uint8List>{
  GLTFBinLoader(String path) : super(path);

  @override
  Future<Uint8List> load() async {
    return new Uint8List.view(await new ByteBufferLoader(path).load());
  }

  @override
  Uint8List loadSync() {
    // TODO: implement loadSync
    return null;
  }
}