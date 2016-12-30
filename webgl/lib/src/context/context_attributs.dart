import 'dart:mirrors';
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
    _ReturnedDictionary contextParameters = gl.getContextAttributes();
    return contextParameters.toMap;
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


// Creates a Dart class to allow members of the Map to be fetched (as if getters exist).
// TODO(terry): Need to use package:js but that's a problem in dart:html. Talk to
//              Jacob about how to do this properly using dart:js.
class _ReturnedDictionary {
  Map _values;

  noSuchMethod(Invocation invocation) {
    var key = MirrorSystem.getName(invocation.memberName);
    if (invocation.isGetter) {
      return _values[key];
    } else if (invocation.isSetter && key.endsWith('=')) {
      key = key.substring(0, key.length-1);
      _values[key] = invocation.positionalArguments[0];
    }
  }

  Map get toMap => _values;

  _ReturnedDictionary(Map value): _values = value != null ? value : {};
}
