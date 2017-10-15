import 'dart:async';
import "package:test/test.dart";
import 'package:webgl/src/gtlf/project.dart';
import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/utils_gltf.dart';

@TestOn("dartium")

Future main() async {

  GLTFProject gltfProject;

  setUp(() async {
    glTF.Gltf gltf = await GLTFProject.loadGLTFResource('gltf/samples/gltf_2_0/TriangleWithoutIndices/glTF-Embed/TriangleWithoutIndices.gltf', useWebPath:true);
    gltfProject = new GLTFProject.fromGltf(gltf);
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
      expect(scene.nodes[0].nodeId, isNotNull);// Todo (jpu) : later
    });
    test("nodes", () async {
      expect(gltfProject.nodes.length, 1);

      GLTFNode node = gltfProject.nodes[0];
      expect(node, isNotNull);
      expect(node.nodeId, 0);
      expect(node.mesh, isNotNull);
      expect(node.mesh.meshId, isNull);// Todo (jpu) : later
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
      print(primitive.attributes);
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
      expect(bufferView.bufferId, isNull);// Todo (jpu) : later
      expect(bufferView.byteOffset, 0);
      expect(bufferView.byteLength, 36);
      expect(bufferView.target, 34962);
      expect(bufferView.usage.index, 34962);
    });
    test("accessors", () async {
      expect(gltfProject.accessors.length, 1);
    });
    test("asset", () async {
      expect(gltfProject.asset, isNotNull);
      GLTFAsset asset = gltfProject.asset;
      expect(asset.version, "2.0");
    });
  });
}
