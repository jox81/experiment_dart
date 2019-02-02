import 'dart:async';
import "package:test/test.dart";
//import 'package:webgl/src/gltf/accessor/accessor.dart';
//import 'package:webgl/src/gltf/asset.dart';
//import 'package:webgl/src/gltf/buffer.dart';
//import 'package:webgl/src/gltf/buffer_view.dart';
//import 'package:webgl/src/gltf/debug_gltf.dart';
//import 'package:webgl/src/gltf/mesh/mesh.dart';
//import 'package:webgl/src/gltf/mesh_primitive.dart';
//import 'package:webgl/src/gltf/node.dart';
//import 'package:webgl/src/gltf/project/project.dart';
//import 'package:webgl/src/gltf/scene.dart';

@TestOn("browser")

Future main() async {
//
//  GLTFProject project;
//
//  setUp(() async {
//    // !! this should be the same as gltf file
//    project = triangleWithIndices();
//    debugGltf(project, doGlTFProjectLog : false, isDebug:false);
//  });
//
//  tearDown(()async{
//    GLTFProject.reset();
//    project = null;
//  });
//
//  group("TriangleWithIndices Embed", () {
//    test("Project creation", () async {
//      expect(project, isNotNull);
//    });
//    test("scenes", () async {
//      expect(project.scenes.length, 1);
//
//      GLTFScene scene = project.scenes[0];
//      expect(scene, isNotNull);
//      expect(scene.nodes.length, 1);
//      expect(scene.nodes[0], project.nodes[0]);
//    });
//    test("nodes", () async {
//      expect(project.nodes.length, 1);
//
//      GLTFNode node = project.nodes[0];
//      expect(node, isNotNull);
//      expect(node.nodeId, 0);
//      expect(node.mesh, isNotNull);
//      expect(node.mesh, project.meshes[0]);
//    });
//    test("meshes", () async {
//      expect(project.meshes.length, 1);
//
//      GLTFMesh mesh = project.meshes[0];
//      expect(mesh, isNotNull);
//    });
//    test("meshes primitives", () async {
//      GLTFMesh mesh = project.meshes[0];
//      expect(mesh.primitives, isNotNull);
//      expect(mesh.primitives.length, 1);
//
//      GLTFMeshPrimitive primitive = mesh.primitives[0];
//      expect(primitive, isNotNull);
//      expect(primitive.attributes, isNotNull);
//      expect(primitive.positionAccessor, project.accessors[1]);
//      expect(primitive.indices, isNotNull);
//      expect(primitive.indices, project.accessors[0]);
//    });
//    test("buffers", () async {
//      expect(project.buffers.length, 1);
//
//      GLTFBuffer buffer = project.buffers[0];
//      expect(buffer, isNotNull);
//      expect(buffer.byteLength, 44);
//    });
//    test("bufferViews", () async {
//      expect(project.bufferViews.length, 2);
//
//      GLTFBufferView bufferView0 = project.bufferViews[0];
//      expect(bufferView0, isNotNull);
//      expect(project.buffers[0], isNotNull);
//      expect(bufferView0.buffer, project.buffers[0]);
//      expect(bufferView0.byteOffset, 0);
//      expect(bufferView0.byteLength, 6);
//      expect(bufferView0.target, 34963);
//      expect(bufferView0.usage, 34963);
//
//      GLTFBufferView bufferView1 = project.bufferViews[1];
//      expect(bufferView1, isNotNull);
//      expect(project.buffers[0], isNotNull);
//      expect(bufferView1.buffer, project.buffers[0]);
//      expect(bufferView1.byteOffset, 8);
//      expect(bufferView1.byteLength, 36);
//      expect(bufferView1.target, 34962);
//      expect(bufferView1.usage, 34962);
//    });
//    test("accessors", () async {
//      expect(project.accessors.length, 2);
//
//      GLTFAccessor accessor0 = project.accessors[0];
//      expect(accessor0, isNotNull);
//      expect(accessor0.bufferView, project.bufferViews[0]);
//      expect(accessor0.byteOffset, 0);
//      expect(accessor0.componentType, 5123);
//      expect(accessor0.count, 3);
//      expect(accessor0.typeString, 'SCALAR');
//      expect(accessor0.type, isNull);// Todo (jpu) : componentType: UNSIGNED_SHORT : 5123, typeString: SCALAR => should be INT ?
////      expect(accessor0.max, [2]);// Todo (jpu) :
////      expect(accessor0.min, [0]);// Todo (jpu) :
//
//      GLTFAccessor accessor1 = project.accessors[1];
//      expect(accessor1, isNotNull);
//      expect(accessor1.bufferView, project.bufferViews[1]);
//      expect(accessor1.byteOffset, 0);
//      expect(accessor1.componentType, 5126);
//      expect(accessor1.count, 3);
//      expect(accessor1.typeString, 'VEC3');
//      expect(accessor1.type, 35665);
////      expect(accessor1.max, [1.0,1.0,0.0]);// Todo (jpu) :
////      expect(accessor1.min, [0.0,0.0,0.0]);// Todo (jpu) :
//    });
//    test("asset", () async {
//      expect(project.asset, isNotNull);
//      GLTFAsset asset = project.asset;
//      expect(asset.version, "2.0");
//    });
//  });
}
