import 'dart:async';
import 'package:gltf/gltf.dart' as glTF;
import 'package:test/test.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/utils/utils_gltf.dart';

@TestOn("dartium")

Future main() async {

  group("Camera", () {
    test("Empty array", () async {
      glTF.Gltf gltfSource = await GLTFProject.loadGLTFResource('gltf/tests/base/data/camera/empty.gltf', useWebPath:true);
      GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);

      List<Camera> cameras = gltf.cameras;
      expect(cameras.length, 0);
    });
    test("Filled Array", () async {
      glTF.Gltf gltfSource = await GLTFProject.loadGLTFResource('gltf/tests/base/data/camera/valid_full.gltf', useWebPath:true);

      GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);
      expect(gltf.cameras.length, 2);
    });
    test("Camera Perspective Type", () async {
      glTF.Gltf gltfSource = await GLTFProject.loadGLTFResource('gltf/tests/base/data/camera/valid_full.gltf', useWebPath:true);

      GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);

      expect(gltf.cameras[0], isNotNull);
      expect(gltf.cameras[0] is GLTFCameraPerspective, isTrue);
      GLTFCameraPerspective cameraPerspective = gltf.cameras[0] as GLTFCameraPerspective;
      expect(cameraPerspective.type, CameraType.perspective);
      expect(cameraPerspective.znear, 1.0);
      expect(cameraPerspective.zfar, 10.0);
      expect(cameraPerspective.yfov, 1.0);
      expect(cameraPerspective.aspectRatio, 1.0);

    });
    test("Camera Orthographic Type", () async {
      glTF.Gltf gltfSource = await GLTFProject.loadGLTFResource('gltf/tests/base/data/camera/valid_full.gltf', useWebPath:true);

      GLTFProject gltf = new GLTFProject.fromGltf(gltfSource);

      expect(gltf.cameras[1], isNotNull);
      expect(gltf.cameras[1] is GLTFCameraOrthographic, isTrue);
      GLTFCameraOrthographic cameraOrthographic = gltf.cameras[1] as GLTFCameraOrthographic;
      expect(cameraOrthographic.type, CameraType.orthographic);
      expect(cameraOrthographic.znear, 1.0);
      expect(cameraOrthographic.zfar, 10.0);
      expect(cameraOrthographic.ymag, 1.0);
      expect(cameraOrthographic.xmag, 1.0);

    });
  });
}
