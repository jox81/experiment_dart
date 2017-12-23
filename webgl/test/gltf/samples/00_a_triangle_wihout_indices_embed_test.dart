import 'dart:async';
import "package:test/test.dart";
import 'package:webgl/src/gtlf/accessor.dart';
import 'package:webgl/src/gtlf/asset.dart';
import 'package:webgl/src/gtlf/buffer.dart';
import 'package:webgl/src/gtlf/buffer_view.dart';
import 'package:webgl/src/gtlf/debug_gltf.dart';
import 'package:webgl/src/gtlf/mesh.dart';
import 'package:webgl/src/gtlf/mesh_primitive.dart';
import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/scene.dart';
import 'package:webgl/src/gtlf/gltf_creation.dart';
@TestOn("dartium")

Future main() async {

  GLTFProject gltfProject;

  setUp(() async {
    String gltfPath = '/gltf/samples/gltf_2_0/00_triangle_without_indices/gltf_embed/TriangleWithoutIndices.gltf';
    gltfProject = await debugGltf(gltfPath, doGlTFProjectLog : false, isDebug:false, useWebPath: true);
  });

  group("TriangleWithoutIndices Embed", () {
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
      expect(primitive.attributes['POSITION'], gltfProject.accessors[0]);
    });
    test("buffers", () async {
      expect(gltfProject.buffers.length, 1);

      GLTFBuffer buffer = gltfProject.buffers[0];
      expect(buffer, isNotNull);
      expect(buffer.byteLength, 36);
    });
    test("bufferViews", () async {
      expect(gltfProject.bufferViews.length, 1);

      GLTFBufferView bufferView = gltfProject.bufferViews[0];
      expect(bufferView, isNotNull);
      expect(gltfProject.buffers[0], isNotNull);
      expect(bufferView.buffer, gltfProject.buffers[0]);
      expect(bufferView.byteOffset, 0);
      expect(bufferView.byteLength, 36);
      expect(bufferView.target, 34962);
      expect(bufferView.usage, 34962);
    });
    test("accessors", () async {
      expect(gltfProject.accessors.length, 1);
      
      GLTFAccessor accessor0 = gltfProject.accessors[0];
      expect(accessor0, isNotNull);
      expect(accessor0.bufferView, gltfProject.bufferViews[0]);
      expect(accessor0.byteOffset, 0);
      expect(accessor0.componentType, 5126);
      expect(accessor0.count, 3);
      expect(accessor0.typeString, 'VEC3');
      expect(accessor0.type, 35665);
      expect(accessor0.max, [1.0,1.0,0.0]);
      expect(accessor0.min, [0.0,0.0,0.0]);
    });
    test("asset", () async {
      expect(gltfProject.asset, isNotNull);
      GLTFAsset asset = gltfProject.asset;
      expect(asset.version, "2.0");
    });
  });
}
