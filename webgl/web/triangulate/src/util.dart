import 'dart:html';
import 'dart:convert';
import 'dart:math';

class util{

  // Load a text resource from a file over the network
  static void loadTextResource (url, callback) {

    Random random = new Random();
    var request = new HttpRequest();
    request.open('GET', '${url}?please-dont-cache=${random.nextInt(1000)}', async:true);
    request.onLoadEnd.listen((_) {
      if (request.status < 200 || request.status > 299) {
        callback('Error: HTTP Status ' + request.status + ' on resource ' + url);
      } else {
        callback(null, request.responseText);
      }
    });
    request.send();
  }

  static void loadImage (url, callback) {
    ImageElement image = new ImageElement(src : url);
    image.onLoad.listen((_) {
      callback(null, image);
    });
  }

  static void  loadJSONResource (url, callback) {
    loadTextResource(url, (err, result) {
      if (err != null) {
        callback(err);
      } else {
        try {
          callback(null, JSON.decode(result));
        } catch (e) {
          callback(e);
        }
      }
    });
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

}