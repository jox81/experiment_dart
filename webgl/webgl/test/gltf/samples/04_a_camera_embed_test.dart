import 'dart:async';
import "package:test/test.dart";
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gltf/camera/camera.dart';
import 'package:webgl/src/camera/camera_type.dart';
import 'package:webgl/src/gltf/camera/types/orthographic_camera.dart';
import 'package:webgl/src/gltf/camera/types/perspective_camera.dart';
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
    String gltfPath = '${testFolderRelativePath}/gltf/tests/samples/gltf_2_0/04_camera/gltf_embed/Cameras.gltf';
    project = await loadGLTFProject(gltfPath);
    project.debug(doProjectLog : false, isDebug:false);
  });

  group("GLTFCamera Embed", () {
    test("Project creation", () async {
      expect(project, isNotNull);
    });
    test("scenes", () async {
      expect(project.scenes.length, 1);

      GLTFScene scene = project.scenes[0];
      expect(scene, isNotNull);
      expect(scene.nodes.length, 3);
      expect(scene.nodes[0], project.nodes[0]);
      expect(scene.nodes[1], project.nodes[1]);
      expect(scene.nodes[2], project.nodes[2]);
    });
    test("nodes", () async {
      expect(project.nodes.length, 3);

      GLTFNode node0 = project.nodes[0];
      expect(node0, isNotNull);
      expect(node0.nodeId, 0);
      expect(node0.mesh, isNotNull);
      expect(node0.mesh, project.meshes[0]);
      expect(node0.rotation.storage, new Vector4(-0.382999986410141,0.0,0.0,0.9237499833106995).storage);

      GLTFNode node1 = project.nodes[1];
      expect(node1, isNotNull);
      expect(node1.nodeId, 1);
      expect(node1.camera, isNotNull);
      expect(node1.camera.cameraId, 0);
      expect(node1.mesh, isNull);
      expect(node1.camera, project.cameras[0]);
      expect(node1.translation, new Vector3(0.5,0.5,3.0));

      GLTFNode node2 = project.nodes[2];
      expect(node2, isNotNull);
      expect(node2.nodeId, 2);
      expect(node2.camera, isNotNull);
      expect(node2.camera.cameraId, 1);
      expect(node2.mesh, isNull);
      expect(node2.camera, project.cameras[1]);
      expect(node2.translation, new Vector3(0.5,0.5,3.0));

    });
    test("cameras", () async {
      expect(project.cameras.length, 2);

      GLTFCamera camera0 = project.cameras[0];
      expect(camera0, isNotNull);
      expect(camera0.type, CameraType.perspective);
      expect(camera0.cameraId, 0);

      GLTFCameraPerspective camera0Perspective = camera0 as GLTFCameraPerspective;
      expect(camera0Perspective.aspectRatio, 1.0);
      expect(camera0Perspective.yfov, 0.7);
      expect(camera0Perspective.zfar, 100);
      expect(camera0Perspective.znear, 0.01);

      GLTFCamera camera1 = project.cameras[1];
      expect(camera1, isNotNull);
      expect(camera1.type, CameraType.orthographic);
      expect(camera1.cameraId, 1);

      GLTFCameraOrthographic camera1Orthographic = camera1 as GLTFCameraOrthographic;
      expect(camera1Orthographic.xmag, 1.0);
      expect(camera1Orthographic.ymag, 1.0);
      expect(camera1Orthographic.zfar, 100);
      expect(camera1Orthographic.znear, 0.01);
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
      expect(primitive.indices, isNotNull);
      expect(primitive.indices, project.accessors[0]);
    });
    test("animations", () async {
      expect(project.animations, isNotNull);
      expect(project.animations.length, 0);
    });
    test("buffers", () async {
      expect(project.buffers.length, 1);

      GLTFBuffer buffer0 = project.buffers[0];
      expect(buffer0, isNotNull);
      expect(buffer0.byteLength, 60);
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
      expect(bufferView0.usage, 34963);

      GLTFBufferView bufferView1 = project.bufferViews[1];
      expect(bufferView1, isNotNull);
      expect(project.buffers[0], isNotNull);
      expect(bufferView1.buffer, project.buffers[0]);
      expect(bufferView1.byteOffset, 12);
      expect(bufferView1.byteLength, 48);
      expect(bufferView1.target, 34962);
      expect(bufferView1.usage, 34962);
    });
    test("accessors", () async {
      expect(project.accessors.length, 2);

      GLTFAccessor accessor0 = project.accessors[0];
      expect(accessor0, isNotNull);
      expect(accessor0.bufferView, project.bufferViews[0]);
      expect(accessor0.byteOffset, 0);
      expect(accessor0.componentType, 5123);//UNSIGNED_SHORT
      print(accessor0.componentType);
      expect(accessor0.count, 6);
      expect(accessor0.typeString, 'SCALAR');
      expect(accessor0.type, isNull);// Todo (jpu) : componentType: UNSIGNED_SHORT : 5123, typeString: SCALAR => should be INT ?
      expect(accessor0.max, [3]);
      expect(accessor0.min, [0]);

      GLTFAccessor accessor1 = project.accessors[1];
      expect(accessor1, isNotNull);
      expect(accessor1.bufferView, project.bufferViews[1]);
      expect(accessor1.byteOffset, 0);
      expect(accessor1.componentType, 5126);//Float
      expect(accessor1.count, 4);
      expect(accessor1.typeString, 'VEC3');
      expect(accessor1.type, 35665);
      print(accessor1.type);//FLOAT_VEC3
      expect(accessor1.max, [1.0,1.0,0.0]);
      expect(accessor1.min, [0.0,0.0,0.0]);
    });
    test("asset", () async {
      expect(project.asset, isNotNull);
      GLTFAsset asset = project.asset;
      expect(asset.version, "2.0");
    });
  });
}
