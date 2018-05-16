import 'dart:async';
import "package:test/test.dart";
import 'package:webgl/src/gltf/accessor.dart';
import 'package:webgl/src/gltf/asset.dart';
import 'package:webgl/src/gltf/buffer.dart';
import 'package:webgl/src/gltf/buffer_view.dart';
import 'package:webgl/src/gltf/debug_gltf.dart';
import 'package:webgl/src/gltf/mesh.dart';
import 'package:webgl/src/gltf/mesh_primitive.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/scene.dart';

@TestOn("browser")

Future main() async {

  GLTFProject gltfProject;

  setUp(() async {
    String gltfPath = 'gltf/samples/gltf_2_0/01_triangle_with_indices/gltf_embed/Triangle.gltf';
    gltfProject = await loadGLTF(gltfPath, useWebPath : true);
    await debugGltf(gltfProject, doGlTFProjectLog : false, isDebug:false);
  });

  group("TriangleWithIndices Embed", () {
    test("Project creation", () async {
      expect(gltfProject, isNotNull);
    });
    test("scenes", () async {
      expect(gltfProject.scenes.length, 1);

      GLTFScene scene = gltfProject.scenes[0];
      expect(scene, isNotNull);
      expect(scene.nodes.length, 1);
      expect(scene.nodes[0], gltfProject.nodes[0]);
    });
    test("nodes", () async {
      expect(gltfProject.nodes.length, 1);

      GLTFNode node = gltfProject.nodes[0];
      expect(node, isNotNull);
      expect(node.nodeId, 0);
      expect(node.mesh, isNotNull);
      expect(node.mesh, gltfProject.meshes[0]);
    });
    test("meshes", () async {
      expect(gltfProject.meshes.length, 1);

      GLTFMesh mesh = gltfProject.meshes[0];
      expect(mesh, isNotNull);
    });
    test("meshes primitives", () async {
      GLTFMesh mesh = gltfProject.meshes[0];
      expect(mesh.primitives, isNotNull);
      expect(mesh.primitives.length, 1);

      GLTFMeshPrimitive primitive = mesh.primitives[0];
      expect(primitive, isNotNull);
      expect(primitive.attributes, isNotNull);
      expect(primitive..positionAccessor, gltfProject.accessors[1]);
      expect(primitive.indices, isNotNull);
      expect(primitive.indices, gltfProject.accessors[0]);
    });
    test("buffers", () async {
      expect(gltfProject.buffers.length, 1);

      GLTFBuffer buffer = gltfProject.buffers[0];
      expect(buffer, isNotNull);
      expect(buffer.byteLength, 44);
    });
    test("bufferViews", () async {
      expect(gltfProject.bufferViews.length, 2);

      GLTFBufferView bufferView0 = gltfProject.bufferViews[0];
      expect(bufferView0, isNotNull);
      expect(gltfProject.buffers[0], isNotNull);
      expect(bufferView0.buffer, gltfProject.buffers[0]);
      expect(bufferView0.byteOffset, 0);
      expect(bufferView0.byteLength, 6);
      expect(bufferView0.target, 34963);
      expect(bufferView0.usage, 34963);

      GLTFBufferView bufferView1 = gltfProject.bufferViews[1];
      expect(bufferView1, isNotNull);
      expect(gltfProject.buffers[0], isNotNull);
      expect(bufferView1.buffer, gltfProject.buffers[0]);
      expect(bufferView1.byteOffset, 8);
      expect(bufferView1.byteLength, 36);
      expect(bufferView1.target, 34962);
      expect(bufferView1.usage, 34962);
    });
    test("accessors", () async {
      expect(gltfProject.accessors.length, 2);

      GLTFAccessor accessor0 = gltfProject.accessors[0];
      expect(accessor0, isNotNull);
      expect(accessor0.bufferView, gltfProject.bufferViews[0]);
      expect(accessor0.byteOffset, 0);
      expect(accessor0.componentType, 5123);
      expect(accessor0.count, 3);
      expect(accessor0.typeString, 'SCALAR');
      expect(accessor0.type, isNull);// Todo (jpu) : componentType: UNSIGNED_SHORT : 5123, typeString: SCALAR => should be INT ?
      expect(accessor0.max, [2]);
      expect(accessor0.min, [0]);

      GLTFAccessor accessor1 = gltfProject.accessors[1];
      expect(accessor1, isNotNull);
      expect(accessor1.bufferView, gltfProject.bufferViews[1]);
      expect(accessor1.byteOffset, 0);
      expect(accessor1.componentType, 5126);
      expect(accessor1.count, 3);
      expect(accessor1.typeString, 'VEC3');
      expect(accessor1.type, 35665);
      expect(accessor1.max, [1.0,1.0,0.0]);
      expect(accessor1.min, [0.0,0.0,0.0]);
    });
    test("asset", () async {
      expect(gltfProject.asset, isNotNull);
      GLTFAsset asset = gltfProject.asset;
      expect(asset.version, "2.0");
    });
  });
}
