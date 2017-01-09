import 'package:webgl/src/webgl_objects/datas/webgl_dictionnary.dart';

class ContextAttributs{

  final WebGLDictionary _values;

  ContextAttributs(this._values);

  bool get alpha => values['alpha'];
  bool get antialias => values['alpha'];
  bool get depth => values['alpha'];
  bool get failIfMajorPerformanceCaveat => values['alpha'];
  bool get premultipliedAlpha => values['alpha'];
  bool get preserveDrawingBuffer => values['alpha'];
  bool get stencil => values['alpha'];

  Map get values {
    return _values.toMap;
  }

  void logValues(){
    print('##################################################################');
    print('### Webgl Context Attributs');
    print('##################################################################');
    values.forEach((key,v){
      print('$key : $v');
    });
    print('##################################################################');
  }
}

