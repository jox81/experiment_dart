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