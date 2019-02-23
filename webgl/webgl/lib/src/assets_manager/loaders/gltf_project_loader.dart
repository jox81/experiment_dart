import 'package:webgl/asset_library.dart';
import 'package:webgl/src/assets_manager/loaders/gltf_bin_loader.dart';
import 'package:webgl/src/assets_manager/loaders/json_loader.dart';
import 'package:webgl/src/assets_manager/loader.dart';
import 'package:webgl/src/gltf/buffer.dart';
import 'package:webgl/src/gltf/project/gltf_load_project.dart';
import 'dart:core';
import 'dart:async';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:gltf/gltf.dart' as glTF;

class GLTFProjectLoader extends FileLoader<GLTFProject>{
  GLTFProjectLoader();

  @override
  Future load() async {
    // Todo (jpu) : assert path exist and get real file
    final Uri baseUri = Uri.parse(filePath);
    final String filePart = baseUri.pathSegments.last;
    final String gtlfDirectory = filePath.replaceFirst(filePart, '');

    final glTF.Gltf gltfSource =
        await loadGLTFResource(filePath);
    final GLTFProject project = await _getGLTFProject(gltfSource, gtlfDirectory);

    assert(project != null);

    result = project;
    onLoadEndStreamController.add(progressEvent);
  }

  Future<GLTFProject> _getGLTFProject(
      glTF.Gltf gltfSource, String baseDirectory) async {
    if (gltfSource == null) return null;

    GLTFLoadProject project = new GLTFLoadProject()
      ..baseDirectory = baseDirectory;

    await project.initFromSource(gltfSource);
    await fillBuffersData(project);
    await project.loadImages();

    return project;
  }

  ///permet de remplir les buffers du project. ici à cause des loaders
  Future fillBuffersData(GLTFLoadProject project) async {
    for (GLTFBuffer buffer in project.buffers) {
      if (buffer.data == null &&
          buffer.uri != null &&
          buffer.uri.path.length > 0) {
        String ressourcePath = '${project.baseDirectory}${buffer.uri}';

        GLTFBinLoader loader = new GLTFBinLoader()..filePath = ressourcePath;
        AssetLibrary.project.addLoader(loader);

        loader.load();
        await loader.onLoadEnd.first;

        buffer.data = loader.result;
      }
    }
  }

  Future<glTF.Gltf> loadGLTFResource(String filePath) async {

    Completer completer = new Completer<glTF.Gltf>();
    JsonLoader fileLoader = new JsonLoader()
      ..onLoadProgress.listen(onLoadProgressStreamController.add)
      ..filePath = filePath;

    AssetLibrary.project.addLoader(fileLoader);

    fileLoader.load();
    await fileLoader.onLoadEnd.first;

    Map<String, Object> result = fileLoader.result;

    try {
      final glTF.Gltf gltf = new glTF.Gltf.fromMap(result, new glTF.Context());
      completer.complete(gltf);
    } catch (e) {
      completer.completeError(e);
    }

    return completer.future as Future<glTF.Gltf>;
  }

  @override
  GLTFProject loadSync() {
    throw new Exception('not yet implemented');
  }
}