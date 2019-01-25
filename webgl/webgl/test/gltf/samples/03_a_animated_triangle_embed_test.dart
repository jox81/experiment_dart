import 'dart:async';
import "package:test/test.dart";
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/accessor/accessor.dart';
import 'package:webgl/src/gltf/animation/animation.dart';
import 'package:webgl/src/gltf/animation/animation_channel.dart';
import 'package:webgl/src/gltf/animation/animation_sampler.dart';
import 'package:webgl/src/gltf/asset.dart';
import 'package:webgl/src/gltf/buffer.dart';
import 'package:webgl/src/gltf/buffer_view.dart';
import 'package:webgl/src/gltf/debug_gltf.dart';
import 'package:webgl/src/gltf/mesh/mesh_primitive.dart';
import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project.dart';
import 'package:webgl/src/gltf/scene.dart';
@TestOn("browser")

String testFolderRelativePath = "../..";

//see tutorial : https://github.com/javagl/glTF-Tutorials/blob/master/gltfTutorial/gltfTutorial_006_SimpleAnimation.md
Future main() async {

  GLTFProject gltfProject;

  setUp(() async {
    String gltfPath = '${testFolderRelativePath}/gltf/tests/samples/gltf_2_0/03_animated_triangle/gltf_embed/AnimatedTriangle.gltf';
    gltfProject = await loadGLTFProject(gltfPath, useWebPath : true);
    await debugProject(gltfProject, doProjectLog : false, isDebug:false);
  });

  group("Animated triangle Embed", () {
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

      GLTFNode node0 = gltfProject.nodes[0];
      expect(node0, isNotNull);
      expect(node0.nodeId, 0);
      expect(node0.mesh, isNotNull);
      expect(node0.mesh, gltfProject.meshes[0]);
      expect(node0.rotation.storage, new Vector4(0.0, 0.0, 0.0, 1.0).storage);

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
      expect(primitive.positionAccessor, gltfProject.accessors[1]);
      expect(primitive.indices, isNotNull);
      expect(primitive.indices, gltfProject.accessors[0]);
    });
    test("animations", () async {
      expect(gltfProject.animations, isNotNull);
      expect(gltfProject.animations.length, 1);

      GLTFAnimation animation0 = gltfProject.animations[0];
      expect(animation0, isNotNull);
      expect(animation0.channels, isNotNull);
      expect(animation0.samplers, isNotNull);
    });
    test("animations sampler", () async {
      List<GLTFAnimationSampler> samplers = gltfProject.animations[0].samplers;
      expect(samplers, isNotNull);
      expect(samplers.length, 1);

      GLTFAnimationSampler sampler = samplers[0];
      expect(sampler, isNotNull);
      expect(sampler.input, isNotNull);
      expect(sampler.input, gltfProject.accessors[2]);
      expect(sampler.output, isNotNull);
      expect(sampler.output, gltfProject.accessors[3]);
      expect(sampler.interpolation, 'LINEAR');
    });
    test("animations channel", () async {
      List<GLTFAnimationChannel> channels = gltfProject.animations[0].channels;
      expect(channels, isNotNull);
      expect(channels.length, 1);

      GLTFAnimationChannel channel = channels[0];
      expect(channel, isNotNull);
      expect(channel.sampler, isNotNull);
      expect(channel.sampler, gltfProject.animations[0].samplers[0]);
      expect(channel.target, isNotNull);
      expect(gltfProject.nodes[0], isNotNull);
      expect(channel.target.node, gltfProject.nodes[0]);
      expect(channel.target.path, 'rotation');
    });
    test("buffers", () async {
      expect(gltfProject.buffers.length, 2);

      GLTFBuffer buffer0 = gltfProject.buffers[0];
      expect(buffer0, isNotNull);
      expect(buffer0.byteLength, 44);

      GLTFBuffer buffer01 = gltfProject.buffers[1];
      expect(buffer01, isNotNull);
      expect(buffer01.byteLength, 100);
    });
    test("bufferViews", () async {
      expect(gltfProject.bufferViews.length, 3);

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

      GLTFBufferView bufferView2 = gltfProject.bufferViews[2];
      expect(bufferView2, isNotNull);
      expect(gltfProject.buffers[1], isNotNull);
      expect(bufferView2.buffer, gltfProject.buffers[1]);
      expect(bufferView2.byteOffset, 0);
      expect(bufferView2.byteLength, 100);
    });
    test("accessors", () async {
      expect(gltfProject.accessors.length, 4);

      GLTFAccessor accessor0 = gltfProject.accessors[0];
      expect(accessor0, isNotNull);
      expect(accessor0.bufferView, gltfProject.bufferViews[0]);
      expect(accessor0.byteOffset, 0);
      expect(accessor0.componentType, 5123);//UNSIGNED_SHORT
      print(accessor0.componentType);
      expect(accessor0.count, 3);
      expect(accessor0.typeString, 'SCALAR');
      expect(accessor0.type, isNull);// Todo (jpu) : componentType: UNSIGNED_SHORT : 5123, typeString: SCALAR => should be INT ?
      expect(accessor0.max, [2]);
      expect(accessor0.min, [0]);

      GLTFAccessor accessor1 = gltfProject.accessors[1];
      expect(accessor1, isNotNull);
      expect(accessor1.bufferView, gltfProject.bufferViews[1]);
      expect(accessor1.byteOffset, 0);
      expect(accessor1.componentType, 5126);//Float
      expect(accessor1.count, 3);
      expect(accessor1.typeString, 'VEC3');
      expect(accessor1.type, 35665);
      print(accessor1.type);//FLOAT_VEC3
      expect(accessor1.max, [1.0,1.0,0.0]);
      expect(accessor1.min, [0.0,0.0,0.0]);

      //accessorTime => 5 float = 20 bytes
      GLTFAccessor accessor2 = gltfProject.accessors[2];
      expect(accessor2, isNotNull);
      expect(accessor2.bufferView, gltfProject.bufferViews[2]);
      expect(accessor2.byteOffset, 0);
      expect(accessor2.count, 5);
      expect(accessor2.componentType, 5126);//Float
      expect(accessor2.typeString, 'SCALAR');
      expect(accessor2.type, isNull);// Todo (jpu) : componentType: UNSIGNED_SHORT : 5123, typeString: SCALAR => should be INT ?
      expect(accessor2.max, [1.0]);
      expect(accessor2.min, [0.0]);

      //accessorRotation as Quaternion => 5 * 4 float = 80 bytes
      //=> 80 + 20 = 100 bytes du buffer
      GLTFAccessor accessor3 = gltfProject.accessors[3];
      expect(accessor3, isNotNull);
      expect(accessor3.bufferView, gltfProject.bufferViews[2]);
      expect(accessor3.byteOffset, 20);
      expect(accessor3.count, 5);
      expect(accessor3.componentType, 5126);//Float
      expect(accessor3.typeString, 'VEC4');
      expect(accessor3.type, 35666);
      expect(accessor3.max, [0.0,0.0,1.0,1.0]);

      //Because -0.707 can't be truly represented with IEEE 754 single-precision floating point type (since accessor.componentType is gl.FLOAT).
      expect(accessor3.min, [0.0,0.0,0.0,-0.7070000171661377]);
    });
    test("asset", () async {
      expect(gltfProject.asset, isNotNull);
      GLTFAsset asset = gltfProject.asset;
      expect(asset.version, "2.0");
    });
  });
}
