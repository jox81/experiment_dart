//import 'dart:async';
//import 'dart:typed_data';
//import "package:test/test.dart";
//import 'package:vector_math/vector_math.dart';
//import 'package:webgl/src/gltf/accessor.dart';
//import 'package:webgl/src/gltf/asset.dart';
//import 'package:webgl/src/gltf/buffer.dart';
//import 'package:webgl/src/gltf/buffer_view.dart';
//import 'package:webgl/src/gltf/debug_gltf.dart';
//import 'package:webgl/src/gltf/mesh.dart';
//import 'package:webgl/src/gltf/mesh_primitive.dart';
//import 'package:webgl/src/gltf/node.dart';
//import 'package:webgl/src/gltf/project.dart';
//import 'package:webgl/src/gltf/scene.dart';
//
//@TestOn("dartium")
//
//
//Future main() async {
//
//  GLTFProject gltfProject;
//
//  setUp(() async {
//    // !! this should be the same as gltf file
//    gltfProject = aSimpleMesh();
//    await debugGltf(gltfProject, doGlTFProjectLog : false, isDebug:false);
//  });
//
//  tearDown((){
//    GLTFProject.reset();
//    gltfProject = null;
//  });
//
//  group("Simple meshes Embed", () {
//    test("Project creation", () async {
//      expect(gltfProject, isNotNull);
//    });
//    test("scenes", () async {
//      expect(gltfProject.scenes.length, 1);
//
//      GLTFScene scene = gltfProject.scenes[0];
//      expect(scene, isNotNull);
//      expect(scene.nodes.length, 2);
//      expect(scene.nodes[0], gltfProject.nodes[0]);
//      expect(scene.nodes[1], gltfProject.nodes[1]);
//    });
//    test("nodes", () async {
//      expect(gltfProject.nodes.length, 2);
//
//      GLTFNode node0 = gltfProject.nodes[0];
//      expect(node0, isNotNull);
//      expect(node0.nodeId, 0);
//      expect(node0.mesh, isNotNull);
//      expect(node0.mesh, gltfProject.meshes[0]);
//
//      GLTFNode node1 = gltfProject.nodes[1];
//      expect(node1, isNotNull);
//      expect(node1.nodeId, 1);
//      expect(node1.mesh, isNotNull);
//      expect(node1.mesh, gltfProject.meshes[0]);
//      expect(node1.translation, new Vector3(1.0,0.0,0.0));
//    });
//    test("meshes", () async {
//      expect(gltfProject.meshes.length, 1);
//
//      GLTFMesh mesh = gltfProject.meshes[0];
//      expect(mesh, isNotNull);
//    });
//    test("meshes primitives", () async {
//      GLTFMesh mesh = gltfProject.meshes[0];
//      expect(mesh.primitives, isNotNull);
//      expect(mesh.primitives.length, 1);
//
//      GLTFMeshPrimitive primitive = mesh.primitives[0];
//      expect(primitive, isNotNull);
//      expect(primitive.attributes, isNotNull);
//      expect(primitive.positionAccessor, gltfProject.accessors[1]);
//      expect(primitive.normalAccessor, gltfProject.accessors[2]);
//
//      expect(primitive.indices, isNotNull);
//      expect(primitive.indices, gltfProject.accessors[0]);
//    });
//    test("meshes attributs POSITION", () async {
//      GLTFMesh mesh = gltfProject.meshes[0];
//
//      GLTFAccessor accessor = mesh.primitives[0].positionAccessor;
//      expect(accessor, isNotNull);
//
//      Float32List verticesInfos = accessor.bufferView.buffer.data.buffer.asFloat32List(
//          accessor.bufferView.byteOffset + accessor.byteOffset,
//          accessor.count * accessor.components);
//
//      expect(verticesInfos.length, 9);
//      expect(verticesInfos, [0.0,0.0,0.0,1.0,0.0,0.0,0.0,1.0,0.0]);
//    });
//    test("meshes attributs NORMAL", () async {
//      GLTFMesh mesh = gltfProject.meshes[0];
//
//      GLTFAccessor accessor = mesh.primitives[0].normalAccessor;
//      expect(accessor, isNotNull);
//
//      Float32List verticesInfos = accessor.bufferView.buffer.data.buffer.asFloat32List(
//          accessor.bufferView.byteOffset + accessor.byteOffset,
//          accessor.count * accessor.components);
//
//      expect(verticesInfos.length, 9);
//      expect(verticesInfos, [0.0,0.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0]);
//    });
//    test("meshes indices", () async {
//      GLTFMesh mesh = gltfProject.meshes[0];
//
//      GLTFAccessor accessorIndices = mesh.primitives[0].indicesAccessor;
//      Uint16List indices = accessorIndices.bufferView.buffer.data.buffer
//          .asUint16List(accessorIndices.byteOffset, accessorIndices.count);
//
//      expect(indices, [0,1,2]);
//    });
//    test("buffers", () async {
//      expect(gltfProject.buffers.length, 1);
//
//      GLTFBuffer buffer = gltfProject.buffers[0];
//      expect(buffer, isNotNull);
//      expect(buffer.byteLength, 80);
//    });
//    test("bufferViews", () async {
//      expect(gltfProject.bufferViews.length, 2);
//
//      GLTFBufferView bufferView0 = gltfProject.bufferViews[0];
//      expect(bufferView0, isNotNull);
//      expect(gltfProject.buffers[0], isNotNull);
//      expect(bufferView0.buffer, gltfProject.buffers[0]);
//      expect(bufferView0.byteOffset, 0);
//      expect(bufferView0.byteLength, 6);
//      expect(bufferView0.target, 34963);
//      expect(bufferView0.usage, 34963);
//
//      GLTFBufferView bufferView1 = gltfProject.bufferViews[1];
//      expect(bufferView1, isNotNull);
//      expect(gltfProject.buffers[0], isNotNull);
//      expect(bufferView1.buffer, gltfProject.buffers[0]);
//      expect(bufferView1.byteOffset, 8);
//      expect(bufferView1.byteLength, 72);
//      expect(bufferView1.byteStride, 12);
//      expect(bufferView1.target, 34962);
//      expect(bufferView1.usage, 34962);
//    });
//    test("accessors", () async {
//      expect(gltfProject.accessors.length, 3);
//
//      GLTFAccessor accessor0 = gltfProject.accessors[0];
//      expect(accessor0, isNotNull);
//      expect(accessor0.bufferView, gltfProject.bufferViews[0]);
//      expect(accessor0.byteOffset, 0);
//      expect(accessor0.componentType, 5123);
//      expect(accessor0.count, 3);
//      expect(accessor0.typeString, 'SCALAR');
//      expect(accessor0.type, isNull);// Todo (jpu) : componentType: UNSIGNED_SHORT : 5123, typeString: SCALAR => should be INT ?
////      expect(accessor0.max, [2]);// Todo (jpu) :
////      expect(accessor0.min, [0]);// Todo (jpu) :
//
//      GLTFAccessor accessor1 = gltfProject.accessors[1];
//      expect(accessor1, isNotNull);
//      expect(accessor1.bufferView, gltfProject.bufferViews[1]);
//      expect(accessor1.byteOffset, 0);
//      expect(accessor1.componentType, 5126);
//      expect(accessor1.count, 3);
//      expect(accessor1.typeString, 'VEC3');
//      expect(accessor1.type, 35665);
////      expect(accessor1.max, [1.0,1.0,0.0]);// Todo (jpu) :
////      expect(accessor1.min, [0.0,0.0,0.0]);// Todo (jpu) :
//
//      GLTFAccessor accessor2 = gltfProject.accessors[2];
//      expect(accessor2, isNotNull);
//      expect(accessor2.bufferView, gltfProject.bufferViews[1]);
//      expect(accessor2.byteOffset, 36);
//      expect(accessor2.componentType, 5126);
//      expect(accessor2.count, 3);
//      expect(accessor2.typeString, 'VEC3');
//      expect(accessor2.type, 35665);
////      expect(accessor2.max, [0.0,0.0,1.0]);// Todo (jpu) :
////      expect(accessor2.min, [0.0,0.0,1.0]);// Todo (jpu) :
//    });
//    test("asset", () async {
//      expect(gltfProject.asset, isNotNull);
//      GLTFAsset asset = gltfProject.asset;
//      expect(asset.version, "2.0");
//    });
//  });
//}
