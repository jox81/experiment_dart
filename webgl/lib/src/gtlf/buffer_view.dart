import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/buffer.dart';
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
  glTF.BufferView _gltfSource;
  glTF.BufferView get gltfSource => _gltfSource;

  int get bufferId => null;// Todo (jpu) :
  GLTFBuffer buffer;

  int byteLength;
  int byteOffset;
  int byteStride;

  int target;
  BufferType usage;

  GLTFBufferView._(this._gltfSource)
      : this.byteLength = _gltfSource.byteLength,
        this.byteOffset = _gltfSource.byteOffset,
        this.byteStride = _gltfSource.byteStride,
        this.buffer = new GLTFBuffer.fromGltf(_gltfSource.buffer),
        this.usage = _gltfSource.usage != null ? BufferType.getByIndex(_gltfSource.usage.target):null,
        this.target = _gltfSource.usage != null ? _gltfSource.usage.target: null; // Todo (jpu) : bug if -1 and usage == null. What to do ?

  GLTFBufferView(
      this.buffer,
      this.byteLength,
      this.byteOffset,
      this.byteStride,
      this.target,
      this.usage,
      String name);

  factory GLTFBufferView.fromGltf(glTF.BufferView gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFBufferView._(gltfSource);
  }

  @override
  String toString() {
    return 'GLTFBufferView{buffer: $bufferId, byteLength: $byteLength, byteOffset: $byteOffset, byteStride: $byteStride, target: $target, usage: $usage}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GLTFBufferView &&
              runtimeType == other.runtimeType &&
              _gltfSource == other._gltfSource &&
              buffer == other.buffer &&
              byteLength == other.byteLength &&
              byteOffset == other.byteOffset &&
              byteStride == other.byteStride &&
              target == other.target &&
              usage == other.usage;

  @override
  int get hashCode =>
      _gltfSource.hashCode ^
      buffer.hashCode ^
      byteLength.hashCode ^
      byteOffset.hashCode ^
      byteStride.hashCode ^
      target.hashCode ^
      usage.hashCode;
}