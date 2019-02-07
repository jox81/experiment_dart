import 'dart:async';
import "package:test/test.dart";
import 'dart:html';

@TestOn("browser")

HttpRequest request;
Future main() async {

  String url = 'data/test.txt';

  setUp(() async {
    request = new HttpRequest();
  });

  tearDown(() async {
    request = null;
  });

  group("Assets load Init", () {
    test("get file in /test/test.txt", () async {
      String baseUrl = '../';
      getFileWithHttp(baseUrl, url);
    });
  });
}

void getFileWithHttp(String baseUrl, String url) {
  String path = '${baseUrl}${url}';

  request.open('GET', path, async: false);
  request.onLoadEnd.listen((_) {
    print(request.status);
    print(request.responseText);
    expect(request.status == 200, isTrue);
  });
  request.onError.listen((event){
    print('error');
  });
  request.send();
  print(path);
}