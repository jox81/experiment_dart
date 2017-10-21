import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/accessor_sparse.dart';
import 'package:webgl/src/gtlf/buffer_view.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

// Accessor types
const String SCALAR = 'SCALAR';
const String VEC2 = 'VEC2';
const String VEC3 = 'VEC3';
const String VEC4 = 'VEC4';
const String MAT2 = 'MAT2';
const String MAT3 = 'MAT3';
const String MAT4 = 'MAT4';

const Map<String, int> ACCESSOR_TYPES_LENGTHS = const <String, int>{
  SCALAR: 1,
  VEC2: 2,
  VEC3: 3,
  VEC4: 4,
  MAT2: 4,
  MAT3: 9,
  MAT4: 16
};

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

  int accessorId;

  final int byteOffset;
  final ShaderVariableType componentType;
  final String typeString;
  final int typeLength;
  final ShaderVariableType type;
  final int count;
  final bool normalized;
  final List<num> max;
  final List<num> min;
  final GLTFAccessorSparse sparse;

  int _bufferViewId;
  GLTFBufferView get bufferView => _bufferViewId != null ? gltfProject.bufferViews[_bufferViewId] : null;

  int get components => _gltfSource.components;
  int get componentLength => _gltfSource.componentLength; ///byte count of the component
  int get elementLength => _gltfSource.elementLength;
  int get byteStride => _gltfSource.byteStride;
  int get byteLength => _gltfSource.byteLength;
  bool get isUnit => _gltfSource.isUnit;
  bool get isXyzSign => _gltfSource.isXyzSign;

  // Todo (jpu) : do better check!!!
  GLTFAccessor._(this._gltfSource)
      : this.byteOffset = _gltfSource.byteOffset,
        this.componentType =
        ShaderVariableType.getByIndex(_gltfSource.componentType),
        this.count = _gltfSource.count,
        this.typeString = _gltfSource.type,
        this.typeLength = ACCESSOR_TYPES_LENGTHS[_gltfSource.type],
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
      this.sparse):
      this.typeLength = ACCESSOR_TYPES_LENGTHS[typeString];

  factory GLTFAccessor.fromGltf(glTF.Accessor gltfSource) {
    if (gltfSource == null) return null;
    GLTFAccessor accessor = new GLTFAccessor._(gltfSource);

    if(gltfSource.bufferView != null) {
      GLTFBufferView bufferView = gltfProject.bufferViews.firstWhere((b) =>
      b.gltfSource == gltfSource.bufferView, orElse: () =>
      throw new Exception(
          'Accessor can only be bound to an existing project bufferView'));
      assert(bufferView.bufferViewId != null);

      accessor._bufferViewId = bufferView.bufferViewId;
    }
    return accessor;
  }

  @override
  String toString() {
    return 'GLTFAccessor{accessorId : $accessorId, byteOffset: $byteOffset, componentType: $componentType, typeString: $typeString, type: $type, count: $count, normalized: $normalized, max: $max, min: $min, sparse: $sparse}';
  }

}
