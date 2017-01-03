import 'dart:mirrors';

class WebGLDictionary {
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

  WebGLDictionary(Map value): _values = value != null ? value : {};
}
