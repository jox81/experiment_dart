import 'dart:async';
import "package:test/test.dart";
import 'dart:html';

@TestOn("dartium")

Future main() async {

  String url = 'test.txt';

  setUp(() async {
  });

  tearDown(() async {
  });

  group("Assets load Init", () {
    test("get file in /test/test.txt", () async {
      String baseUrl = '../';
      getFileWithHttp(baseUrl, url);
    });
    test("get file in /web/test.txt", () async {
      String baseUrl = 'http://localhost:8080/';
      getFileWithHttp(baseUrl, url);
    });
  });
}

void getFileWithHttp(String baseUrl, String url) {
  var request = new HttpRequest();
  request.open('GET', '${baseUrl}${url}');
  request.onLoadEnd.listen((_) {
    print(request.status);
    print(request.responseText);
    expect(request.status != 404, isTrue);
  });
  request.send();
}