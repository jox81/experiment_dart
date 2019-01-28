import 'dart:typed_data';
import 'package:webgl/src/gltf/engine/gltf_engine.dart';
import 'package:webgl/src/gltf/property/child_of_root_property.dart';
import 'package:webgl/src/introspection/introspection.dart';

/// Buffer defines the raw data.
///
/// [byteLength] defines the length of the bytes used
///
@reflector
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
    print("###");
    GLTFEngine.activeProject.buffers.add(this);
  }

  @override
  String toString() {
    return 'GLTFBuffer{bufferId:$bufferId, uri: $uri, byteLength: $byteLength}';
  }
}
