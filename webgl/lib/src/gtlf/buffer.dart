import 'dart:typed_data';
import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/utils_gltf.dart';

/// Buffer defines the raw data.
///
/// [byteLength] defines the length of the bytes used
///
class GLTFBuffer extends GLTFChildOfRootProperty {
  glTF.Buffer _gltfSource;
  glTF.Buffer get gltfSource => _gltfSource;

  Uri uri;
  int byteLength;

  Uint8List data;

  GLTFBuffer._(this._gltfSource)
      : this.uri = _gltfSource.uri,
        this.byteLength = _gltfSource.byteLength,
        this.data = _gltfSource.data;

  factory GLTFBuffer.fromGltf(glTF.Buffer gltfSource) {
    if (gltfSource == null) return null;
    GLTFBuffer buffer = new GLTFBuffer._(gltfSource);
    return buffer;
  }

  @override
  String toString() {
    return 'GLTFBuffer{uri: $uri, byteLength: $byteLength, data: $data}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GLTFBuffer &&
              runtimeType == other.runtimeType &&
              _gltfSource == other._gltfSource &&
              uri == other.uri &&
              byteLength == other.byteLength &&
              data == other.data;

  @override
  int get hashCode =>
      _gltfSource.hashCode ^ uri.hashCode ^ byteLength.hashCode ^ data.hashCode;
}
