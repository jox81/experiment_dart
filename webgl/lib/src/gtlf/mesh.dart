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

  List<GLTFMeshPrimitive> primitives = new List();
  final List<double> weights;

  GLTFMesh({this.weights, String name: ''}) : super(name);

  @override
  String toString() {
    return 'GLTFMesh{primitives: $primitives, weights: $weights}';
  }

  static GLTFMesh createMesh(Float32List vertexPositions, Int16List vertexIndices) {
    /// The mesh must have primitive
    GLTFMeshPrimitive primitive =
    new GLTFMeshPrimitive(mode: DrawMode.TRIANGLES, hasPosition: vertexPositions != null);

    /// A mesh is needed
    GLTFMesh mesh = new GLTFMesh()
      ..primitives.add(primitive);

    /// A buffer is needed to hold vertex data
    GLTFBuffer buffer = new GLTFBuffer();

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
      print('$bufferView');
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
          byteStride: -1);

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
      print('$bufferView');
    }

    //> Fill buffer with datas

    /// And Buffer must have data defined as Uint8List

    List<int> baseData = new List();
    if(vertexIndices != null){
      baseData.addAll(vertexIndices.buffer.asUint8List().toList());
      baseData.addAll([0,0]);// Todo (jpu) :?
    }
    baseData.addAll(vertexPositions.buffer.asUint8List().toList());

    Uint8List data = new Uint8List.fromList(baseData);

    buffer.data = data;
    buffer.byteLength = data.length;

    print('$buffer');

    return mesh;
  }
}
