import 'dart:async';
import "package:test/test.dart";
import 'package:webgl/engine.dart';
import 'package:webgl/src/gltf/debug_gltf.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/project/project_debugger.dart';

import '../../data/gltf_helper.dart';

@TestOn("browser")

String testFolderRelativePath = "../..";

Future main() async {

  setUp(() async {
  });

  tearDown(() async {
  });

  group("test camera", () {
    test("test camera creation", () async {
      GLTFProject project = await loadGLTFProject('${testFolderRelativePath}/gltf/tests/base/data/camera/empty.gltf');

      ProjectDebugger projectDebugger = new GLTFProjectDebugger();
      await projectDebugger.debug(project, doProjectLog : false, isDebug:false);
      expect(project, isNotNull);
    });
  });
}