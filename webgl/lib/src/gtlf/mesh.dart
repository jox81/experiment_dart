import 'dart:typed_data';

import 'package:webgl/src/gtlf/accessor.dart';
import 'package:webgl/src/gtlf/buffer.dart';
import 'package:webgl/src/gtlf/buffer_view.dart';
import 'package:webgl/src/gtlf/mesh_primitive.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

class GLTFMesh extends GLTFChildOfRootProperty {
  static int nextId = 0;
  final int meshId = nextId++;

  final List<double> weights; // Todo (jpu) : ?

  List<GLTFMeshPrimitive> primitives = new List();

  GLTFMesh({this.weights, String name: ''}) : super(name);

  @override
  String toString() {
    return 'GLTFMesh{primitives: $primitives, weights: $weights}';
  }

  static GLTFMesh createMesh(Float32List vertexPositions, Int16List vertexIndices, Float32List vertexNormals, Float32List vertexUvs) {
    /// The mesh must have primitive
    GLTFMeshPrimitive primitive =
    new GLTFMeshPrimitive(drawMode: DrawMode.TRIANGLES, hasPosition: vertexPositions != null, hasNormal: vertexNormals != null, hasTextureCoord: vertexUvs != null);

    /// A mesh is needed
    GLTFMesh mesh = new GLTFMesh()
      ..primitives.add(primitive);

    /// A buffer is needed to hold vertex data
    GLTFBuffer buffer = new GLTFBuffer();
    /// Buffer must have data defined as Uint8List
    List<int> baseData = new List();
    int lastBaseDataLength = 0;

    //> Indices

    int nextMultipleVertexDataOffset = 0;

    int scalarComponentsCount = ACCESSOR_COMPONENTS_COUNT[SCALAR];
    int vec2ComponentsCount = ACCESSOR_COMPONENTS_COUNT[VEC2];
    int vec3ComponentsCount = ACCESSOR_COMPONENTS_COUNT[VEC3];

    if(vertexIndices != null) {
      /// And the Accessor will have to have a BufferView
      GLTFBufferView bufferView = new GLTFBufferView(
          byteOffset: 0,
          byteLength: vertexIndices.buffer.lengthInBytes,
          byteStride: -1,
          target: BufferType.ELEMENT_ARRAY_BUFFER,
          usage: BufferType.ELEMENT_ARRAY_BUFFER,
      );

      /// The primitive may have Indices Accessor infos
      GLTFAccessor indicesAccessor = new GLTFAccessor(
          byteOffset: 0,
          byteLength: vertexIndices.buffer.lengthInBytes,
          byteStride: ACCESSOR_ELEMENT_LENGTH_IN_BYTE[SCALAR],
          count: vertexIndices.length,//for this Accessor, take length only
          type : null,
          elementLength: scalarComponentsCount * ACCESSOR_COMPONENT_LENGTHS[UNSIGNED_SHORT],
          typeString: SCALAR,
          components: scalarComponentsCount,
          componentType: VertexAttribArrayType.UNSIGNED_SHORT,
          componentLength: ACCESSOR_COMPONENT_LENGTHS[UNSIGNED_SHORT],
          normalized: false);
      indicesAccessor.bufferView = bufferView;

      primitive.indicesAccessor = indicesAccessor;

      /// And the BufferView must refer to a Buffer for the datas
      bufferView.buffer = buffer;

      baseData.addAll(vertexIndices.buffer.asUint8List().toList());

      ///Find next ofset with multiple of vertexPositions.elementSizeInBytes (4)
      int findNextIntMultiple(int startValue, int multiple){
        startValue -= 1;
        return  startValue + (multiple - startValue % multiple);
      }
      int x = vertexIndices.lengthInBytes;
      int n = vertexPositions.elementSizeInBytes;
      nextMultipleVertexDataOffset = findNextIntMultiple(x, n);
      print('vertexIndices.lengthInBytes : ${vertexIndices.lengthInBytes}');
      print('vertexPositions.elementSizeInBytes : ${vertexPositions.elementSizeInBytes}');
      print('nextMultipleVertexDataOffset : $nextMultipleVertexDataOffset');
      ///adjust space end
      int dataOffset = nextMultipleVertexDataOffset - baseData.length;
      for(int i = 0; i < dataOffset; i++) {
        baseData.add(0);
      }

      lastBaseDataLength = checkAddedBytes(baseData, lastBaseDataLength);
    }

    //> Positions

    if(vertexPositions == null) {
      throw 'vertexPositions POSITION must be defined.';
    } else {

      /// The Accessor must have a BufferView
      GLTFBufferView bufferView = new GLTFBufferView(
          byteOffset: nextMultipleVertexDataOffset,
          byteLength: vertexPositions.buffer.lengthInBytes,
          byteStride: ACCESSOR_ELEMENT_LENGTH_IN_BYTE[VEC3],
          target: BufferType.ARRAY_BUFFER,
          usage: BufferType.ARRAY_BUFFER,
      );

      /// The primitive must have POSITION Accessor infos
      GLTFAccessor positionAccessor = new GLTFAccessor(
          byteOffset: 0,
          byteLength: vertexPositions.lengthInBytes,
          byteStride: ACCESSOR_ELEMENT_LENGTH_IN_BYTE[VEC3],
          count: vertexPositions.length ~/ vec3ComponentsCount,
          type : 35665,
          elementLength: vec3ComponentsCount * ACCESSOR_COMPONENT_LENGTHS[FLOAT],
          typeString: VEC3,
          components: vec3ComponentsCount,
          componentType: VertexAttribArrayType.FLOAT,
          componentLength: ACCESSOR_COMPONENT_LENGTHS[FLOAT],
          normalized: false,
      );
      positionAccessor.bufferView = bufferView;

      primitive.attributes['POSITION'] = positionAccessor;

      /// And the BufferView must refer to a Buffer for the datas
      bufferView.buffer = buffer;

      baseData.addAll(vertexPositions.buffer.asUint8List().toList());

      lastBaseDataLength = checkAddedBytes(baseData, lastBaseDataLength);
    }

    //> Normals can use same bufferView as Position

    if(vertexNormals != null) {
      /// Normals can use same bufferView as Position.
      /// So there's no need to create a new one.
      /// But length must be adjusted
      primitive.attributes['POSITION'].bufferView.byteLength += vertexNormals.buffer.lengthInBytes;

      /// The primitive may have Indices Accessor infos
      GLTFAccessor normalAccessor = new GLTFAccessor(
          byteOffset: vertexPositions.length ~/ vec3ComponentsCount * 12,
          byteLength: vertexPositions.lengthInBytes,
          byteStride: ACCESSOR_ELEMENT_LENGTH_IN_BYTE[VEC3],
          count: vertexNormals.length ~/ vec3ComponentsCount,
          type : 35665,
          elementLength: vec3ComponentsCount * ACCESSOR_COMPONENT_LENGTHS[FLOAT],
          typeString: VEC3,
          components: vec3ComponentsCount,
          componentType: VertexAttribArrayType.FLOAT,
          componentLength: ACCESSOR_COMPONENT_LENGTHS[FLOAT],
          normalized: false,
      );
      normalAccessor.bufferView = primitive.attributes['POSITION'].bufferView; //Re-use position bufferview

      primitive.attributes['NORMAL'] = normalAccessor;

      baseData.addAll(vertexNormals.buffer.asUint8List().toList());

      lastBaseDataLength = checkAddedBytes(baseData, lastBaseDataLength);
    }

    //> Texture coords

    if(vertexUvs != null) {

      /// as uv is Vec2, it must be reorganised to match stride split
      List<int> data = vertexUvs.buffer.asUint8List().toList();

      int vec2LengthInByte = ACCESSOR_ELEMENT_LENGTH_IN_BYTE[VEC2];
      int count = vertexUvs.length ~/ vec2ComponentsCount;
      for(int i = 0; i < count; i++) {
        data.insertAll(vec2LengthInByte * i, [0, 0, 0, 0]);
      }

      vertexUvs = new Uint8List.fromList(data).buffer.asFloat32List();

      /// UV can use same bufferView as Position.
      /// So there's no need to create a new one.
      /// But length must be adjusted in proportion af position even if it's uv
      primitive.attributes['POSITION'].bufferView.byteLength += vertexUvs.buffer.lengthInBytes;

      /// The primitive may have Indices Accessor infos
      GLTFAccessor uvAccessor = new GLTFAccessor(
          byteOffset: count * 12,//byte length
          byteLength: vertexUvs.lengthInBytes,
          byteStride: ACCESSOR_ELEMENT_LENGTH_IN_BYTE[VEC3],
          count: count,
          type : null,
          elementLength: vec2ComponentsCount * ACCESSOR_COMPONENT_LENGTHS[FLOAT],
          typeString: VEC2,
          components: vec2ComponentsCount,
          componentType: VertexAttribArrayType.FLOAT,
          componentLength: ACCESSOR_COMPONENT_LENGTHS[FLOAT],
          normalized: false,
      );
      uvAccessor.bufferView = primitive.attributes['POSITION'].bufferView; //Re-use position bufferview

      primitive.attributes['TEXCOORD_0'] = uvAccessor;

      baseData.addAll(vertexUvs.buffer.asUint8List().toList());

      lastBaseDataLength = checkAddedBytes(baseData, lastBaseDataLength);
    }

    //> Fill buffer with datas

    buffer.data = new Uint8List.fromList(baseData);
    buffer.byteLength = buffer.data.length;

    return mesh;
  }

