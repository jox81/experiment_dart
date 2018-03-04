import 'package:test_webgl/src/gltf/accessor_sparse.dart';
import 'package:test_webgl/src/gltf/buffer_view.dart';
import 'package:test_webgl/src/gltf/project.dart';
import 'package:test_webgl/src/gltf/utils_gltf.dart';
import 'package:test_webgl/src/webgl_objects/datas/webgl_enum.dart';
// Accessor types
const String SCALAR = 'SCALAR';
const String VEC2 = 'VEC2';
const String VEC3 = 'VEC3';
const String VEC4 = 'VEC4';
const String MAT2 = 'MAT2';
const String MAT3 = 'MAT3';
const String MAT4 = 'MAT4';

const String UNSIGNED_SHORT = 'UNSIGNED_SHORT';
const String FLOAT = 'FLOAT';

const Map<String, int> ACCESSOR_ELEMENT_LENGTH_IN_BYTE = const <String, int>{
  SCALAR: 1 * 2,
  VEC2: 2 * 4,
  VEC3: 3 * 4,
  VEC4: 4 * 4,
  MAT2: 4 * 4,
  MAT3: 9 * 4,
  MAT4: 16 * 4
};

const Map<String, int> ACCESSOR_COMPONENTS_COUNT = const <String, int>{
  SCALAR: 1,
  VEC2: 2,
  VEC3: 3,
  VEC4: 4,
  MAT2: 4,
  MAT3: 9,
  MAT4: 16
};

const Map<String, int> ACCESSOR_COMPONENT_LENGTHS = const <String, int>{
  UNSIGNED_SHORT: 2,
  FLOAT: 4,
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

  int byteOffset; //Start reading byte at
  int byteLength;// Total length
  int byteStride;//size of repetition group
  //
  int count;//number of component : 3 x Vector3 for a triangle with 3 positions
  /// ShaderVariableType type
  int type = -1;//FLOAT_VEC3// Todo (jpu) :
  int elementLength;//Size in byte of the type : vec3 -> 3 float * 4 bytes = 12 bytes
  //
  String typeString;//SCALAR/VEC3/...
  int components;//Count of components in an element : vec3 -> 3, vec2 -> 2
  ///VertexAttribArrayType componentType
  int componentType;//Type of a component part : FLOAT, UNSIGNED_SHORT, ...
  int componentLength; //Count of byte per component : FLOAT -> 4, UNSIGNED_SHORT -> 2, BYTE -> 1
  //<

  bool normalized;
  List<num> max;
  List<num> min;
  GLTFAccessorSparse sparse;

  bool isXyzSign;
  bool isUnit;

  GLTFAccessor({
      this.byteOffset,
      this.byteLength,
      this.componentType,
      this.componentLength,
      this.typeString,
      this.type : -1,
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
      super(name){
    GLTFProject.instance.accessors.add(this);
  }


  @override
  String toString() {
    return 'GLTFAccessor{accessorId : $accessorId, bufferViewId: ${bufferView?.bufferViewId}, byteOffset: $byteOffset, byteLength: $byteLength, byteStride: $byteStride, count: $count, elementLength: $elementLength, typeString: $typeString, components: $components, componentType: ${VertexAttribArrayType.getByIndex(componentType)}, componentLength: $componentLength, normalized: $normalized, max: $max, min: $min, sparse: $sparse}';
  }

}
