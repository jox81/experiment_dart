import 'dart:mirrors';
import 'dart:web_gl';

import 'package:webgl/src/context.dart';
import 'package:webgl/src/context/webgl_constants.dart';
import 'package:webgl/src/utils.dart';

class WebglParameters{

  static WebglParameters _instance;
  WebglParameters._init();
  static WebglParameters instance(){
    if(_instance == null){
      _instance = new WebglParameters._init();
    }
    return _instance;
  }

  List<WebglConstant> _possibleParameters;
  List<WebglConstant> get possibleParameters {
    if(_possibleParameters == null){
      initWebglParameters();
    }
    return _possibleParameters;
  }

  void initWebglParameters() {
    _possibleParameters = new List();
    for (WebglConstant webglConstant in Context.webglConstants.values) {
      WebglParameter webglParameter = getParameter(webglConstant.glEnum);
      if (webglParameter != null) {
        _possibleParameters.add(webglConstant);
      }
    }
  }

  void logPossibleParameters() {
    Utils.log('Webgl Possible Parameters',(){
      possibleParameters.forEach((c) {
        print('${c.glName} = ${c.glEnum}');
      });
    });
  }

  List<WebglParameter> _values;
  List<WebglParameter> get values {
    if(_values == null){
      _fillWebglParameters();
    }
    return _values;
  }

  void _fillWebglParameters() {
    _values = new List();
    for (WebglConstant webglConstant in possibleParameters) {
      WebglParameter webglParameter = getParameter(webglConstant.glEnum);
      if (webglParameter != null) {
        _values.add(webglParameter);
      }
    }
  }

  void logValues() {
    Utils.log('Webgl Parameters',(){
      values.forEach((p) {
        print('${p.toString()}');
      });
    });
  }

  WebglParameter getParameter(int glEnum) {
    var result = gl.getParameter(glEnum);
    int error = gl.getError();
    if (error != RenderingContext.INVALID_ENUM) {
      String glEnumStringValue;

      if (result is int) {
        WebglConstant constant = Context.webglConstants.values
            .firstWhere((c) => c.glEnum == (result as int), orElse: () => null);
        if (constant != null && constant.glEnum > 1) { // >1 pour ne pas avoir de confusion dans les enums possibles
          glEnumStringValue = Context.webglConstants.values
              .firstWhere((c) => c.glEnum == constant.glEnum)
              .glName;
        }
      }

      WebglParameter param = new WebglParameter()
        ..glName = Context.webglConstants.values.firstWhere((c) => c.glEnum == glEnum).glName
        ..glValue = glEnumStringValue != null ? glEnumStringValue : result
        ..glType = result.runtimeType.toString()
        ..glEnum = glEnum;
      return param;
    }

    return null;
  }

  void testGetParameter() {
    Utils.log('Test Get Parameters',(){
      print('TEXTURE0 : 0x84C0 = ${0x84C0}'); // == 33984
      print('ACTIVE_TEXTURE : 0x84E0 = ${0x84E0}'); // == 34016
      print(Context.webglParameters.getParameter(RenderingContext.ACTIVE_TEXTURE));
      //OK > ACTIVE_TEXTURE (34016) = TEXTURE0 : glEnum
      print('##################################################################');

      Object result = gl.getParameter(RenderingContext.BLEND_SRC_RGB);
      print(result);
      //NO > comment différencier une valeur int d'une valeur glEnum ?
      print(Context.webglParameters.getParameter(RenderingContext.BLEND_SRC_RGB));
      print(0x0001);
    });
  }
}

class WebglParameter {
  int glEnum;
  String glName;
  String glType;
  dynamic glValue;

  WebglParameter();

  @override
  String toString() {
    String typeString = (glType == 'int' && glValue is String)? 'glEnum' : glType;
    return '$glName${glEnum != null ? ' (${glEnum})' : ''} = ${glValue} : $typeString ';
  }
}