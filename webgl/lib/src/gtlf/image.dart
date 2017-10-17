import 'dart:typed_data';
import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/buffer_view.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';

class GLTFImage extends GLTFChildOfRootProperty {
  glTF.Image _gltfSource;
  glTF.Image get gltfSource => _gltfSource;

  Uri uri;
  String mimeType;
  GLTFBufferView bufferView;
  Uint8List data;

  GLTFImage._(this._gltfSource)
      : this.uri = _gltfSource.uri,
        this.mimeType = _gltfSource.mimeType,
        this.bufferView = new GLTFBufferView.fromGltf(_gltfSource.bufferView),
        this.data = _gltfSource.data;

  factory GLTFImage.fromGltf(glTF.Image gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFImage._(gltfSource);
  }

  @override
  String toString() {
    return 'GLTFImage{uri: $uri, mimeType: $mimeType, bufferView: $bufferView, data: $data}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GLTFImage &&
              runtimeType == other.runtimeType &&
              _gltfSource == other._gltfSource &&
              uri == other.uri &&
              mimeType == other.mimeType &&
              bufferView == other.bufferView &&
              data == other.data;

  @override
  int get hashCode =>
      _gltfSource.hashCode ^
      uri.hashCode ^
      mimeType.hashCode ^
      bufferView.hashCode ^
      data.hashCode;
}