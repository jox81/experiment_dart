import 'dart:typed_data';
import 'package:webgl/src/assets_manager/load_progress_event.dart';
import 'package:webgl/src/assets_manager/loaders/bytebuffer_loader.dart';
import 'package:webgl/src/assets_manager/loader.dart';

class GLTFBinLoader extends FileLoader<Uint8List>{
  GLTFBinLoader();

  @override
  Future load() async {
    ByteBufferLoader byteBufferLoader = new ByteBufferLoader()
      ..onLoadProgress.listen(onLoadProgressStreamController.add)
      ..onLoadEnd.listen((LoadProgressEvent event){
        progressEvent = event;
      })
      ..filePath = filePath;

    byteBufferLoader.load();
    await byteBufferLoader.onLoadEnd.first;

    result = new Uint8List.view(byteBufferLoader.result);
    onLoadEndStreamController.add(progressEvent);
  }

  @override
  void loadSync() {
    throw new Exception('not yet implemented');
  }
}