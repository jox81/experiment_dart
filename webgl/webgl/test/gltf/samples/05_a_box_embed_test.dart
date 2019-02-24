import 'dart:async';
import "package:test/test.dart";
import 'package:webgl/src/gltf/accessor/accessor.dart';
import 'package:webgl/src/gltf/asset.dart';
import 'package:webgl/src/gltf/buffer.dart';
import 'package:webgl/src/gltf/buffer_view.dart';
import 'package:webgl/src/gltf/pbr_material.dart';
import 'package:webgl/src/gltf/mesh/mesh_primitive.dart';
import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/gltf/scene.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

import '../../data/gltf_helper.dart';
@TestOn("browser")

String testFolderRelativePath = "../..";

Future main() async {
  GLTFProject project;

  setUp(() async {
    String gltfPath =
        '${testFolderRelativePath}/gltf/tests/samples/gltf_2_0/05_box/gltf_embed/Box.gltf';
    project = await loadGLTFProject(gltfPath);
    await project.debug(doProjectLog : false, isDebug:false);
  });

  group("GLTFCamera Embed", () {
    test("Project creation", () async {
      expect(project, isNotNull);
    });
    test("scenes", () async {
      expect(project.scenes.length, 1);

      GLTFScene scene = project.scenes[0];
      expect(scene, isNotNull);
      expect(project.scene, scene);

      expect(scene.nodes.length, 1);
      expect(scene.nodes[0], project.nodes[0]);
    });
    test("nodes", () async {
      expect(project.nodes.length, 2);

      GLTFNode node0 = project.nodes[0];
      expect(node0, isNotNull);
      expect(node0.nodeId, 0);
      expect(node0.children, isNotNull);
      expect(node0.children.length, 1);
      expect(node0.children[0], project.nodes[1]);
//      expect(
//          node0.matrix.storage,
//          new Matrix4.fromList([
//            1.0,
//            0.0,
//            0.0,
//            0.0,
//            0.0,
//            0.0,
//            -1.0,
//            0.0,
//            0.0,
//            1.0,
//            0.0,
//            0.0,
//            0.0,
//            0.0,
//            0.0,
//            1.0
//          ]).storage);

      GLTFNode node1 = project.nodes[1];
      expect(node1, isNotNull);
      expect(node1.nodeId, 1);
      expect(node1.parent.nodeId, 0);
      expect(node1.mesh, isNotNull);
      expect(node1.mesh, project.meshes[0]);
    });
    test("meshes", () async {
      expect(project.meshes.length, 1);

      GLTFMesh mesh = project.meshes[0];
      expect(mesh, isNotNull);
    });
    test("meshes primitives", () async {
      GLTFMesh mesh = project.meshes[0];
      expect(mesh.primitives, isNotNull);
      expect(mesh.primitives, isNotNull);
      expect(mesh.name, 'Mesh');

      GLTFMeshPrimitive primitive = mesh.primitives[0];
      expect(primitive, isNotNull);
      expect(primitive.attributes, isNotNull);
      expect(primitive.normalAccessor, project.accessors[1]);
      expect(primitive.positionAccessor, project.accessors[2]);
      expect(primitive.indices, isNotNull);
      expect(primitive.indices, project.accessors[0]);
      expect(primitive.drawMode, DrawMode.TRIANGLES);
      expect(primitive.baseMaterial, project.materials[0]);
    });
    test("buffers", () async {
      expect(project.buffers.length, 1);

      GLTFBuffer buffer0 = project.buffers[0];
      expect(buffer0, isNotNull);
      expect(buffer0.byteLength, 648);
    });
    test("bufferViews", () async {
      expect(project.bufferViews.length, 2);

      GLTFBufferView bufferView0 = project.bufferViews[0];
      expect(bufferView0, isNotNull);
      expect(project.buffers[0], isNotNull);
      expect(bufferView0.buffer, project.buffers[0]);
      expect(bufferView0.byteOffset, 576);
      expect(bufferView0.byteLength, 72);
      expect(bufferView0.target, 34963);
      expect(bufferView0.usage, 34963);

      GLTFBufferView bufferView1 = project.bufferViews[1];
      expect(bufferView1, isNotNull);
      expect(project.buffers[0], isNotNull);
      expect(bufferView1.buffer, project.buffers[0]);
      expect(bufferView1.byteOffset, 0);
      expect(bufferView1.byteLength, 576);
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
      expect(accessor0.componentType, 5123); //UNSIGNED_SHORT
      print(accessor0.componentType);
      expect(accessor0.count, 36);
      expect(accessor0.typeString, 'SCALAR');
      expect(accessor0.type,
          isNull); // Todo (jpu) : componentType: UNSIGNED_SHORT : 5123, typeString: SCALAR => should be INT ?
      expect(accessor0.max, [23]);
      expect(accessor0.min, [0]);

      GLTFAccessor accessor1 = project.accessors[1];
      expect(accessor1, isNotNull);
      expect(accessor1.bufferView, project.bufferViews[1]);
      expect(accessor1.byteOffset, 0);
      expect(accessor1.componentType, 5126); //Float
      expect(accessor1.count, 24);
      expect(accessor1.typeString, 'VEC3');
      expect(accessor1.type, 35665);
      print(accessor1.type); //FLOAT_VEC3
      expect(accessor1.max, [1.0, 1.0, 1.0]);
      expect(accessor1.min, [-1.0,-1.0,-1.0]);

      GLTFAccessor accessor2 = project.accessors[2];
      expect(accessor2, isNotNull);
      expect(accessor2.bufferView, project.bufferViews[1]);
      expect(accessor2.byteOffset, 288);
      expect(accessor2.componentType, 5126); //Float
      expect(accessor2.count, 24);
      expect(accessor2.typeString, 'VEC3');
      expect(accessor2.type, 35665);
      print(accessor2.type); //FLOAT_VEC3
      expect(accessor2.max, [0.5,0.5,0.5]);
      expect(accessor2.min, [-0.5,-0.5,-0.5]);
    });
    test("materials", () async {
      expect(project.materials.length, 1);

      GLTFPBRMaterial material0 = project.materials[0];
      expect(material0, isNotNull);
      expect(material0.materialId, 0);
      expect(material0.name, 'Red');
      expect(material0.pbrMetallicRoughness, isNotNull);
      expect(material0.pbrMetallicRoughness.baseColorFactor, [
        0.800000011920929,
        0,
        0,
        1
      ]);
      expect(material0.pbrMetallicRoughness.metallicFactor, 0.0);
    });
    test("asset", () async {
      expect(project.asset, isNotNull);
      GLTFAsset asset = project.asset;
      expect(asset.version, "2.0");
    });
  });
}
