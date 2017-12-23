import 'dart:async';
import 'dart:typed_data';

import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gtlf/accessor.dart';
import 'package:webgl/src/gtlf/buffer.dart';
import 'package:webgl/src/gtlf/buffer_view.dart';
import 'package:webgl/src/gtlf/mesh.dart';
import 'package:webgl/src/gtlf/mesh_primitive.dart';
import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/renderer/renderer.dart';
import 'package:webgl/src/gtlf/scene.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

Future main() async {
  ///First, a Project must be defined
  GLTFProject gltf = new GLTFProject();

  /// The Project must have a scene
  GLTFScene scene = new GLTFScene();
  gltf.addScene(scene);
  gltf.scene = scene;

  /// The Scene must have a node to draw something
  GLTFNode node = new GLTFNode();
  scene.addNode(node);

  /// The node must have a Mesh defined
  node.mesh = createMesh();

  await new GLTFRenderer(gltf).render();
}

GLTFMesh createMesh() {
  GLTFMesh mesh = new GLTFMesh();

  Float32List vertexPositions = new Float32List.fromList([
    0.0, 0.0, 0.0, //
    1.0, 0.0, 0.0, //
    0.0, 1.0, 0.0 //
  ]);

  /// The mesh must have primitive
  GLTFMeshPrimitive primitive =
      new GLTFMeshPrimitive(mode: DrawMode.TRIANGLES, hasPosition: true);
  mesh.primitives.add(primitive);

  
  /// The primitive must have POSITION Accessor infos
  GLTFAccessor accessor = new GLTFAccessor(
      byteOffset: 0,
      count: 3,
      components: 3,
      componentType: VertexAttribArrayType.FLOAT,
      componentLength: vertexPositions.elementSizeInBytes, // bytes in FLOAT
      byteStride: 12, // stride defines repetition = components * componentLength
      normalized: false);
  primitive.attributes['POSITION'] = accessor;

  /// And the Accessor must have a BufferView
  GLTFBufferView bufferView = new GLTFBufferView(
      byteOffset: 0, byteLength: vertexPositions.buffer.lengthInBytes, usage: BufferType.ARRAY_BUFFER);
  accessor.bufferView = bufferView;

  /// And the BufferView must refer to a Buffer for the datas
  GLTFBuffer buffer = new GLTFBuffer();
  bufferView.buffer = buffer;

  /// And Buffer must have data defined as Uint8List
  buffer.data = vertexPositions.buffer.asUint8List();

  return mesh;
}
