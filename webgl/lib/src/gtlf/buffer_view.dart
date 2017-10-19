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
  glTF.BufferView _gltfSource;
  glTF.BufferView get gltfSource => _gltfSource;

  int bufferViewId;

  int _bufferId;
  GLTFBuffer get buffer => gltfProject.buffers[_bufferId];

  int byteLength;
  int byteOffset;
  int byteStride;

  int target;
  BufferType usage;

  GLTFBufferView._(this._gltfSource)
      : this.byteLength = _gltfSource.byteLength,
        this.byteOffset = _gltfSource.byteOffset,
        this.byteStride = _gltfSource.byteStride,
        this.usage = _gltfSource.usage != null ? BufferType.getByIndex(_gltfSource.usage.target):null,
        this.target = _gltfSource.usage != null ? _gltfSource.usage.target: null; // Todo (jpu) : bug if -1 and usage == null. What to do ?

  GLTFBufferView(
      GLTFBuffer projectBuffer,
      this.byteLength,
      this.byteOffset,
      this.byteStride,
      this.target,
      this.usage,
      String name){
    this._bufferId = gltfProject.buffers.indexOf(projectBuffer);
  }

  factory GLTFBufferView.fromGltf(glTF.BufferView gltfSource) {
    if (gltfSource == null) return null;

    GLTFBufferView bufferView = new GLTFBufferView._(gltfSource);
    GLTFBuffer projectBuffer = gltfProject.buffers.firstWhere((n)=>n.gltfSource == gltfSource.buffer);
    bufferView._bufferId = gltfProject.buffers.indexOf(projectBuffer);
    return bufferView;
  }

  @override
  String toString() {
    return 'GLTFBufferView{buffer: $_bufferId, byteLength: $byteLength, byteOffset: $byteOffset, byteStride: $byteStride, target: $target, usage: $usage}';
  }

}