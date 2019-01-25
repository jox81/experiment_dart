import 'dart:async';
import 'dart:html';
import 'package:webgl/src/utils/utils_debug.dart';

/// Page de test pour la fonction logCurrentFunction();
Future main() async {
  logCurrentFunction();

  stream.listen(_streamUpdated);

//  funcSimple();
//  funcSimple();

//  await funcAsync('mainID');
//
//  func01();
//  func02();
//  func03();
//
//  funcRecursive();

  funcWithClosure();

  print('');
}

void funcWithClosure() {
  logCurrentFunction();

  void closureFunction(){
    logCurrentFunction();
  }

  stream.listen((dynamic v){
    logCurrentFunction();
    closureFunction();
  });

  funcAsync('funcWithClosureID');
}

int maxRecursiveCount = 5;
int currentRecursiveCount = 0;
void funcRecursive() {
  logCurrentFunction();
  if(currentRecursiveCount < maxRecursiveCount){
    currentRecursiveCount++;
    funcRecursive();
  }
}

void funcSimple() {
  logCurrentFunction();
}

void func01() {
  logCurrentFunction();

  innerFunction01();
}

void innerFunction01() {
  logCurrentFunction();
}

void func02() {
  logCurrentFunction();

  innerFunction02();
}

void innerFunction02() {
  logCurrentFunction();
  innerInnerFunction02();
}

void innerInnerFunction02() {
  logCurrentFunction();
}

void func03() {
  logCurrentFunction();
  func02();
}

StreamController streamController = new StreamController<String>.broadcast();
Stream get stream => streamController.stream;

Future funcAsync(String id) async {
  logCurrentFunction(id);
  String path =
      'https://www.dartlang.org/f/dailyNewsDigest.txt';
  HttpRequest.getString(path).then((String path){streamController.add(path);});
}

void _streamUpdated(dynamic event) {
  logCurrentFunction();
}
