import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/accessor_sparse.dart';
import 'package:webgl/src/gtlf/buffer_view.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

/// The accessors are what actually define the format of the data and
/// use codes for "componentType"
/// https://github.com/KhronosGroup/glTF/tree/master/specification/2.0#accessors
///
/// [componentType]
/// ex:
/// > 5123 is an unsigned short (2 bytes)
/// > 5126 is single precision float (4 bytes)
/// [type] defines whether they should be read singly ("SCALAR") or in vector groups (e.g. "VEC3")
///
class GLTFAccessor extends GLTFChildOfRootProperty {
  glTF.Accessor _gltfSource;
  glTF.Accessor get gltfSource => _gltfSource;

  int get accessorId => null;// Todo (jpu) :

  final int byteOffset;
  final ShaderVariableType componentType;
  final String typeString;
  final ShaderVariableType type;
  final int count;
  final bool normalized;
  final List<num> max;
  final List<num> min;
  final GLTFAccessorSparse sparse;

  // Todo (jpu) :
  GLTFBufferView get bufferView => gltfProject.bufferViews[0];
  int get components => _gltfSource.components;
  int get componentLength => _gltfSource.componentLength;
  int get elementLength => _gltfSource.elementLength;
  int get byteStride => _gltfSource.byteStride;
  int get byteLength => _gltfSource.byteLength;
  bool get isUnit => _gltfSource.isUnit;
  bool get isXyzSign => _gltfSource.isXyzSign;

  GLTFAccessor._(this._gltfSource)
      : this.byteOffset = _gltfSource.byteOffset,
        this.componentType =
        ShaderVariableType.getByIndex(_gltfSource.componentType),
        this.count = _gltfSource.count,
        this.typeString = _gltfSource.type,
        this.type = ShaderVariableType.getByComponentAndType(
            ShaderVariableType.getByIndex(_gltfSource.componentType).name,
            _gltfSource.type),
        this.normalized = _gltfSource.normalized,
        this.max = _gltfSource.max,
        this.min = _gltfSource.min,
        this.sparse = _gltfSource.sparse != null
            ? new GLTFAccessorSparse.fromGltf(_gltfSource.sparse)
            : null;

  GLTFAccessor(
      this.byteOffset,
      this.componentType,
      this.typeString,
      this.type,
      this.count,
      this.normalized,
      this.max,
      this.min,
      this.sparse);

  factory GLTFAccessor.fromGltf(glTF.Accessor gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFAccessor._(gltfSource);
  }



  @override
  String toString() {
    return 'GLTFAccessor{byteOffset: $byteOffset, componentType: $componentType, typeString: $typeString, , type: $type, count: $count, normalized: $normalized, max: $max, min: $min, sparse: $sparse}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GLTFAccessor &&
              runtimeType == other.runtimeType &&
              _gltfSource == other._gltfSource &&
              byteOffset == other.byteOffset &&
              componentType == other.componentType &&
              typeString == other.typeString &&
              type == other.type &&
              count == other.count &&
              normalized == other.normalized &&
              max == other.max &&
              min == other.min &&
              sparse == other.sparse;

  @override
  int get hashCode =>
      _gltfSource.hashCode ^
      byteOffset.hashCode ^
      componentType.hashCode ^
      typeString.hashCode ^
      type.hashCode ^
      count.hashCode ^
      normalized.hashCode ^
      max.hashCode ^
      min.hashCode ^
      sparse.hashCode;
}
