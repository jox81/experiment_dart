import 'dart:core';
import 'dart:html';
import 'dart:async';
import 'package:webgl/src/assets_manager/loader/bytebuffer_loader.dart';
import 'package:webgl/src/assets_manager/loader/glsl_loader.dart';
import 'package:webgl/src/assets_manager/loader/gltf_bin_loader.dart';
import 'package:webgl/src/assets_manager/loader/gltf_project_loader.dart';
import 'package:webgl/src/assets_manager/loader/image_loader.dart';
import 'package:webgl/src/assets_manager/loader/json_loader.dart';
import 'package:webgl/src/assets_manager/loader/load_progress_event.dart';
import 'package:webgl/src/assets_manager/loader/text_loader.dart';
import 'dart:typed_data';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/shaders/shader_source.dart';
import 'package:webgl/src/utils/utils_http.dart';

//    count : ${id}/${assetManager.loadedFiles.length - 1}

class AssetManager{

  List<String> _filesToLoad = new List();
  List<String> get filesToLoad => _filesToLoad;

  Map<String, LoadProgressEvent> _loadedFiles = new Map();
  Map<String, LoadProgressEvent> get loadedFiles => _loadedFiles;

  StreamController<LoadProgressEvent> _onLoadProgressStreamController = new StreamController<LoadProgressEvent>.broadcast();
  Stream<LoadProgressEvent> get onLoadProgress => _onLoadProgressStreamController.stream;

  AssetManager();

  ///Load a text resource from a file over the network
  Future<String> loadTextResource (String url) async {
    return await new TextLoader(url).load();
  }

  ///Load a text resource from a file over the network
  String loadTextResourceSync (String url) {
    return new TextLoader(url).loadSync();
  }

  ///Load a Glsl from a file url
  Future<String> loadGlslShader(String url) async {
    return await new GLSLLoader(url).load();
  }

  ///Load a Glsl from a file url synchronously
  String loadGlslShaderSync(String url) {
    return new GLSLLoader(url).loadSync();
  }

  Future<Map<String, Object>> loadJSONResource (String url) async {
    return await new JsonLoader(url).load();
  }

//  void makeRequest(Event e) {
//    String path = 'shaderModel.vs.glsl';
//    HttpRequest request = new HttpRequest();
//    request
//      ..open('GET', path);
//    request.onProgress.listen((ProgressEvent event){
//      updateLoadProgress(event, path);
//    });
//    request
//      ..onLoadEnd.listen((e) => requestComplete(request))
//      ..send('');
//  }
//
//  void requestComplete(HttpRequest request) {
//    if (request.status == 200) {
//      print("200");
//    } else {
//      print('Request failed, status=${request.status}');
//    }
//  }

  Future loadShaders() async {
    await new ShaderSources(this).loadShaders();
  }

  /// [gltfUrl] the url to find the gtlf file.
  Future<GLTFProject> loadGLTFProject(String gltfUrl, {bool useWebPath : false}) async {
    return await new GLTFProjectLoader(gltfUrl, useWebPath:useWebPath).load();
  }

  Future<Uint8List> loadGltfBinResource(String url) async {
    return new GLTFBinLoader(url).load();
  }

  Future<ByteBuffer> loadByteBuffer(String url) async {
    return await new ByteBufferLoader(url).load();
  }

  ///Load a single image from an URL
  Future<ImageElement> loadImage(String url) async {
    return new ImageLoader(url).load();
  }

  List<ImageElement> loadImages(List<String> paths) {
    List<ImageElement> images = [];

    for(String url in paths) {
      String assetsPath = UtilsHttp.getWebPath(url);
      ImageElement image = new ImageElement()
        ..src = assetsPath;
      images.add(image);
    }

    return images;
  }
}