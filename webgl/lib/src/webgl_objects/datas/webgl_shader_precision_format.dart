import 'dart:web_gl' as WebGL;
//@MirrorsUsed(
//    targets: const [
//      WebGLShaderPrecisionFormat,
//    ],
//    override: '*')
//import 'dart:mirrors';

///The WebGLShaderPrecisionFormat represents the information returned from the getShaderPrecisionFormat call.
class WebGLShaderPrecisionFormat {
  final WebGL.ShaderPrecisionFormat webGLShaderPrecisionFormat;

  WebGLShaderPrecisionFormat.fromWebGL(this.webGLShaderPrecisionFormat);

  ///The number of bits of precision that can be represented. For integer formats this value is always 0.
  int get precision => webGLShaderPrecisionFormat.precision;

  ///The base 2 log of the absolute value of the minimum value that can be represented.
  int get rangeMin => webGLShaderPrecisionFormat.rangeMin;

  ///The base 2 log of the absolute value of the maximum value that can be represented.
  int get rangeMax => webGLShaderPrecisionFormat.rangeMax;

  @override
  String toString(){
    return 'precision : ${precision}, rangeMin : ${rangeMin}, rangeMax : $rangeMax';
  }
}