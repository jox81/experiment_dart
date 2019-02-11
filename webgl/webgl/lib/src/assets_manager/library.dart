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

  Map<Loader, Object> _data = new Map<Loader, Object>();

  Object _getAsset(String filePath) => _data[_data.keys.firstWhere((k)=> k.filePath == filePath)] ?? (throw new NotLoadedAssetException());
  void _addAssetPath(String filePath, LoaderType loaderType) {
    Loader loader = new LoaderFactory().create(loaderType)
    ..filePath = filePath;
    addLoader(loader);
  }

  void addLoader(Loader loader){
    assert(loader.filePath != null);
    loader.onLoadProgress.listen((LoadProgressEvent progressEvent){
      _loadedFiles[progressEvent.filePath] = progressEvent;
      _onLoadProgressStreamController.add(progressEvent);
    });
    _data[loader] = null;
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
    await Future.forEach(_data.keys, (Loader loader) async {
      _data[loader] ??= await loader.load();
    });
  }
}