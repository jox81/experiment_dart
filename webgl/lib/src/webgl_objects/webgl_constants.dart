@MirrorsUsed(targets:const[WebglConstant, WebglConstants], override:'*')
import 'dart:mirrors';
import 'dart:web_gl';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/utils/utils_debug.dart';

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

  void logConstants() {
    Debug.log('Webgl Constants',(){
      values.forEach((c)=> print(c));
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
          int glEnum = classMirror.getField(decl.simpleName).reflectee as int;

          WebglConstant constant = new WebglConstant()
            ..glEnum = glEnum
            ..glName = name;

          constant.isParameter = isParameter(glEnum);

          _values.add(constant);
        }
      }
    }
  }

  bool isParameter(int glEnum) {
    gl.getParameter(glEnum);
    bool isParameter = gl.getError() != RenderingContext.INVALID_ENUM;
    return isParameter;
  }

  List<WebglConstant> get parameters {
    return values.where((c)=> c.isParameter == true).toList();
  }

  void logParameters() {
    Debug.log('Webgl Parameters',(){
      parameters.forEach((c)=> print(c));
    });
  }
}

class WebglConstant {
  int glEnum;
  String glName;

  bool isParameter;

  WebglConstant();

  @override
  String toString() {
    return '${glName} = ${glEnum} ${isParameter?'| isParameter' : ''}';
  }
}
