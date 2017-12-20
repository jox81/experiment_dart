import 'dart:typed_data';
import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/utils_gltf.dart';

/// Buffer defines the raw data.
///
/// [byteLength] defines the length of the bytes used
///
class GLTFBuffer extends GLTFChildOfRootProperty {
  static int nextId = 0;
  final int bufferId = nextId++;

  Uri uri;
  int byteLength;

  Uint8List data;

  GLTFBuffer({
    this.uri,
    this.byteLength,
    this.data,
    String name : ''
  }):super(name);

  @override
  String toString() {
    return 'GLTFBuffer{uri: $uri, byteLength: $byteLength, data: $data}';
  }
}
