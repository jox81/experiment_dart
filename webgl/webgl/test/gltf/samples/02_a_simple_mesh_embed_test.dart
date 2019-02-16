import 'dart:async';
import 'dart:typed_data';
import "package:test/test.dart";
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/accessor/accessor.dart';
import 'package:webgl/src/gltf/asset.dart';
import 'package:webgl/src/gltf/buffer.dart';
import 'package:webgl/src/gltf/buffer_view.dart';
import 'package:webgl/src/gltf/mesh/mesh_primitive.dart';
import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/gltf/scene.dart';

import '../../data/gltf_helper.dart';
@TestOn("browser")

String testFolderRelativePath = "../..";

Future main() async {

  GLTFProject project;

  setUp(() async {
    String gltfPath = '${testFolderRelativePath}/gltf/tests/samples/gltf_2_0/02_simple_meshes/gltf_embed/SimpleMeshes.gltf';
    project = await loadGLTFProject(gltfPath);
    await project.debug(doProjectLog : false, isDebug:false);
  });

  tearDown((){
    project = null;
  });

  group("Simple meshes Embed", () {
    test("Project creation", () async {
      expect(project, isNotNull);
    });
    test("scenes", () async {
      expect(project.scenes.length, 1);

      GLTFScene scene = project.scenes[0];
      expect(scene, isNotNull);
      expect(scene.nodes.length, 2);
      expect(scene.nodes[0], project.nodes[0]);
      expect(scene.nodes[1], project.nodes[1]);
    });
    test("nodes", () async {
      expect(project.nodes.length, 2);

      GLTFNode node0 = project.nodes[0];
      expect(node0, isNotNull);
      expect(node0.nodeId, 0);
      expect(node0.mesh, isNotNull);
      expect(node0.mesh, project.meshes[0]);

      GLTFNode node1 = project.nodes[1];
      expect(node1, isNotNull);
      expect(node1.nodeId, 1);
      expect(node1.mesh, isNotNull);
      expect(node1.mesh, project.meshes[0]);
      expect(node1.translation, new Vector3(1.0,0.0,0.0));
    });
    test("meshes", () async {
      expect(project.meshes.length, 1);

      GLTFMesh mesh = project.meshes[0];
      expect(mesh, isNotNull);
    });
    test("meshes primitives", () async {
      GLTFMesh mesh = project.meshes[0];
      expect(mesh.primitives, isNotNull);
      expect(mesh.primitives.length, 1);

      GLTFMeshPrimitive primitive = mesh.primitives[0];
      expect(primitive, isNotNull);
      expect(primitive.attributes, isNotNull);
      expect(primitive.positionAccessor, project.accessors[1]);
      expect(primitive.normalAccessor, project.accessors[2]);

      expect(primitive.indices, isNotNull);
      expect(primitive.indices, project.accessors[0]);
    });
    test("meshes attributs POSITION", () async {
      GLTFMesh mesh = project.meshes[0];

      GLTFAccessor accessor = mesh.primitives[0].positionAccessor;
      expect(accessor, isNotNull);

      Float32List verticesInfos = accessor.bufferView.buffer.data.buffer.asFloat32List(
          accessor.bufferView.byteOffset + accessor.byteOffset,
          accessor.count * accessor.components);

      expect(verticesInfos.length, 9);
      expect(verticesInfos, [0.0,0.0,0.0,1.0,0.0,0.0,0.0,1.0,0.0]);
    });
    test("meshes attributs NORMAL", () async {
      GLTFMesh mesh = project.meshes[0];

      GLTFAccessor accessor = mesh.primitives[0].normalAccessor;
      expect(accessor, isNotNull);

      Float32List verticesInfos = accessor.bufferView.buffer.data.buffer.asFloat32List(
          accessor.bufferView.byteOffset + accessor.byteOffset,
          accessor.count * accessor.components);

      expect(verticesInfos.length, 9);
      expect(verticesInfos, [0.0,0.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0]);
    });
    test("meshes indices", () async {
      GLTFMesh mesh = project.meshes[0];

      GLTFAccessor accessorIndices = mesh.primitives[0].indicesAccessor;
      Uint16List indices = accessorIndices.bufferView.buffer.data.buffer
          .asUint16List(accessorIndices.byteOffset, accessorIndices.count);

      expect(indices, [0,1,2]);
    });
    test("buffers", () async {
      expect(project.buffers.length, 1);

      GLTFBuffer buffer = project.buffers[0];
      expect(buffer, isNotNull);
      expect(buffer.byteLength, 80);
    });
    test("bufferViews", () async {
      expect(project.bufferViews.length, 2);

      GLTFBufferView bufferView0 = project.bufferViews[0];
      expect(bufferView0, isNotNull);
      expect(project.buffers[0], isNotNull);
      expect(bufferView0.buffer, project.buffers[0]);
      expect(bufferView0.byteOffset, 0);
      expect(bufferView0.byteLength, 6);
      expect(bufferView0.target, 34963);
      expect(bufferView0.usage, 34963);

      GLTFBufferView bufferView1 = project.bufferViews[1];
      expect(bufferView1, isNotNull);
      expect(project.buffers[0], isNotNull);
      expect(bufferView1.buffer, project.buffers[0]);
      expect(bufferView1.byteOffset, 8);
      expect(bufferView1.byteLength, 72);
      expect(bufferView1.byteStride, 12);
      expect(bufferView1.target, 34962);
      expect(bufferView1.usage, 34962);
    });
    test("accessors", () async {
      expect(project.accessors.length, 3);

      GLTFAccessor accessor0 = project.accessors[0];
      expect(accessor0, isNotNull);
      expect(accessor0.bufferView, project.bufferViews[0]);
      expect(accessor0.byteOffset, 0);
      expect(accessor0.componentType, 5123);
      expect(accessor0.count, 3);
      expect(accessor0.typeString, 'SCALAR');
      expect(accessor0.type, isNull);// Todo (jpu) : componentType: UNSIGNED_SHORT : 5123, typeString: SCALAR => should be INT ?
      expect(accessor0.max, [2]);
      expect(accessor0.min, [0]);

      GLTFAccessor accessor1 = project.accessors[1];
      expect(accessor1, isNotNull);
      expect(accessor1.bufferView, project.bufferViews[1]);
      expect(accessor1.byteOffset, 0);
      expect(accessor1.componentType, 5126);
      expect(accessor1.count, 3);
      expect(accessor1.typeString, 'VEC3');
      expect(accessor1.type, 35665);
      expect(accessor1.max, [1.0,1.0,0.0]);
      expect(accessor1.min, [0.0,0.0,0.0]);

      GLTFAccessor accessor2 = project.accessors[2];
      expect(accessor2, isNotNull);
      expect(accessor2.bufferView, project.bufferViews[1]);
      expect(accessor2.byteOffset, 36);
      expect(accessor2.componentType, 5126);
      expect(accessor2.count, 3);
      expect(accessor2.typeString, 'VEC3');
      expect(accessor2.type, 35665);
      expect(accessor2.max, [0.0,0.0,1.0]);
      expect(accessor2.min, [0.0,0.0,1.0]);
    });
    test("asset", () async {
      expect(project.asset, isNotNull);
      GLTFAsset asset = project.asset;
      expect(asset.version, "2.0");
    });
  });
}
