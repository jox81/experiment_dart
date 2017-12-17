import 'dart:typed_data';
import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/utils_gltf.dart';

/// Buffer defines the raw data.
///
/// [byteLength] defines the length of the bytes used
///
class GLTFBuffer extends GLTFChildOfRootProperty {
  static int nextId = 0;

  glTF.Buffer _gltfSource;
  glTF.Buffer get gltfSource => _gltfSource;

  final int bufferId = nextId++;

  Uri uri;
  int byteLength;

  Uint8List data;

  GLTFBuffer._(this._gltfSource, [String name])
      : this.uri = _gltfSource.uri,
        this.byteLength = _gltfSource.byteLength,
        this.data = _gltfSource.data,
        super(name);

  factory GLTFBuffer.fromGltf(glTF.Buffer gltfSource) {
    if (gltfSource == null) return null;
    GLTFBuffer buffer = new GLTFBuffer._(gltfSource);
    return buffer;
  }

  @override
  String toString() {
    return 'GLTFBuffer{uri: $uri, byteLength: $byteLength, data: $data}';
  }

}
