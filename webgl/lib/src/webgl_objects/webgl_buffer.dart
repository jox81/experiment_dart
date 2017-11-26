import 'dart:web_gl' as WebGL;
import 'package:webgl/src/context.dart';
import 'package:webgl/src/utils/utils_debug.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_object.dart';
import 'package:gltf/gltf.dart' as glTF;
@MirrorsUsed(
    targets: const [
      WebGLBuffer,
    ],
    override: '*')
import 'dart:mirrors';

class WebGLBuffer extends WebGLObject{

  WebGL.Buffer webGLBuffer;

  dynamic data;

  WebGLBuffer():this.webGLBuffer = gl.createBuffer();
  WebGLBuffer.fromWebGL(this.webGLBuffer);

  WebGLBuffer.fromGltf(glTF.Buffer gltfBuffer){
    throw new Exception('not implemented');
  }

  @override
  void delete() => gl.deleteBuffer(webGLBuffer);

  /// BufferType bufferType
  void bindBuffer(int bufferType) {
    gl.bindBuffer(bufferType, webGLBuffer);
  }
  void unbindBuffer(int bufferType) {
    gl.bindBuffer(bufferType, null);
  }

  ////

  bool get isBuffer => gl.isBuffer(webGLBuffer);


  // >>> Parameteres

  /// BufferType target, BufferParameters parameter
  dynamic getParameter(int target, int parameter){
    dynamic result =  gl.getBufferParameter(target,parameter);
    return result;
  }

  // >>> single getParameter

  // >> ARRAY_BUFFER
  // > BUFFER_SIZE
  static int get arrayBufferSize => gl.getBufferParameter(BufferType.ARRAY_BUFFER,BufferParameters.BUFFER_SIZE) as int;
  // > BUFFER_USAGE
  /// BufferUsageType get arrayBufferUsage
  static int get arrayBufferUsage => gl.getBufferParameter(BufferType.ARRAY_BUFFER,BufferParameters.BUFFER_USAGE)as int;

  // >> ELEMENT_ARRAY_BUFFER
  // > BUFFER_SIZE
  static int get elementArrayBufferSize => gl.getBufferParameter(BufferType.ELEMENT_ARRAY_BUFFER,BufferParameters.BUFFER_SIZE)as int;
  // > BUFFER_USAGE
  /// BufferUsageType get elementArrayBufferUsage
  static int get elementArrayBufferUsage => gl.getBufferParameter(BufferType.ELEMENT_ARRAY_BUFFER,BufferParameters.BUFFER_USAGE)as int;

  void logBufferInfos() {
    Debug.log("Buffer Infos", () {
      print('isBuffer : ${isBuffer}');
      print('data : ${data}');

      print('..................................................................');
      print('GL Global State Buffer infos');
      print('..................................................................');
      print('###  ARRAY_BUFFER');
      print('arrayBufferSize : ${arrayBufferSize}');
      print('arrayBufferUsage : ${arrayBufferUsage}');

      print('..................................................................');
      print('###  ELEMENT_ARRAY_BUFFER');
      print('elementArrayBufferSize : ${elementArrayBufferSize}');
      print('elementArrayBufferUsage : ${elementArrayBufferUsage}');
    });
  }
}
