import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'package:webgl/src/assets_manager/load_progress_event.dart';
import 'package:webgl/src/assets_manager/loader.dart';

class ByteBufferLoader extends FileLoader<ByteBuffer>{

  ByteBufferLoader();

  @override
  Future load() async {
    Blob blob = await loadFileAsBlob();

    FileReader fileReader = new FileReader()
    ..onLoadEnd.listen((ProgressEvent event){
      progressEvent = new LoadProgressEvent(event, filePath);
    });

    fileReader.readAsArrayBuffer(blob);
    await fileReader.onLoadEnd.first;

    result = new Uint8List.fromList(fileReader.result).buffer;
    onLoadEndStreamController.add(progressEvent);
  }

  @override
  void loadSync() {
    throw new Exception('not yet implemented');
  }
}