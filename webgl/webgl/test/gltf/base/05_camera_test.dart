import 'package:webgl/src/gltf/camera/camera.dart';
import 'package:webgl/src/gltf/camera/types/orthographic_camera.dart';
import 'package:webgl/src/gltf/camera/types/perspective_camera.dart';
import 'package:webgl/src/camera/camera_type.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'dart:async';
import "package:test/test.dart";

import '../../data/gltf_helper.dart';
@TestOn("browser")

String testFolderRelativePath = "../..";

Future main() async {

  group("GLTFCamera", () {
    test("Empty array", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/camera/empty.gltf';
      GLTFProject gltf = await loadGLTFProject(gltfPath);
      gltf.debug(doProjectLog : false, isDebug:false);

      List<GLTFCamera> cameras = gltf.cameras;
      expect(cameras.length, 0);
    });
    test("Filled Array", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/camera/valid_full.gltf';

      GLTFProject gltf = await loadGLTFProject(gltfPath);
      gltf.debug(doProjectLog : false, isDebug:false);

      expect(gltf.cameras.length, 2);
    });
    test("GLTFCamera Perspective Type", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/camera/valid_full.gltf';

      GLTFProject gltf = await loadGLTFProject(gltfPath);
      gltf.debug(doProjectLog : false, isDebug:false);

      expect(gltf.cameras[0], isNotNull);
      expect(gltf.cameras[0] is GLTFCameraPerspective, isTrue);
      GLTFCameraPerspective cameraPerspective = gltf.cameras[0] as GLTFCameraPerspective;
      expect(cameraPerspective.type, CameraType.perspective);
      expect(cameraPerspective.znear, 1.0);
      expect(cameraPerspective.zfar, 10.0);
      expect(cameraPerspective.yfov, 1.0);
      expect(cameraPerspective.aspectRatio, 1.0);

    });
    test("GLTFCamera Orthographic Type", () async {
      String gltfPath = '${testFolderRelativePath}/gltf/tests/base/data/camera/valid_full.gltf';

      GLTFProject gltf = await loadGLTFProject(gltfPath);
      gltf.debug(doProjectLog : false, isDebug:false);

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
