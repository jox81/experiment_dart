import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'package:webgl/src/assets_manager/loader.dart';

class ByteBufferLoader extends Loader<ByteBuffer>{

  ByteBufferLoader();

  @override
  Future<ByteBuffer> load() async {

    Blob blob = await loadFileAsBlob();

    FileReader fileReader = new FileReader();
    var event = fileReader.onLoad.first;
    fileReader.readAsArrayBuffer(blob);
    await event;
    ByteBuffer byteBuffer =  new Uint8List.fromList(fileReader.result).buffer;
    return byteBuffer;
  }

  @override
  ByteBuffer loadSync() {
    // TODO: implement loadSync
    throw new Exception('not yet implemented');
  }
}