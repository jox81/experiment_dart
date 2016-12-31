import 'dart:mirrors';
import 'dart:web_gl';

import 'package:webgl/src/utils.dart';

class WebglConstants{

  static WebglConstants _instance;
  WebglConstants._init();
  static WebglConstants instance(){
    if(_instance == null){
      _instance = new WebglConstants._init();
    }
    return _instance;
  }

  List<WebglConstant> _values;
  List<WebglConstant> get values {
    if(_values == null){
      initWebglConstants();
    }
    return _values;
  }

  void logValues() {
    Utils.log('Webgl Constants',(){
      values.forEach((c) {
        print('${c.glName} = ${c.glEnum}');
      });
    });
  }

  void initWebglConstants() {
    _values = new List();

    ClassMirror classMirror = reflectClass(RenderingContext);
    String className = MirrorSystem.getName(classMirror.simpleName);

    for (DeclarationMirror decl in classMirror.declarations.values) {

      String ownerName = MirrorSystem.getName(decl.owner.simpleName);

      if (className == ownerName) {
        if (decl is VariableMirror) {
          String name = MirrorSystem.getName(decl.simpleName);
          int glEnum = classMirror.getField(decl.simpleName).reflectee;

          WebglConstant constant = new WebglConstant()
            ..glEnum = glEnum
            ..glName = name;

          _values.add(constant);
        }
      }
    }
  }
}

class WebglConstant {
  int glEnum;
  String glName;

  WebglConstant();
}
