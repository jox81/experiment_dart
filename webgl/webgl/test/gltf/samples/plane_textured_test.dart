import 'dart:async';
import "package:test/test.dart";
import 'package:webgl/src/gltf/accessor/accessor.dart';
import 'package:webgl/src/gltf/asset.dart';
import 'package:webgl/src/gltf/buffer.dart';
import 'package:webgl/src/gltf/buffer_view.dart';
import 'package:webgl/src/gltf/creation.dart';
import 'package:webgl/src/gltf/pbr_material.dart';
import 'package:webgl/src/gltf/image.dart';
import 'package:webgl/src/gltf/mesh/mesh_primitive.dart';
import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/gltf/sampler.dart';
import 'package:webgl/src/gltf/scene.dart';
import 'package:webgl/src/gltf/texture.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
@TestOn("browser")

String testFolderRelativePath = "../..";

Future main() async {
  GLTFProject project;

  setUp(() async {
    String gltfPath =
        '${testFolderRelativePath}/gltf/tests/samples/gltf_2_0/plane_textured/test_texture.gltf';
    project = await GLTFCreation.loadGLTFProject(gltfPath, useWebPath : true);
    await project.debug(doProjectLog : false, isDebug:false);
  });

  group("plane textured Embed", () {
    test("Project creation", () async {
      expect(project, isNotNull);
    });
    test("scenes", () async {
      expect(project.scenes.length, 1);

      GLTFScene scene = project.scenes[0];
      expect(scene, isNotNull);
      expect(project.scene, isNull);

      expect(scene.nodes.length, 1);
      expect(scene.nodes[0], project.nodes[0]);
    });
    test("nodes", () async {
      expect(project.nodes.length, 1);

      GLTFNode node0 = project.nodes[0];
      expect(node0, isNotNull);
      expect(node0.nodeId, 0);
      expect(node0.mesh, isNotNull);
      expect(node0.mesh, project.meshes[0]);
    });
    test("meshes", () async {
      expect(project.meshes.length, 1);

      GLTFMesh mesh = project.meshes[0];
      expect(mesh, isNotNull);
    });
    test("meshes primitives", () async {
      GLTFMesh mesh = project.meshes[0];
      expect(mesh.primitives, isNotNull);

      GLTFMeshPrimitive primitive = mesh.primitives[0];
      expect(primitive, isNotNull);
      expect(primitive.attributes, isNotNull);
      expect(primitive.positionAccessor, project.accessors[1]);
      expect(primitive.uvAccessor, project.accessors[2]);
      expect(primitive.indices, isNotNull);
      expect(primitive.indices, project.accessors[0]);
      expect(primitive.drawMode, DrawMode.TRIANGLES);
      expect(primitive.baseMaterial, project.materials[0]);
    });
    test("buffers", () async {
      expect(project.buffers.length, 1);

      GLTFBuffer buffer0 = project.buffers[0];
      expect(buffer0, isNotNull);
      expect(buffer0.byteLength, 108);
    });
    test("bufferViews", () async {
      expect(project.bufferViews.length, 2);

      GLTFBufferView bufferView0 = project.bufferViews[0];
      expect(bufferView0, isNotNull);
      expect(project.buffers[0], isNotNull);
      expect(bufferView0.buffer, project.buffers[0]);
      expect(bufferView0.byteOffset, 0);
      expect(bufferView0.byteLength, 12);
      expect(bufferView0.target, 34963);
      expect(bufferView0.usage, 34963);//ELEMENT_ARRAY_BUFFER
      print(bufferView0.usage);

      GLTFBufferView bufferView1 = project.bufferViews[1];
      expect(bufferView1, isNotNull);
      expect(project.buffers[0], isNotNull);
      expect(bufferView1.buffer, project.buffers[0]);
      expect(bufferView1.byteOffset, 12);
      expect(bufferView1.byteLength, 96);
      expect(bufferView1.byteStride, 12);
      expect(bufferView1.target, 34962);
      expect(bufferView1.usage, 34962);//ARRAY_BUFFER
      print(bufferView1.usage);
    });
    test("accessors", () async {
      expect(project.accessors.length, 3);

      GLTFAccessor accessor0 = project.accessors[0];
      expect(accessor0, isNotNull);
      expect(accessor0.bufferView, project.bufferViews[0]);
      expect(accessor0.byteOffset, 0);
      expect(accessor0.componentType, 5123); //UNSIGNED_SHORT
      print(accessor0.componentType);
      expect(accessor0.count, 6);
      expect(accessor0.typeString, 'SCALAR');
      expect(accessor0.type,
          isNull); // Todo (jpu) : componentType: UNSIGNED_SHORT : 5123, typeString: SCALAR => should be INT ?
      expect(accessor0.max, [3]);
      expect(accessor0.min, [0]);

      GLTFAccessor accessor1 = project.accessors[1];
      expect(accessor1, isNotNull);
      expect(accessor1.bufferView, project.bufferViews[1]);
      expect(accessor1.byteOffset, 0);
      expect(accessor1.componentType, 5126); //Float
      expect(accessor1.count, 4);
      expect(accessor1.typeString, 'VEC3');
      print(accessor1.type); //FLOAT_VEC3
      expect(accessor1.type, 35665);
      expect(accessor1.max, [1.0, 1.0, 0.0]);
      expect(accessor1.min, [0.0, 0.0, 0.0]);

      GLTFAccessor accessor2 = project.accessors[2];
      expect(accessor2, isNotNull);
      expect(accessor2.bufferView, project.bufferViews[1]);
      expect(accessor2.byteOffset, 48);
      expect(accessor2.componentType, 5126); //Float
      expect(accessor2.count, 4);
      expect(accessor2.typeString, 'VEC2');
      print(accessor2.type); //FLOAT_VEC2
      expect(accessor2.type, 35664);
      expect(accessor2.max, [1.0,1.0]);
      expect(accessor2.min, [0.0,0.0]);
    });
    test("materials", () async {
      expect(project.materials.length, 1);

      GLTFPBRMaterial material0 = project.materials[0];
      expect(material0, isNotNull);
      expect(material0.materialId, 0);
      expect(material0.name, isNull);
      expect(material0.pbrMetallicRoughness, isNotNull);
      expect(material0.pbrMetallicRoughness.baseColorTexture, isNotNull);
      expect(material0.pbrMetallicRoughness.baseColorTexture.index, 0);
      print('texture index : ${material0.pbrMetallicRoughness.baseColorTexture.index}');
      expect(material0.pbrMetallicRoughness.metallicFactor, 0.0);
      expect(material0.pbrMetallicRoughness.roughnessFactor, 1.0);
    });
    test("textures", () async {
      expect(project.textures.length, 1);

      GLTFTexture texture0 = project.textures[0];
      expect(texture0.sampler.samplerId, 0);
      expect(texture0.source.sourceId, 0);
    });
    test("images", () async {
      expect(project.images.length, 1);

      GLTFImage image0 = project.images[0];
      expect(image0.uri, isNotNull);
      expect(image0.uri.toString(), "testTexture.png");
    });
    test("samplers", () async {
      expect(project.samplers.length, 1);

      GLTFSampler sampler0 = project.samplers[0];
      expect(sampler0.magFilter, 9729);//LINEAR
      print(sampler0.magFilter);
      expect(sampler0.minFilter, 9987);//LINEAR_MIPMAP_LINEAR
      print(sampler0.minFilter);
      expect(sampler0.wrapS, 33648);//MIRRORED_REPEAT
      print(sampler0.wrapS);
      expect(sampler0.wrapT, 33648);//MIRRORED_REPEAT
      print(sampler0.wrapT);
    });
    test("asset", () async {
      expect(project.asset, isNotNull);
      GLTFAsset asset = project.asset;
      expect(asset.version, "2.0");
    });
  });
}
