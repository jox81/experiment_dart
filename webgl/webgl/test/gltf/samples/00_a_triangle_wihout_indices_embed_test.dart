import 'dart:async';
import "package:test/test.dart";
import 'package:webgl/src/gltf/accessor/accessor.dart';
import 'package:webgl/src/gltf/asset.dart';
import 'package:webgl/src/gltf/buffer.dart';
import 'package:webgl/src/gltf/buffer_view.dart';
import 'package:webgl/src/gltf/creation.dart';
import 'package:webgl/src/gltf/mesh/mesh_primitive.dart';
import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/gltf/scene.dart';
@TestOn("browser")

String testFolderRelativePath = "../..";

Future main() async {

  GLTFProject project;

  setUp(() async {
    String gltfPath = '${testFolderRelativePath}/gltf/tests/samples/gltf_2_0/00_triangle_without_indices/gltf_embed/TriangleWithoutIndices.gltf';
    project = await GLTFCreation.loadGLTFProject(gltfPath, useWebPath : true);
    await project.debug(doProjectLog : false, isDebug:false);
  });

  group("TriangleWithoutIndices Embed", () {
    test("Project creation", () async {
      expect(project, isNotNull);
    });
    test("scenes", () async {
      expect(project.scenes.length, 1);

      GLTFScene scene = project.scenes[0];
      expect(scene, isNotNull);
      expect(scene.nodes.length, 1);
      expect(scene.nodes[0], project.nodes[0]);
    });
    test("nodes", () async {
      expect(project.nodes.length, 1);

      GLTFNode node = project.nodes[0];
      expect(node, isNotNull);
      expect(node.nodeId, 0);
      expect(node.mesh, isNotNull);
      expect(node.mesh, project.meshes[0]);
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
      expect(primitive.positionAccessor, project.accessors[0]);
    });
    test("buffers", () async {
      expect(project.buffers.length, 1);

      GLTFBuffer buffer = project.buffers[0];
      expect(buffer, isNotNull);
      expect(buffer.byteLength, 36);
    });
    test("bufferViews", () async {
      expect(project.bufferViews.length, 1);

      GLTFBufferView bufferView = project.bufferViews[0];
      expect(bufferView, isNotNull);
      expect(project.buffers[0], isNotNull);
      expect(bufferView.buffer, project.buffers[0]);
      expect(bufferView.byteOffset, 0);
      expect(bufferView.byteLength, 36);
      expect(bufferView.target, 34962);
      expect(bufferView.usage, 34962);
    });
    test("accessors", () async {
      expect(project.accessors.length, 1);
      
      GLTFAccessor accessor0 = project.accessors[0];
      expect(accessor0, isNotNull);
      expect(accessor0.bufferView, project.bufferViews[0]);
      expect(accessor0.byteOffset, 0);
      expect(accessor0.componentType, 5126);
      expect(accessor0.count, 3);
      expect(accessor0.typeString, 'VEC3');
      expect(accessor0.type, 35665);
      expect(accessor0.max, [1.0,1.0,0.0]);
      expect(accessor0.min, [0.0,0.0,0.0]);
    });
    test("asset", () async {
      expect(project.asset, isNotNull);
      GLTFAsset asset = project.asset;
      expect(asset.version, "2.0");
    });
  });
}
