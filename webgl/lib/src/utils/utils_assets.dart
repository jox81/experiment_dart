import 'dart:core';
import 'dart:html';
import 'dart:math';
import 'dart:convert';
import 'dart:async';

class UtilsAssets{

  static const String WEB_PATH_LOCALHOST8080 = 'http://localhost:8080/';
  static const String WEB_PATH_RELATIVE = './';

  // This webPath is used within the webFolder but it can be replaced with 'http://localhost:8080/' to use in unit test
  //This is usefull when using unit tests from port 8081... instead of web:8080
  static String _webPath = WEB_PATH_RELATIVE;
  static String get webPath => _webPath;
  static set webPath(String value) {
    _webPath = value;
  }

  static String getWebPath(String url) {
    String baseWebPath = UtilsAssets.webPath;
    if(url.startsWith('http://') ||url.startsWith('/') || url.startsWith('./') || url.startsWith('../')){
      baseWebPath = '';
    }else if(url.startsWith('packages')){
      baseWebPath = '${Uri.base.origin}/';
    }

    String fullPath = '${baseWebPath}${url}';
    print('UtilsAssets.getWebPath fullPath : $fullPath');
    return fullPath;
  }

  // Todo (jpu) : remove this ?
  static set useWebPath(bool value){
    if(value){
      _webPath = WEB_PATH_LOCALHOST8080;
    }else{
      _webPath = WEB_PATH_RELATIVE;
    }
  }

  ///Load a text resource from a file over the network
  static Future<String> loadTextResource (String url) {
    Completer completer = new Completer<String>();

    String assetsPath = getWebPath(url);

    Random random = new Random();
    HttpRequest request = new HttpRequest();
    request.open('GET', '$assetsPath?please-dont-cache=${random.nextInt(1000)}', async:true);
    request.timeout = 2000;
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
  static String loadTextResourceSync (String url) {
    Completer completer = new Completer<String>();

    Random random = new Random();
    var request = new HttpRequest();
    request.open('GET', '${url}?please-dont-cache=${random.nextInt(1000)}', async:false);
    request.timeout = 2000;
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
//        logCurrentFunction('loaded');
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

  static Future<Map<String, Object>> loadJSONResource (String url) async {
    Completer completer = new Completer<Map<String, Object>>();
    String result = await loadTextResource(url);
    try {
      final Map<String, Object> json = JSON.decode(result) as Map<String, Object>;
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