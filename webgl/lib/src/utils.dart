import 'dart:html';
import 'dart:math';
import 'dart:convert';
import 'dart:async';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/texture_utils.dart';

class Utils{

  static double fpsAverage;

  ///Display the animation's FPS in a div.
  static void showFps(Element element, num fps) {
    if(element == null) return;

    if (fpsAverage == null) {
      fpsAverage = fps.toDouble();
    }

    fpsAverage = fps * 0.05 + fpsAverage * 0.95;

    element.text = "${fpsAverage.round()} fps";
  }

  ///Load a text resource from a file over the network
  static Future loadTextResource (url) {
    Completer completer = new Completer();

    Random random = new Random();
    var request = new HttpRequest();
    request.open('GET', '${url}?please-dont-cache=${random.nextInt(1000)}', async:true);
    request.onLoadEnd.listen((_) {
      if (request.status < 200 || request.status > 299) {
        String fsErr = 'Error: HTTP Status ' + request.status + ' on resource ' + url;
        window.alert('Fatal error getting text ressource (see console)');
        print(fsErr);
        return completer.completeError(fsErr);
      } else {
        completer.complete(request.responseText);
      }
    });
    request.send();

    return completer.future;
  }

  ///Load a text resource from a file over the network
  static String loadTextResourceSync (url) {
    Completer completer = new Completer();

    Random random = new Random();
    var request = new HttpRequest();
    request.open('GET', '${url}?please-dont-cache=${random.nextInt(1000)}', async:false);
    request.onLoadEnd.listen((_) {
      if (request.status < 200 || request.status > 299) {
        String fsErr = 'Error: HTTP Status ' + request.status + ' on resource ' + url;
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
    Completer completer = new Completer();
    await loadTextResource(url).then((String result){
      try {
        completer.complete(result);
      } catch (e) {
        completer.completeError(e);
      }
    });

    return completer.future;
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

  static Future loadJSONResource (url) async {
    Completer completer = new Completer();
    await loadTextResource(url).then((String result){
      try {
          var json = JSON.decode(result);
          completer.complete(json);
        } catch (e) {
          completer.completeError(e);
        }
    });

    return completer.future;
  }

  void makeRequest(Event e) {
    var path = 'shaderModel.vs.glsl';
    var httpRequest = new HttpRequest();
    httpRequest
      ..open('GET', path)
      ..onLoadEnd.listen((e) => requestComplete(httpRequest))
      ..send('');
  }

  requestComplete(HttpRequest request) {
    if (request.status == 200) {
      print("200");
    } else {
      print('Request failed, status=${request.status}');
    }
  }

  static Vector3 screenToWorld(Matrix4 cameraMatrix, int screenWidth, int screenHeight, int screenX, int screenY) {
    Vector3 worldPick = new Vector3.all(0.0);
    unproject(cameraMatrix, 0, screenWidth, 0, screenHeight, screenX, screenY, 0.0, worldPick);
    return new Vector3(-worldPick.x, worldPick.y, worldPick.z);
  }
}