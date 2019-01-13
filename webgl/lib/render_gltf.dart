import 'dart:async';
import 'dart:html';
import 'package:webgl/engine/engine.dart';
import 'package:webgl/engine/gltf_engine.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/gltf/debug_gltf.dart';
import 'package:webgl/src/gltf/project.dart';

Future renderGltf(String gltfPath, CanvasElement canvas) async {
  GLTFProject gltfProject = await loadGLTF(gltfPath, useWebPath : false);
  await debugGltf(gltfProject, doGlTFProjectLog : false, isDebug:false);

  GLTFEngine engine = new GLTFEngine(canvas);

  await engine.renderer.init(gltfProject);
  engine.render();


}