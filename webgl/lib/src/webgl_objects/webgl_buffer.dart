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

  WebGLBuffer():this.webGLBuffer = gl.ctx.createBuffer();
  WebGLBuffer.fromWebGL(this.webGLBuffer);

  WebGLBuffer.fromGltf(glTF.Buffer gltfBuffer);

  @override
  void delete() => gl.ctx.deleteBuffer(webGLBuffer);

  void bind(BufferType bufferType) {
    gl.ctx.bindBuffer(bufferType.index, webGLBuffer);
  }

  void unbind(BufferType bufferType) {
    gl.ctx.bindBuffer(bufferType.index, null);
  }

  ////

  bool get isBuffer => gl.ctx.isBuffer(webGLBuffer);


  // >>> Parameteres


  dynamic getParameter(BufferType target, BufferParameters parameter){
    dynamic result =  gl.ctx.getBufferParameter(target.index,parameter.index);
    return result;
  }

  // >>> single getParameter

  // >> ARRAY_BUFFER
  // > BUFFER_SIZE
  int get arrayBufferSize => gl.ctx.getBufferParameter(BufferType.ARRAY_BUFFER.index,BufferParameters.BUFFER_SIZE.index) as int;
  // > BUFFER_USAGE
  BufferUsageType get arrayBufferUsage => BufferUsageType.getByIndex(gl.ctx.getBufferParameter(BufferType.ARRAY_BUFFER.index,BufferParameters.BUFFER_USAGE.index)as int)as BufferUsageType;

  // >> ELEMENT_ARRAY_BUFFER
  // > BUFFER_SIZE
  int get elementArrayBufferSize => gl.ctx.getBufferParameter(BufferType.ELEMENT_ARRAY_BUFFER.index,BufferParameters.BUFFER_SIZE.index)as int;
  // > BUFFER_USAGE
  BufferUsageType get elementArrayBufferUsage => BufferUsageType.getByIndex(gl.ctx.getBufferParameter(BufferType.ELEMENT_ARRAY_BUFFER.index,BufferParameters.BUFFER_USAGE.index)as int)as BufferUsageType;


  void logBufferInfos() {
    Debug.log("Buffer Infos", () {
      print('isBuffer : ${isBuffer}');

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
