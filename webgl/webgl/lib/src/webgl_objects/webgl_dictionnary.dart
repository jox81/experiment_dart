class WebGLDictionary extends _ReturnedDictionary {
  WebGLDictionary(Map value):super(value);
}

// Creates a Dart class to allow members of the Map to be fetched (as if getters exist).
// TODO(terry): Need to use package:js but that's a problem in dart:html. Talk to
//              Jacob about how to do this properly using dart:js.
class _ReturnedDictionary {
  Map _values;

  @override
  void noSuchMethod(Invocation invocation) {
    // Todo (jpu) : Mirrors
//    var key = MirrorSystem.getName(invocation.memberName);
//    if (invocation.isGetter) {
//      return _values[key];
//    } else if (invocation.isSetter && key.endsWith('=')) {
//      key = key.substring(0, key.length - 1);
//      _values[key] = invocation.positionalArguments[0];
//    }
  }

  Map get toMap => _values;

  _ReturnedDictionary(Map value) : _values = value != null ? value : new Map<dynamic, dynamic>();
}