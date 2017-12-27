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

  static GLTFMesh createMesh(Float32List vertexPositions, [Int16List vertexIndices, Float32List vertexNormals]) {
    /// The mesh must have primitive
    GLTFMeshPrimitive primitive =
    new GLTFMeshPrimitive(drawMode: DrawMode.TRIANGLES, hasPosition: vertexPositions != null);

    /// A mesh is needed
    GLTFMesh mesh = new GLTFMesh()
      ..primitives.add(primitive);

    /// A buffer is needed to hold vertex data
    GLTFBuffer buffer = new GLTFBuffer();
    /// Buffer must have data defined as Uint8List
    List<int> baseData = new List();

    //> Indices

    if(vertexIndices != null) {
      /// And the Accessor will have to have a BufferView
      GLTFBufferView bufferView = new GLTFBufferView(
          byteOffset: 0,
          byteLength: vertexIndices.buffer.lengthInBytes,
          usage: BufferType.ELEMENT_ARRAY_BUFFER,
          target: BufferType.ELEMENT_ARRAY_BUFFER,
          byteStride: -1);

      /// The primitive may have Indices Accessor infos
      GLTFAccessor indicesAccessor = new GLTFAccessor(
          byteOffset: 0,
          count: 3,
          components: 1,
          componentType: VertexAttribArrayType.UNSIGNED_SHORT,
          componentLength: vertexIndices.elementSizeInBytes, // bytes in SCALAR
          byteStride: 2,// stride defines repetition = components * componentLength
          normalized: false);
      indicesAccessor.bufferView = bufferView;

      primitive.indicesAccessor = indicesAccessor;

      /// And the BufferView must refer to a Buffer for the datas
      bufferView.buffer = buffer;
      print('${indicesAccessor.bufferView}');

      baseData.addAll(vertexIndices.buffer.asUint8List().toList());
      baseData.addAll([0,0]);// Todo (jpu) :?
    }

    //> Positions

    if(vertexPositions == null) {
      throw 'vertexPositions POSITION must be defined.';
    } else {
      /// The Accessor must have a BufferView
      GLTFBufferView bufferView = new GLTFBufferView(
          byteOffset: vertexIndices != null ? vertexIndices.lengthInBytes + 2 : 0, // Todo (jpu) :?
          byteLength: vertexPositions.buffer.lengthInBytes,
          usage: BufferType.ARRAY_BUFFER,
          target: BufferType.ARRAY_BUFFER,
          byteStride: 12);

      /// The primitive must have POSITION Accessor infos
      GLTFAccessor positionAccessor = new GLTFAccessor(
          byteOffset: 0,
          count: 3,
          components: 3,
          componentType: VertexAttribArrayType.FLOAT,
          componentLength: vertexPositions.elementSizeInBytes,
          // bytes in FLOAT
          byteStride: 12,
          // stride defines repetition = components * componentLength
          normalized: false);
      positionAccessor.bufferView = bufferView;

      primitive.attributes['POSITION'] = positionAccessor;

      /// And the BufferView must refer to a Buffer for the datas
      bufferView.buffer = buffer;
      print('${positionAccessor.bufferView}');

      baseData.addAll(vertexPositions.buffer.asUint8List().toList());
    }

    //> Normals can use same bufferView as Position

    if(vertexNormals != null) {
      /// Normals can use same bufferView as Position.
      /// SO there's no need to create a new one.
      /// But length must be adjusted
      primitive.attributes['POSITION'].bufferView.byteLength += vertexNormals.buffer.lengthInBytes;

      /// The primitive may have Indices Accessor infos
      GLTFAccessor normalAccessor = new GLTFAccessor(
          byteOffset: vertexPositions.length * vertexPositions.elementSizeInBytes,//byte length
          count: 3,
          components: 3,
          componentType: VertexAttribArrayType.FLOAT,
          componentLength: vertexNormals.elementSizeInBytes,
          // bytes in FLOAT
          byteStride: 12,
          // stride defines repetition = components * componentLength
          normalized: false);
      normalAccessor.bufferView = primitive.attributes['POSITION'].bufferView; //Re-use position bufferview

      primitive.attributes['NORMAL'] = normalAccessor;
      print('${normalAccessor.bufferView}');
      baseData.addAll(vertexNormals.buffer.asUint8List().toList());
    }

    //> Fill buffer with datas

    Uint8List data = new Uint8List.fromList(baseData);

    buffer.data = data;
    buffer.byteLength = data.length;

    print('$buffer');

    return mesh;
  }

}
