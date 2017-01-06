import 'package:webgl/src/context.dart';

class ContextAttributs{

  static ContextAttributs _instance;
  ContextAttributs._init();
  static ContextAttributs instance(){
    if(_instance == null){
      _instance = new ContextAttributs._init();
    }
    return _instance;
  }

  bool get alpha => values['alpha'];
  bool get antialias => values['alpha'];
  bool get depth => values['alpha'];
  bool get failIfMajorPerformanceCaveat => values['alpha'];
  bool get premultipliedAlpha => values['alpha'];
  bool get preserveDrawingBuffer => values['alpha'];
  bool get stencil => values['alpha'];

  Map get values {
    return gl.contextAttributes;
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