  static int checkAddedBytes(List<int> baseData, int lastBaseDataLength) {
    print('added ${baseData.length - lastBaseDataLength} bytes');
    lastBaseDataLength = baseData.length;
    return lastBaseDataLength;
  }

  static GLTFMesh triangle({bool withIndices : true, bool withNormals : true, bool withUVs : true}){
    Float32List vertexPositions = new Float32List.fromList([
      0.0, 0.0, 0.0,
      1.0, 0.0, 0.0,
      0.0, 1.0, 0.0
    ]);

    Int16List vertexIndices;
    if(withIndices) {
      vertexIndices = new Int16List.fromList([0, 1, 2]);
    }

    Float32List vertexNormals;
    if (withNormals) {
      vertexNormals = new Float32List.fromList([
        0.0, 0.0, 1.0,
        0.0, 0.0, 1.0,
        0.0, 0.0, 1.0
      ]);
    }

    Float32List vertexUVs;
    if (withUVs) {
      // Todo (jpu) : replace this
//      vertexNormals = new Float32List.fromList([
//        0.0, 0.0, 1.0,
//        0.0, 0.0, 1.0,
//        0.0, 0.0, 1.0
//      ]);
    }

    return GLTFMesh.createMesh(vertexPositions, vertexIndices, vertexNormals, vertexUVs);
  }

  static GLTFMesh quad({bool withIndices : true, bool withNormals : true, bool withUVs : true}) {

    /*
    1 - 3
    | \ |
    0 - 2
    */

    Float32List vertexPositions;
    vertexPositions = new Float32List.fromList([
      0.0, 0.0, 0.0,
      1.0, 0.0, 0.0,
      0.0, 1.0, 0.0,
      1.0, 1.0, 0.0
    ]);

    Int16List vertexIndices;
    if (withIndices) {
      vertexIndices = new Int16List.fromList([
        0, 1, 2,
        1, 3, 2,
      ]);
    }

    Float32List vertexNormals;
    if (withNormals) {
      vertexNormals = new Float32List.fromList([
        0.0, 0.0, 1.0,
        0.0, 0.0, 1.0,
        0.0, 0.0, 1.0,
        0.0, 0.0, 1.0,
      ]);
    }

    Float32List vertexUvs;
    if (withUVs) {
      vertexUvs = new Float32List.fromList([
        0.0, 1.0,
        0.0, 1.0,
        1.0, 0.0,
        0.0, 0.0
      ]);
    }

    return GLTFMesh.createMesh(vertexPositions, vertexIndices, vertexNormals, vertexUvs);
  }
}
