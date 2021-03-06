import 'dart:html';
import 'dart:web_gl' as WebGL;
import 'package:webgl/src/webgl_objects/webgl_rendering_context.dart';

WebGLRenderingContext _GL;
WebGLRenderingContext get GL => _GL;
WebGL.RenderingContext get gl => _GL?.gl;

// Todo (jpu) :
// call this WebglContext ?
class Context{
  final CanvasElement canvas;
  Context(this.canvas, {bool enableExtensions:false, bool initConstant : false, bool logInfos : false, bool preserveDrawingBuffer : true}){
    _GL = new WebGLRenderingContext.create(canvas, enableExtensions:enableExtensions, initConstant:initConstant, logInfos:logInfos, preserveDrawingBuffer:preserveDrawingBuffer);
  }

  void clear() {
    _GL = null;
  }
}