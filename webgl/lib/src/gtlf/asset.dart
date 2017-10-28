import 'package:gltf/gltf.dart' as glTF;
import 'dart:html';

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

  // Todo (jpu) : from KronosMesh
  bool hasOwnProperty(String assetUrl) => false; // Todo (jpu)
  Map<String, Blob> blobs = new Map();
  Blob operator [](String index) => blobs[index]; // get
  void operator []=(String index, Blob value) => blobs[index] = value; // set
}