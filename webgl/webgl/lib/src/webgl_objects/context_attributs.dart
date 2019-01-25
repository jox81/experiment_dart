class ContextAttributs{

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