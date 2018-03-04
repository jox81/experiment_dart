import 'package:test_webgl/src/gltf/buffer.dart';
import 'package:test_webgl/src/gltf/project.dart';
import 'package:test_webgl/src/gltf/utils_gltf.dart';
import 'package:test_webgl/src/webgl_objects/datas/webgl_enum.dart';

/// Bufferviews define a segment of the buffer data and define broadly what kind of data lives
/// there using some obscure shortcodes for usage/target.
/// A bufferView can take the whole buffer and be a one part only.
///
/// [buffer] defines the buffer to read
/// [byteLength] defines the length of the bytes used
/// [byteOffset] defines the starting byte to read datas
/// [byteStride] defines // Todo (jpu) : ?
///
/// [usage] define the bufferType : ARRAY_BUFFER | ELEMENT_ARRAY_BUFFER
///
class GLTFBufferView /*extends GLTFChildOfRootProperty*/ {
  static int nextId = 0;
  final int bufferViewId = nextId++;

  GLTFBuffer _buffer;
  GLTFBuffer get buffer => _buffer;
  set buffer(GLTFBuffer value) {
    _buffer = value;
  }

  int byteOffset;
  int byteLength;
  int byteStride;//step to next element(next vec3 is at + ( 3 components * 4 bytes) = + 12

  /// BufferType usage
  int target;
  /// BufferType usage
  int usage;

  GLTFBufferView({
    GLTFBuffer buffer,
    this.byteLength,
    this.byteOffset,
    this.byteStride,
    this.usage,
    this.target,
    String name : ''}):
      this._buffer = buffer/*,*/
      /*super(name)*/{
//    GLTFProject.instance.bufferViews.add(this);
  }

  @override
  String toString() {
    return 'GLTFBufferView{bufferViewId:$bufferViewId, buffer: ${_buffer.bufferId}, byteOffset: $byteOffset, byteLength: $byteLength,  byteStride: $byteStride, target: ${BufferType.getByIndex(target)}, usage: ${BufferType.getByIndex(usage)}}';
  }

}