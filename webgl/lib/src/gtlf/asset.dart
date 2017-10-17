import 'package:gltf/gltf.dart' as glTF;

class GLTFAsset{
  glTF.Asset _gltfSource;
  glTF.Asset get gltfSource => _gltfSource;

  String version;

  GLTFAsset();

  factory GLTFAsset.fromGltf(glTF.Asset gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFAsset()
      ..version = gltfSource.version;
  }
}