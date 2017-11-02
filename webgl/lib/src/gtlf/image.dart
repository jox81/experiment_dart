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
  int sourceId;

  GLTFImage._(this._gltfSource, [String name])
      : this.uri = _gltfSource.uri,
        this.mimeType = _gltfSource.mimeType,
        this.bufferView = new GLTFBufferView.fromGltf(_gltfSource.bufferView),
        this.data = _gltfSource.data,
        super(name);

  factory GLTFImage.fromGltf(glTF.Image gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFImage._(gltfSource);
  }

  @override
  String toString() {
    return 'GLTFImage{uri: $uri, mimeType: $mimeType, bufferView: $bufferView, data: $data}';
  }

}