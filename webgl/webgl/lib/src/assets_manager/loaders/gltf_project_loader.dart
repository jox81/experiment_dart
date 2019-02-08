import 'package:webgl/src/assets_manager/loaders/json_loader.dart';
import 'package:webgl/src/assets_manager/loader.dart';
import 'package:webgl/src/gltf/project/gltf_load_project.dart';
import 'dart:core';
import 'dart:async';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/utils/utils_http.dart';

class GLTFProjectLoader extends Loader<GLTFProject>{
  GLTFProjectLoader();

  @override
  Future<GLTFProject> load(covariant String filePath, {bool useWebPath : false}) async {
    // Todo (jpu) : assert path exist and get real file
    final Uri baseUri = Uri.parse(filePath);
    final String filePart = baseUri.pathSegments.last;
    final String gtlfDirectory = filePath.replaceFirst(filePart, '');

    final glTF.Gltf gltfSource =
        await _loadGLTFResource(filePath, useWebPath: useWebPath);
    final GLTFProject _gltf = await _getGLTFProject(gltfSource, gtlfDirectory);

    assert(_gltf != null);
    print('');
    print('> _gltf file loaded : $filePath');
    print('');

    return _gltf;
  }

  Future<GLTFProject> _getGLTFProject(
      glTF.Gltf gltfSource, String baseDirectory) async {
    if (gltfSource == null) return null;

    GLTFLoadProject _gltfProject = new GLTFLoadProject()
      ..baseDirectory = baseDirectory;
    await _gltfProject.initFromSource(gltfSource);

    return _gltfProject;
  }

  Future<glTF.Gltf> _loadGLTFResource(String filePath,
      {bool useWebPath: false}) async {
    UtilsHttp.useWebPath = useWebPath;

    Completer completer = new Completer<glTF.Gltf>();
    Map<String, Object> result = await new JsonLoader().load(filePath);
    try {
      final glTF.Gltf gltf = new glTF.Gltf.fromMap(result, new glTF.Context());
      completer.complete(gltf);
    } catch (e) {
      completer.completeError(e);
    }

    return completer.future as Future<glTF.Gltf>;
  }

  @override
  GLTFProject loadSync(covariant String filePath, {bool useWebPath : false}) {
    throw new Exception('not yet implemented');
  }
}