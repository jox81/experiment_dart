import 'dart:core';
import 'dart:html';
import 'dart:math';
import 'dart:convert';
import 'dart:async';
import 'package:gltf/gltf.dart' as glTF;

class UtilsAssets{

  static const String WEB_PATH_WEB = 'http://localhost:8080/';
  static const String WEB_PATH_RELATIVE = '/';

  // This webPath is used within the webFolder but it can be replaced with 'http://localhost:8080/' to use in unit test
  static String _webPath = WEB_PATH_RELATIVE;
  static set useWebPath(bool value){
    if(value){
      _webPath = WEB_PATH_WEB;
    }else{
      _webPath = WEB_PATH_RELATIVE;
    }
  }

  ///Load a text resource from a file over the network
  static Future<String> loadTextResource (String url) {
    Completer completer = new Completer<String>();

    if(url.startsWith('/')){
      url = url.substring(1);
    }
    if(url.startsWith('./')){
      url = url.substring(2);
    }
    if(url.startsWith('../')){
      url = url.substring(3);
    }

    Random random = new Random();
    var request = new HttpRequest();
    request.open('GET', '${_webPath}${url}?please-dont-cache=${random.nextInt(1000)}', async:true);
    request.onLoadEnd.listen((_) {
      if (request.status < 200 || request.status > 299) {
        String fsErr = 'Error: HTTP Status ${request.status} on resource: ${_webPath}${url}';
        window.alert('Fatal error getting text ressource (see console)');
        print(fsErr);
        return completer.completeError(fsErr);
      } else {
        completer.complete(request.responseText);
      }
    });
    request.send();

    return completer.future as Future<String>;
  }

  ///Load a text resource from a file over the network
  static String loadTextResourceSync (String url) {
    Completer completer = new Completer<String>();

    Random random = new Random();
    var request = new HttpRequest();
    request.open('GET', '${url}?please-dont-cache=${random.nextInt(1000)}', async:false);
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
  static Future<String> loadGlslShader(String url) async {
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
  static String loadGlslShaderSync(String url) {
    String result;
    try {
      result = loadTextResourceSync(url);
    } catch (e) {
      print('error in loadGlslShader');
    }

    return result;
  }

  static Future<Map<String, dynamic>> loadJSONResource (String url) async {
    Completer completer = new Completer<Map>();
    await loadTextResource(url).then((String result){
      try {
          Map json = JSON.decode(result) as Map;
          completer.complete(json);
        } catch (e) {
          completer.completeError(e);
        }
    });

    return completer.future as Future<Map<String, dynamic>> ;
  }

  static Future<glTF.Gltf> loadGLTFResource(String url) async {
    Completer completer = new Completer<glTF.Gltf>();
    await loadJSONResource(url).then((Map<String, dynamic> result){
      try {
          glTF.Gltf gltf = new glTF.Gltf.fromMap(result, new glTF.Context());
          completer.complete(gltf);
        } catch (e) {
          completer.completeError(e);
        }
    });

    return completer.future as Future<glTF.Gltf>;
  }

  void makeRequest(Event e) {
    var path = 'shaderModel.vs.glsl';
    var httpRequest = new HttpRequest();
    httpRequest
      ..open('GET', path)
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
}