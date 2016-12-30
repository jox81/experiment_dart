import 'dart:mirrors';
import 'dart:web_gl';

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
    }
    return _values;
  }

  void logValues() {
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