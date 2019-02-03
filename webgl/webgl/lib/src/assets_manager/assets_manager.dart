import 'dart:core';
import 'dart:html';
import 'dart:math';
import 'dart:convert';
import 'dart:async';
import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gltf/project/gltf_load_project.dart';
import 'dart:typed_data';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/src/shaders/shader_source.dart';

class LoadProgressEvent{
  final ProgressEvent progressEvent;
  final String name;

  LoadProgressEvent(this.progressEvent, this.name);
}

class AssetsManager{

  static const String WEB_PATH_LOCALHOST8080 = 'http://localhost:8080/';
  static const String WEB_PATH_RELATIVE = './';

  StreamController<LoadProgressEvent> _onLoadProgressStreamController = new StreamController<LoadProgressEvent>.broadcast();
  Stream<LoadProgressEvent> get onLoadProgress => _onLoadProgressStreamController.stream;

  AssetsManager();

  // This webPath is used within the webFolder but it can be replaced with 'http://localhost:8080/' to use in unit test
  //This is usefull when using unit tests from port 8081... instead of web:8080 Worked with previous version. but now with dart  2.0 no
  String _webPath = WEB_PATH_RELATIVE;
  String get webPath => _webPath;
  set webPath(String value) {
    _webPath = value;
  }

  String getWebPath(String url) {
    String baseWebPath = webPath;
    if(url.startsWith('http://') ||url.startsWith('/') || url.startsWith('./') || url.startsWith('../')){
      baseWebPath = '';
    }else if(url.startsWith('packages')){
      baseWebPath = '${Uri.base.origin}/';
    }

    String fullPath = '${baseWebPath}${url}';
//    print('UtilsAssets.getWebPath fullPath : $fullPath');
    return fullPath;
  }

  // Todo (jpu) : remove this ?
  set useWebPath(bool value){
    if(value){
      _webPath = WEB_PATH_LOCALHOST8080;
    }else{
      _webPath = WEB_PATH_RELATIVE;
    }
  }

  ///Load a text resource from a file over the network
  Future<String> loadTextResource (String url) {
    Completer completer = new Completer<String>();

    String assetsPath = getWebPath(url);

    Random random = new Random();
    HttpRequest request = new HttpRequest();
    request.open('GET', '$assetsPath?please-dont-cache=${random.nextInt(1000)}', async:true);
    request.onProgress.listen((ProgressEvent event){
      _onLoadProgressStreamController.add(new LoadProgressEvent(event, url));
    });
    request.timeout = 20000;
    request..onLoadEnd.listen((_) {
      if (request.status < 200 || request.status > 299) {
        String fsErr = 'Error: HTTP Status ${request.status} on resource: $assetsPath';
        window.alert('Fatal error getting text ressource (see console)');
        print(fsErr);
        return completer.completeError(fsErr);
      } else {
        completer.complete(request.responseText);
      }
    })
    ..onError.listen((ProgressEvent event){
      print('Error : url : $url | assetsPath : $assetsPath');
    });
    request.send();

    return completer.future as Future<String>;
  }

  ///Load a text resource from a file over the network
  String loadTextResourceSync (String url) {
    Completer completer = new Completer<String>();

    Random random = new Random();
    var request = new HttpRequest();
    request.open('GET', '${url}?please-dont-cache=${random.nextInt(1000)}', async:false);
    request.timeout = 2000;
    request.onProgress.listen((ProgressEvent event){
      _onLoadProgressStreamController.add(new LoadProgressEvent(event, url));
    });
    request.onLoadEnd.listen((_) {
      if (request.status < 200 || request.status > 299) {
        String fsErr = 'Error: HTTP Status ${request.status} on resource ' + url;
        window.alert('Fatal error getting text ressource (see console)');
        print(fsErr);
        return completer.completeError(fsErr);
      } else {
        completer.complete(request.responseText);
      }
    });
    request.send();

    return request.responseText;
  }

  ///Load a Glsl from a file url
  Future<String> loadGlslShader(String url) async {
    Completer completer = new Completer<String>();
    await loadTextResource(url).then((String result){
      try {
        completer.complete(result);
      } catch (e) {
        completer.completeError(e);
      }
    });

    return completer.future as Future<String>;
  }

  ///Load a Glsl from a file url synchronously
  String loadGlslShaderSync(String url) {
    String result;
    try {
      result = loadTextResourceSync(url);
    } catch (e) {
      print('error in loadGlslShader');
    }

    return result;
  }

