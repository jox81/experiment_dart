import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/buffer.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

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
class GLTFBufferView extends GLTFChildOfRootProperty {
  static int nextId = 0;
  final int bufferViewId = nextId++;

  GLTFBuffer _buffer;
  GLTFBuffer get buffer => _buffer;
  set buffer(GLTFBuffer value) {
    _buffer = value;
  }

  int byteLength;
  int byteOffset;
  int byteStride;

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
      this._buffer = buffer,
      super(name);

  @override
  String toString() {
    return 'GLTFBufferView{buffer: ${_buffer.bufferId}, byteLength: $byteLength, byteOffset: $byteOffset, byteStride: $byteStride, target: $target, usage: $usage}';
  }

}