import 'dart:core';
import 'dart:html';
import 'dart:async';
import 'package:webgl/src/assets_manager/loader.dart';
import 'package:webgl/src/assets_manager/loaders/bytebuffer_loader.dart';
import 'package:webgl/src/assets_manager/loaders/glsl_loader.dart';
import 'package:webgl/src/assets_manager/loaders/gltf_bin_loader.dart';
import 'package:webgl/src/assets_manager/loaders/gltf_project_loader.dart';
import 'package:webgl/src/assets_manager/loaders/image_loader.dart';
import 'package:webgl/src/assets_manager/loaders/json_loader.dart';
import 'package:webgl/src/assets_manager/loaders/text_loader.dart';
import 'package:webgl/src/assets_manager/load_progress_event.dart';
import 'dart:typed_data';
import 'package:webgl/src/gltf/project/project.dart';

class AssetManager{

  AssetManager();

  get onLoadProgress => null;

  /// should manage libraries and loadprogress







//  ///Load a text resource from a file over the network
//  Future<String> loadTextResource (String url) async {
//    return await new TextLoader().load(url);
//  }
//
//  ///Load a text resource from a file over the network
//  String loadTextResourceSync (String url) {
//    return new TextLoader().loadSync(url);
//  }
//
//  ///Load a Glsl from a file url
//  Future<String> loadGlslShader(String url) async {
//    return await new GLSLLoader().load(url);
//  }
//
//  ///Load a Glsl from a file url synchronously
//  String loadGlslShaderSync(String url) {
//    return new GLSLLoader().loadSync(url);
//  }
//
//  Future<Map<String, Object>> loadJSONResource (String url) async {
//    return await new JsonLoader().load(url);
//  }

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

//  Future loadShaders() async {
//    await new ShaderSources().loadShaders();
//  }
//
//  /// [gltfUrl] the url to find the gtlf file.
//  Future<GLTFProject> loadGLTFProject(String gltfUrl, {bool useWebPath : false}) async {
//    return await new GLTFProjectLoader().load(gltfUrl, useWebPath:useWebPath);
//  }
//
//  Future<Uint8List> loadGltfBinResource(String url) async {
//    return new GLTFBinLoader().load(url);
//  }

//  Future<ByteBuffer> loadByteBuffer(String url) async {
//    return await new ByteBufferLoader().load(url);
//  }

//  ///Load a single image from an URL
//  Future<ImageElement> loadImage(String url) async {
//    return new ImageLoader().load(url);
//  }

//  List<ImageElement> loadImages(List<String> paths) {
//    return new ImageLoader().loadImages(paths);
//  }
}