  Future<Map<String, Object>> loadJSONResource (String url) async {
    Completer completer = new Completer<Map<String, Object>>();
    String result = await loadTextResource(url);
    try {
      final Map<String, Object> json = jsonDecode(result) as Map<String, Object>;
      completer.complete(json);
    } catch (e) {
      completer.completeError(e);
    }

    return completer.future as Future<Map<String, Object>> ;
  }

  void makeRequest(Event e) {
    var path = 'shaderModel.vs.glsl';
    var httpRequest = new HttpRequest();
    httpRequest
      ..open('GET', path)
    ..onProgress.listen((ProgressEvent event){
      _onLoadProgressStreamController.add(new LoadProgressEvent(event, path));
    })
      ..onLoadEnd.listen((e) => requestComplete(httpRequest))
      ..send('');
  }

  void requestComplete(HttpRequest request) {
    if (request.status == 200) {
      print("200");
    } else {
      print('Request failed, status=${request.status}');
    }
  }

  Future loadShaders() async {
    ShaderSource _shaderSource=  new ShaderSource();
    await _shaderSource.loadShaders();
  }

  /// [gltfUrl] the url to find the gtlf file.
  Future<GLTFProject> loadGLTFProject(String gltfUrl, {bool useWebPath : false}) async {

    // Todo (jpu) : assert path exist and get real file
    final Uri baseUri = Uri.parse(gltfUrl);
    final String filePart = baseUri.pathSegments.last;
    final String gtlfDirectory = gltfUrl.replaceFirst(filePart, '');

    final glTF.Gltf gltfSource =
    await loadGLTFResource(gltfUrl, useWebPath: useWebPath);
    final GLTFProject _gltf = await _getGLTFProject(gltfSource, gtlfDirectory);

    assert(_gltf != null);
    print('');
    print('> _gltf file loaded : $gltfUrl');
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

  Future<Uint8List> loadGltfBinResource(String url,
      {bool isRelative: true}) {
    Completer completer = new Completer<Uint8List>();

    String assetsPath = getWebPath(url);
    print('url : $url | assetsPath : $assetsPath');

    Random random = new Random();
    HttpRequest request = new HttpRequest()..responseType = 'arraybuffer';
    request.open('GET', '$assetsPath?please-dont-cache=${random.nextInt(1000)}',
        async: true);
    request.onProgress.listen((ProgressEvent event){
      _onLoadProgressStreamController.add(new LoadProgressEvent(event, url));
    });
    request.timeout = 2000;
    request.onLoadEnd.listen((_) {
      if (request.status < 200 || request.status > 299) {
        String fsErr =
            'Error: HTTP Status ${request.status} on resource: $assetsPath';
        window.alert('Fatal error getting text ressource (see console)');
        print(fsErr);
        return completer.completeError(fsErr);
      } else {
        ByteBuffer byteBuffer = request.response as ByteBuffer;
        completer.complete(new Uint8List.view(byteBuffer));
      }
    });
    request.send();

    return completer.future as Future<Uint8List>;
  }

  Future<glTF.Gltf> loadGLTFResource(String url,
      {bool useWebPath: false}) async {
    this.useWebPath = useWebPath;

    Completer completer = new Completer<glTF.Gltf>();
    Map<String, Object> result = await loadJSONResource(url);
    try {
      final glTF.Gltf gltf = new glTF.Gltf.fromMap(result, new glTF.Context());
      completer.complete(gltf);
    } catch (e) {
      completer.completeError(e);
    }

    return completer.future as Future<glTF.Gltf>;
  }

  List<ImageElement> loadImages(List<String> paths) {
    List<ImageElement> images = [];

    for(String url in paths) {
      String assetsPath = getWebPath(url);
      ImageElement image = new ImageElement()
        ..src = assetsPath;
      images.add(image);
    }

    return images;
  }

  ///Load a single image from an URL
  Future<ImageElement> loadImage(String url) {

    Completer completer = new Completer<ImageElement>();

    String assetsPath = getWebPath(url);

    ImageElement image;
    image = new ImageElement()
      ..src = assetsPath
      ..onLoad.listen((e) {
        if(!completer.isCompleted) {
          completer.complete(image);
        }
      })
      ..onError.listen((Event event){
        print('Error : url : $url | assetsPath : $assetsPath');
      });

    return completer.future as Future<ImageElement>;
  }
}