import 'dart:html';
import 'dart:typed_data' as WebGlTypedData ;
import 'dart:web_gl' as WebGl;

import 'package:webgl/src/context.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';

class UsageType{
  final index;
  const UsageType(this.index);

  static const UsageType STATIC_DRAW = const UsageType(WebGl.RenderingContext.STATIC_DRAW);
  static const UsageType DYNAMIC_DRAW = const UsageType(WebGl.RenderingContext.DYNAMIC_DRAW);
  static const UsageType STREAM_DRAW = const UsageType(WebGl.RenderingContext.STREAM_DRAW);
}

class WebGLContext{

 static void bindBuffer(BufferType bufferType, WebGLBuffer webglBuffer){
   gl.bindBuffer(bufferType.index, webglBuffer.webGLBuffer);
 }

 static void bufferData(BufferType bufferType, WebGlTypedData.TypedData typedData,UsageType usageType){
   gl.bufferData(bufferType.index, typedData, usageType.index);
 }

 static void bufferDataWithSize(BufferType bufferType, int size,WebGLBuffer webglBuffer, UsageType usageType){
   assert(size != null);
   gl.bufferData(bufferType.index, size, usageType.index);
 }

 static void bufferDataWithByteBuffer(BufferType bufferType, WebGlTypedData.ByteBuffer byteBuffer,UsageType usageType){
   gl.bufferData(bufferType.index, byteBuffer, usageType.index);
 }

}
