import 'dart:html';

class GLTFAsset{
  String version;

  GLTFAsset(this.version);

  // Todo (jpu) : from KronosMesh
  bool hasOwnProperty(String assetUrl) => false; // Todo (jpu)
  Map<String, Blob> blobs = new Map();
  Blob operator [](String index) => blobs[index]; // get
  void operator []=(String index, Blob value) => blobs[index] = value; // set
}