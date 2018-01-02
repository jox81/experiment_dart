import 'dart:typed_data';
import 'package:webgl/src/gltf/buffer_view.dart';
import 'package:webgl/src/gltf/utils_gltf.dart';

class GLTFImage extends GLTFChildOfRootProperty {
  static int nextId = 0;
  final int sourceId = nextId++;

  Uri uri;
  String mimeType;
  GLTFBufferView bufferView;
  Uint8List data;// Todo (jpu) : data is automatticaly filled if image is embed in base64. but not if uri is set as a path

  GLTFImage({this.uri, this.mimeType, this.bufferView, this.data, String name})
      : super(name);

  @override
  String toString() {
    return 'GLTFImage{uri: $uri, mimeType: $mimeType, bufferView: $bufferView, data: $data}';
  }

}