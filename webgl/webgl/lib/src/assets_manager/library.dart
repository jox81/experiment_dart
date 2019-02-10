import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'package:meta/meta.dart';
import 'package:webgl/src/assets_manager/library/library_loader.dart';
import 'package:webgl/src/assets_manager/loader.dart';
import 'package:webgl/src/assets_manager/not_loaded_exception.dart';
import 'package:webgl/src/gltf/project/project.dart';

class Library{
  Map<LibraryLoader, Object> _data = {};

  Object _getAsset(String filePath) => _data[_data.keys.firstWhere((k)=> k.filePath == filePath)] ?? (throw new NotLoadedAssetException());
  void _addAssetPath(String filePath, LoaderType loaderType) {
    Loader loader = new LoaderFactory().create(loaderType);
    LibraryLoader libraryLoader = new LibraryLoader(filePath, loader);
    _data[libraryLoader] = null;
  }

  @protected
  ImageElement getImageElement(String filePath) => _getAsset(filePath) as ImageElement;
  @protected
  void addImageElementPath(String filePath) {
    _addAssetPath(filePath, LoaderType.imageElement);
  }

  @protected
  GLTFProject getGLTFProject(String filePath) => _getAsset(filePath) as GLTFProject;
  @protected
  void addGLTFProjectPath(String filePath) {
    _addAssetPath(filePath, LoaderType.gltfProject);
  }

  @protected
  Uint8List getGLTFBin(String filePath) => _getAsset(filePath) as Uint8List;
  @protected
  void addGLTFBinPath(String filePath) {
    _addAssetPath(filePath, LoaderType.gltfBin);
  }

  Future loadAll() async{
    // Todo (jpu) : add check for the total size of the files to load

    await Future.forEach(_data.keys, (LibraryLoader libraryLoader) async {

//      int fileSize = await libraryLoader.getFileSize();
//      Loader.totalFileSize += fileSize;
//      print("will load : ${fileSize} |${libraryLoader.filePath}");
    });

    await Future.forEach(_data.keys, (LibraryLoader libraryLoader) async {
      _data[libraryLoader] ??= await libraryLoader.load();
    });
  }
}