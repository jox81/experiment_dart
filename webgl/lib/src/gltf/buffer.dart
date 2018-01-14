import 'dart:typed_data';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/utils_gltf.dart';

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
  }):super(name){
    GLTFProject.instance.buffers.add(this);
  }

  @override
  String toString() {
    return 'GLTFBuffer{bufferId:$bufferId, uri: $uri, byteLength: $byteLength}';
  }
}
