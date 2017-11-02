import 'dart:async';
import "package:test/test.dart";
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/gtlf/accessor.dart';
import 'package:webgl/src/gtlf/asset.dart';
import 'package:webgl/src/gtlf/buffer.dart';
import 'package:webgl/src/gtlf/buffer_view.dart';
import 'package:webgl/src/gtlf/image.dart';
import 'package:webgl/src/gtlf/material.dart';
import 'package:webgl/src/gtlf/mesh.dart';
import 'package:webgl/src/gtlf/mesh_primitive.dart';
import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/sampler.dart';
import 'package:webgl/src/gtlf/scene.dart';
import 'package:webgl/src/gtlf/texture.dart';
import 'package:webgl/src/gtlf/texture_info.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

@TestOn("dartium")
Future main() async {
  GLTFProject gltfProject;

  setUp(() async {
    glTF.Gltf gltf = await GLTFProject.loadGLTFResource(
        '/gltf/samples/gltf_2_0/plane_textured/test_texture.gltf',
        useWebPath: true);
    gltfProject = new GLTFProject.fromGltf(gltf);
  });

  group("plane textured Embed", () {
    test("Project creation", () async {
      expect(gltfProject, isNotNull);
    });
    test("scenes", () async {
      expect(gltfProject.scenes.length, 1);

      GLTFScene scene = gltfProject.scenes[0];
      expect(scene, isNotNull);
      expect(gltfProject.scene, isNull);

      expect(scene.nodes.length, 1);
      expect(scene.nodes[0], gltfProject.nodes[0]);
    });
    test("nodes", () async {
      expect(gltfProject.nodes.length, 1);

      GLTFNode node0 = gltfProject.nodes[0];
      expect(node0, isNotNull);
      expect(node0.nodeId, 0);
      expect(node0.mesh, isNotNull);
      expect(node0.mesh, gltfProject.meshes[0]);
    });
    test("meshes", () async {
      expect(gltfProject.meshes.length, 1);

      GLTFMesh mesh = gltfProject.meshes[0];
      expect(mesh, isNotNull);
    });
    test("meshes primitives", () async {
      GLTFMesh mesh = gltfProject.meshes[0];
      expect(mesh.primitives, isNotNull);

      GLTFMeshPrimitive primitive = mesh.primitives[0];
      expect(primitive, isNotNull);
      expect(primitive.attributes, isNotNull);
      expect(primitive.attributes['POSITION'], gltfProject.accessors[1]);
      expect(primitive.attributes['TEXCOORD_0'], gltfProject.accessors[2]);
      expect(primitive.indices, isNotNull);
      expect(primitive.indices, gltfProject.accessors[0]);
      expect(primitive.mode, DrawMode.TRIANGLES);
      expect(primitive.material, gltfProject.materials[0]);
    });
    test("buffers", () async {
      expect(gltfProject.buffers.length, 1);

      GLTFBuffer buffer0 = gltfProject.buffers[0];
      expect(buffer0, isNotNull);
      expect(buffer0.byteLength, 108);
    });
    test("bufferViews", () async {
      expect(gltfProject.bufferViews.length, 2);

      GLTFBufferView bufferView0 = gltfProject.bufferViews[0];
      expect(bufferView0, isNotNull);
      expect(gltfProject.buffers[0], isNotNull);
      expect(bufferView0.buffer, gltfProject.buffers[0]);
      expect(bufferView0.byteOffset, 0);
      expect(bufferView0.byteLength, 12);
      expect(bufferView0.target, 34963);
      expect(bufferView0.usage.index, 34963);//ELEMENT_ARRAY_BUFFER
      print(bufferView0.usage);

      GLTFBufferView bufferView1 = gltfProject.bufferViews[1];
      expect(bufferView1, isNotNull);
      expect(gltfProject.buffers[0], isNotNull);
      expect(bufferView1.buffer, gltfProject.buffers[0]);
      expect(bufferView1.byteOffset, 12);
      expect(bufferView1.byteLength, 96);
      expect(bufferView1.byteStride, 12);
      expect(bufferView1.target, 34962);
      expect(bufferView1.usage.index, 34962);//ARRAY_BUFFER
      print(bufferView1.usage);
    });
    test("accessors", () async {
      expect(gltfProject.accessors.length, 3);

      GLTFAccessor accessor0 = gltfProject.accessors[0];
      expect(accessor0, isNotNull);
      expect(accessor0.bufferView, gltfProject.bufferViews[0]);
      expect(accessor0.byteOffset, 0);
      expect(accessor0.componentType.index, 5123); //UNSIGNED_SHORT
      print(accessor0.componentType);
      expect(accessor0.count, 6);
      expect(accessor0.typeString, 'SCALAR');
      expect(accessor0.type,
          isNull); // Todo (jpu) : componentType: UNSIGNED_SHORT : 5123, typeString: SCALAR => should be INT ?
      expect(accessor0.max, [3]);
      expect(accessor0.min, [0]);

      GLTFAccessor accessor1 = gltfProject.accessors[1];
      expect(accessor1, isNotNull);
      expect(accessor1.bufferView, gltfProject.bufferViews[1]);
      expect(accessor1.byteOffset, 0);
      expect(accessor1.componentType.index, 5126); //Float
      expect(accessor1.count, 4);
      expect(accessor1.typeString, 'VEC3');
      print(accessor1.type); //FLOAT_VEC3
      expect(accessor1.type.index, 35665);
      expect(accessor1.max, [1.0, 1.0, 0.0]);
      expect(accessor1.min, [0.0, 0.0, 0.0]);

      GLTFAccessor accessor2 = gltfProject.accessors[2];
      expect(accessor2, isNotNull);
      expect(accessor2.bufferView, gltfProject.bufferViews[1]);
      expect(accessor2.byteOffset, 48);
      expect(accessor2.componentType.index, 5126); //Float
      expect(accessor2.count, 4);
      expect(accessor2.typeString, 'VEC2');
      print(accessor2.type); //FLOAT_VEC2
      expect(accessor2.type.index, 35664);
      expect(accessor2.max, [1.0,1.0]);
      expect(accessor2.min, [0.0,0.0]);
    });
    test("materials", () async {
      expect(gltfProject.materials.length, 1);

      GLTFMaterial material0 = gltfProject.materials[0];
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
      expect(gltfProject.textures.length, 1);

      GLTFTexture texture0 = gltfProject.textures[0];
      expect(texture0.sampler.samplerId, 0);
      expect(texture0.source.sourceId, 0);
    });
    test("images", () async {
      expect(gltfProject.images.length, 1);

      GLTFImage image0 = gltfProject.images[0];
      expect(image0.uri, isNotNull);
      expect(image0.uri.toString(), "testTexture.png");
    });
    test("samplers", () async {
      expect(gltfProject.samplers.length, 1);

      GLTFSampler sampler0 = gltfProject.samplers[0];
      expect(sampler0.magFilter.index, 9729);//LINEAR
      print(sampler0.magFilter);
      expect(sampler0.minFilter.index, 9987);//LINEAR_MIPMAP_LINEAR
      print(sampler0.minFilter);
      expect(sampler0.wrapS.index, 33648);//MIRRORED_REPEAT
      print(sampler0.wrapS);
      expect(sampler0.wrapT.index, 33648);//MIRRORED_REPEAT
      print(sampler0.wrapT);
    });
    test("asset", () async {
      expect(gltfProject.asset, isNotNull);
      GLTFAsset asset = gltfProject.asset;
      expect(asset.version, "2.0");
    });
  });
}
