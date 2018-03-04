import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:math';
import 'package:gltf/gltf.dart' as glTF;
import 'package:test_webgl/src/gltf/debug_gltf.dart';
import 'package:test_webgl/src/gltf/gltf_creation.dart';
import 'package:test_webgl/src/gltf/project.dart';
import 'package:test_webgl/src/gltf/renderer/renderer.dart';
//import 'package:test_webgl/src/introspection.dart';
import 'package:test_webgl/src/utils/utils_assets.dart';

Future main() async {
  final List<String> gltfSamplesPaths = [
    './projects/archi/model_01/model_01.gltf',
//    './projects/archi/model_02/model_02.gltf',
  ];

  UtilsAssets.webPath = '../';
  final GLTFProject gltfProject = await loadGLTF(gltfSamplesPaths.first, useWebPath : false);


//  final CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;
//  final GLTFRenderer rendered = new GLTFRenderer(canvas);
//
//  debugGltf(gltfProject, doGlTFProjectLog : false, isDebug:false);
//  await rendered.render(gltfProject);
}

//Future main() async {
//    final List<String> gltfSamplesPaths = [
//    './projects/archi/model_01/model_01.gltf',
////    './projects/archi/model_02/model_02.gltf',
//  ];
//
//  UtilsAssets.webPath = '../';
//
//  final GLTFProjectT gltfProject = await loadGLTF(gltfSamplesPaths.first);
//
////  glTF.Gltf gltf = await loadGLTFResource(gltfSamplesPaths.first);
//  print("ok");
//}

//Future<glTF.Gltf> loadGLTFResource(String url,
//    {bool useWebPath: false}) async {
//  UtilsAssets.useWebPath = useWebPath;
//
//  Completer completer = new Completer<glTF.Gltf>();
//  await UtilsAssets.loadJSONResource(url).then((Map<String, Object> result) {
//    try {
//      final glTF.Gltf gltf = new glTF.Gltf.fromMap(result, new glTF.Context());
//      completer.complete(gltf);
//    } catch (e) {
//      completer.completeError(e);
//    }
//  });
//
//  return completer.future as Future<glTF.Gltf>;
//}
//
Future<GLTFProject> loadGLTF(String gltfUrl, {bool useWebPath : false}) async {

  // Todo (jpu) : assert path exist and get real file
  final Uri baseUri = Uri.parse(gltfUrl);
  final String filePart = baseUri.pathSegments.last;
  final String gtlfDirectory = gltfUrl.replaceFirst(filePart, '');

  final glTF.Gltf gltfSource =
  await GLTFCreation.loadGLTFResource(gltfUrl, useWebPath: useWebPath);
  GLTFProject _gltf = await getGLTFProject(gltfSource, gtlfDirectory);
//
//  assert(_gltf != null);
//  print('');
//  print('> _gltf file loaded : $gltfUrl');
//  print('');

  return _gltf;
}

Future<GLTFProject> getGLTFProject(glTF.Gltf gltfSource, String baseDirectory) async {
  if (gltfSource == null) return null;

  GLTFProject _gltfProject = new GLTFProject.create()..baseDirectory = baseDirectory;

  GLTFCreation gltf = new GLTFCreation(_gltfProject, gltfSource);
  gltf.initGLTF();
//
//  await gltf.fillBuffersData();
//
//  return _gltfProject;
}