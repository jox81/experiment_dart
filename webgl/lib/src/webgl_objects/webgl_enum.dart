abstract class WebGLEnum {

  final int _index;
  final String _name;

  WebGLEnum(this._index, this._name);

  int get index => _index;
  String get name => _name;

  @override
  String toString(){
    return '$_name : $_index';
  }

}

