import 'package:webgl/src/gtlf/accessor_sparse.dart';
import 'package:webgl/src/gtlf/buffer_view.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';

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
///   componentType SCALAR(1 item) * USHORT_5123 (2 bytes) * count(5034) = 1 * 2 * 8250 = 10.068 bytes
///
///
/// Buffer View
///  Data Array > 34962
///  stride => 3 * 4 = 12 (VEC3(3 item) * FLOAT 5126 (4 bytes))
/// Accessor :
///   componentType VEC3(3 item) * FLOAT 5126 (4 bytes) * count(2012) = 3 * 4 * 2012 = 24.144 bytes
///
class GLTFAccessor extends GLTFChildOfRootProperty {
  static int nextId = 0;
  final int accessorId = nextId++;

  //>
  GLTFBufferView _bufferView;
  GLTFBufferView get bufferView => _bufferView;
  set bufferView(GLTFBufferView value) {
    _bufferView = value;
  }

  final int byteOffset; //Start reading byte at
  final int byteLength;// Total length
  //
  final int count;
  /// ShaderVariableType type
  final int type = -1;//FLOAT_VEC3// Todo (jpu) :
  final int elementLength;//Size in byte of the type : vec3 -> 3 float * 4 bytes = 12 bytes
  //
  final String typeString;//SCALAR/VEC3/...
  final int components;//Count of components in an element : vec3 -> 3, vec2 -> 2
  //
  ///ShaderVariableType componentType
  final int componentType;//Type of a component part : FLOAT, UNSIGNED_SHORT, ...
  final int componentLength; //Count of byte per component : FLOAT -> 4, UNSIGNED_SHORT -> 2, BYTE -> 1
  //
  final int byteStride;//size of repetition group
  //<

  final bool normalized;
  final List<num> max;
  final List<num> min;
  final GLTFAccessorSparse sparse;

  final bool isXyzSign;
  final bool isUnit;

  GLTFAccessor({
      this.byteOffset,
      this.byteLength,
      this.componentType,
      this.componentLength,
      this.typeString,
//      this.type,
      this.elementLength,
      this.components,
      this.count,
      this.normalized,
      this.max,
      this.min,
      this.byteStride,
      this.sparse,
      this.isXyzSign,
      this.isUnit,
      String name
      }):
      super(name);


  @override
  String toString() {
    return 'GLTFAccessor{accessorId : $accessorId, bufferViewId: ${bufferView?.bufferViewId}, byteOffset: $byteOffset, byteLength: $byteLength, count: $count, elementLength: $elementLength, typeString: $typeString, components: $components, componentType: $componentType, componentLength: $componentLength, byteStride: $byteStride, normalized: $normalized, max: $max, min: $min, sparse: $sparse}';
  }

}
