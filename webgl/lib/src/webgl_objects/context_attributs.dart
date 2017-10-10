import 'dart:mirrors';
import 'package:webgl/src/introspection.dart';

class ContextAttributs extends IEditElement {

  final dynamic _values;

  ContextAttributs(this._values);

  bool get alpha => values['alpha'] as bool;
  bool get antialias => values['alpha'] as bool;
  bool get depth => values['alpha'] as bool;
  bool get failIfMajorPerformanceCaveat => values['alpha'] as bool;
  bool get premultipliedAlpha => values['alpha'] as bool;
  bool get preserveDrawingBuffer => values['alpha'] as bool;
  bool get stencil => values['alpha'] as bool;

  Map get values {
    return _values.toMap as Map;
  }

  void logValues(){
    print('##################################################################');
    print('### Webgl Context Attributs');
    print('##################################################################');
    values.forEach((dynamic key,dynamic v){
      print('$key : $v');
    });
    print('##################################################################');
  }
}

class WebGLDictionary extends _ReturnedDictionary {
  WebGLDictionary(Map value):super(value);
}

// Creates a Dart class to allow members of the Map to be fetched (as if getters exist).
// TODO(terry): Need to use package:js but that's a problem in dart:html. Talk to
//              Jacob about how to do this properly using dart:js.
class _ReturnedDictionary {
  Map _values;

  void noSuchMethod(Invocation invocation) {
    var key = MirrorSystem.getName(invocation.memberName);
    if (invocation.isGetter) {
      return _values[key];
    } else if (invocation.isSetter && key.endsWith('=')) {
      key = key.substring(0, key.length - 1);
      _values[key] = invocation.positionalArguments[0];
    }
  }

  Map get toMap => _values;

  _ReturnedDictionary(Map value) : _values = value != null ? value : new Map<dynamic, dynamic>();
}

