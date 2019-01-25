import 'dart:web_gl';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/utils/utils_debug.dart';
import 'package:webgl/src/webgl_objects/webgl_constants.dart';
import 'package:webgl/src/webgl_objects/webgl_parameter.dart';

class WebglParameters{

  static WebglParameters _instance;
  WebglParameters._init();
  static WebglParameters instance(){
    if(_instance == null){
      _instance = new WebglParameters._init();
    }
    return _instance;
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
    for (WebglConstant webglConstant in Context.webglConstants.parameters) {
      WebglParameter webglParameter = getParameter(webglConstant.glEnum);
      if (webglParameter != null) {
        _values.add(webglParameter);
      }
    }
  }

  void logValues() {
    Debug.log('Webgl Parameters',(){
      values.forEach((p) {
        print('${p.toString()}');
      });
    });
  }

  WebglParameter getParameter(int glEnum) {

    WebglConstant constant = Context.webglConstants.values
        .firstWhere((c) => c.glEnum == glEnum);

    if(!constant.isParameter) return null;

    int result = gl.getParameter(constant.glEnum) as int;
    String glEnumStringValue;

    if (result is int && result > 1) {
      List<WebglConstant> constants = Context.webglConstants.values
          .where((c) => c.glEnum == result).toList();
      if (constants.length == 1) { // >1 pour ne pas avoir de confusion dans les enums possibles
        glEnumStringValue = Context.webglConstants.values
            .firstWhere((c) => c.glEnum == constants[0].glEnum)
            .glName;
      }else if(constants.length > 1){
        throw new Exception('getParameter constants > 1 for parameter ${constant.glName}');
      }
    }

    WebglParameter param = new WebglParameter()
      ..glName = constant.glName
      ..glValue = glEnumStringValue != null ? glEnumStringValue : result
//      ..glType = result.runtimeType.toString()
      ..glEnum = constant.glEnum;
    return param;
  }

  void testGetParameter() {
    Debug.log('Test Get Parameters',(){
      print('TEXTURE0 : 0x84C0 = ${0x84C0}'); // == 33984
      print('ACTIVE_TEXTURE : 0x84E0 = ${0x84E0}'); // == 34016
      print(Context.webglParameters.getParameter(WebGL.ACTIVE_TEXTURE));
      //OK > ACTIVE_TEXTURE (34016) = TEXTURE0 : glEnum
      print('##################################################################');

      Object result = gl.getParameter(WebGL.BLEND_SRC_RGB);
      print(result);
      //NO > comment différencier une valeur int d'une valeur glEnum ?
      print(Context.webglParameters.getParameter(WebGL.BLEND_SRC_RGB));
      print(0x0001);
    });
  }
}