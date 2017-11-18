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

/// accessor.componentType
///   UNSIGNED_SHORT :  5123
///   FLOAT :           5126

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
///
/// Zxemple :
/// accessor._bufferViewId = 1
/// accessor.byteOffset = 0
/// accessor.byteLength = 288
/// --> 288 = 24 * 12
/// accessor.count = 24
/// accessor.type = FLOAT_VEC3 : 35665
/// accessor.elementLength = 12
/// --> 12 = 3 * 4
/// accessor.typeString = "VEC3"
/// accessor.components = 3
/// --
/// accessor.componentType = FLOAT : 5126
/// accessor.componentLength = 4
/// --
/// accessor.byteStride = 12
///
/// >> 24 elements * 3 VEC3  * 4 bytes (FLOAT) = 288 byteLength avec une répétition stride tous les 12 bytes (components * componentLength)


///>>>> Exemple for grid graph
///
///
/// BufferView :
///   Element Array > 34963
/// Accessor :
///   componentType SCALAR(1 item) * USHORT_5123 (2 bytes) * count(8250) = 1 * 2 * 8250 = 16.500 bytes
///
///
/// Buffer View
///  Data Array > 34962
///  stride => 3 * 4 = 12 (VEC3(3 item) * FLOAT 5126 (4 bytes))
/// Accessor :
///   componentType VEC3(3 item) * FLOAT 5126 (4 bytes) * count(2012) = 3 * 4 * 2012 = 24.144 bytes
///
class GLTFAccessor extends GLTFChildOfRootProperty {
  glTF.Accessor _gltfSource;
  glTF.Accessor get gltfSource => _gltfSource;

  int accessorId;

  //>
  int _bufferViewId;
  GLTFBufferView get bufferView => _bufferViewId != null ? gltfProject.bufferViews[_bufferViewId] : null;
  final int byteOffset; //Start reading byte at
  int get byteLength => _gltfSource.byteLength;// Total length
  //
  final int count;
  /// ShaderVariableType type
  final int type = -1;//FLOAT_VEC3// Todo (jpu) :
  int get elementLength => _gltfSource.elementLength;//Size in byte of the type : vec3 -> 3 float * 4 bytes = 12 bytes
  //
  final String typeString;//SCALAR/VEC3/...
  int get components => _gltfSource.components;//Count of components in an element : vec3 -> 3, vec2 -> 2
  //
  ///ShaderVariableType componentType
  final int componentType;//Type of a component part : FLOAT, UNSIGNED_SHORT, ...
  int get componentLength => _gltfSource.componentLength; //Count of byte per component : FLOAT -> 4, UNSIGNED_SHORT -> 2, BYTE -> 1
  //
  int get byteStride => _gltfSource.byteStride;//size of repetition group
  //<

  final bool normalized;
  final List<num> max;
  final List<num> min;
  final GLTFAccessorSparse sparse;

  bool get isXyzSign => _gltfSource.isXyzSign;
  bool get isUnit => _gltfSource.isUnit;

  GLTFAccessor._(this._gltfSource, [String name])
      : this.byteOffset = _gltfSource.byteOffset,
        this.componentType = _gltfSource.componentType,
        this.count = _gltfSource.count,
        this.typeString = _gltfSource.type,
//        this.type = ShaderVariableType.getByComponentAndType(_gltfSource.componentType,
//            _gltfSource.type),
        this.normalized = _gltfSource.normalized,
        this.max = _gltfSource.max,
        this.min = _gltfSource.min,
        this.sparse = _gltfSource.sparse != null
            ? new GLTFAccessorSparse.fromGltf(_gltfSource.sparse)
            : null,
        super(_gltfSource.name);

  GLTFAccessor(
      this.byteOffset,
      this.componentType,
      this.typeString,
//      this.type,
      this.count,
      this.normalized,
      this.max,
      this.min,
      this.sparse, [String name]):
      super(name);

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
    return 'GLTFAccessor{accessorId : $accessorId, bufferViewId: $_bufferViewId, byteOffset: $byteOffset, byteLength: $byteLength, count: $count, elementLength: $elementLength, typeString: $typeString, components: $components, componentType: $componentType, componentLength: $componentLength, byteStride: $byteStride, normalized: $normalized, max: $max, min: $min, sparse: $sparse}';
  }

}
