import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'dart:typed_data';
import 'package:webgl/src/assets_manager/loader.dart';
import 'package:webgl/src/utils/utils_http.dart';

class ByteBufferLoader extends Loader<ByteBuffer>{

  ByteBufferLoader();

  @override
  Future<ByteBuffer> load(covariant String filePath) {
    Completer completer = new Completer<ByteBuffer>();

    String assetsPath = UtilsHttp.getWebPath(filePath);
    print('url : $filePath | assetsPath : $assetsPath');

    Random random = new Random();
    HttpRequest request = new HttpRequest()..responseType = 'arraybuffer';
    request.open('GET', '$assetsPath?please-dont-cache=${random.nextInt(1000)}',
        async: true);
    request.onProgress.listen((ProgressEvent event){
      updateLoadProgress(event, filePath);
    });
    request.timeout = 2000;
    request.onLoadEnd.listen((_) {
      if (request.status < 200 || request.status > 299) {
        String fsErr =
            'Error: HTTP Status ${request.status} on resource: $assetsPath';
        window.alert('Fatal error getting text ressource (see console)');
        print(fsErr);
        return completer.completeError(fsErr);
      } else {
        ByteBuffer byteBuffer = request.response as ByteBuffer;
        completer.complete(byteBuffer);
      }
    });
    request.send();

    return completer.future as Future<ByteBuffer>;
  }

  @override
  ByteBuffer loadSync(covariant String filePath) {
    // TODO: implement loadSync
    throw new Exception('not yet implemented');
  }
}