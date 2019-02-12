import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'package:meta/meta.dart';
import 'package:webgl/src/assets_manager/load_progress_event.dart';
import 'package:webgl/src/assets_manager/loader.dart';
import 'package:webgl/src/assets_manager/not_loaded_exception.dart';
import 'package:webgl/src/gltf/project/project.dart';

class Library{

  StreamController<LoadProgressEvent> _onLoadProgressStreamController = new StreamController<LoadProgressEvent>.broadcast();
  Stream<LoadProgressEvent> get onLoadProgress => _onLoadProgressStreamController.stream;

  Map<String, LoadProgressEvent> _loadedFiles = {};
  Map<String, LoadProgressEvent> get loadedFiles => _loadedFiles;

  int get totalFileSize => _loadedFiles.values.map((p)=>p.progressEvent.total).reduce((a,b)=>a+b);
  int get totalFileCount => _loadedFiles.length;
  int get loadedFileSize => _loadedFiles.values.map((p)=>p.progressEvent.loaded).reduce((a,b)=>a+b);

  Map<FileLoader, Object> _data = new Map<FileLoader, Object>();

  Object _getAsset(String filePath) => _data[_data.keys.firstWhere((k)=> k.filePath == filePath)] ?? (throw new NotLoadedAssetException());
  void _addAssetPath(String filePath, LoaderType loaderType) {
    FileLoader fileLoader = new LoaderFactory().create(loaderType)
    ..filePath = filePath;
    addLoader(fileLoader);
  }

  void addLoader(FileLoader fileLoader){
    assert(fileLoader.filePath != null);
    _data[fileLoader] = null;

    fileLoader
      ..onLoadProgress.listen((LoadProgressEvent progressEvent){
        _loadedFiles[progressEvent.filePath] = progressEvent;
        _onLoadProgressStreamController.add(progressEvent);
      })
      ..onLoadEnd.listen((LoadProgressEvent progressEvent){
        _data[fileLoader] = fileLoader.result;
      });
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

  /// Will load only _data[loader] empty
  Future loadAll() async{
    print(_data.keys);
    await Future.forEach(_data.keys, (FileLoader fileLoader) async {
      if(_data[fileLoader] == null) await fileLoader.load();
    });
  }
}