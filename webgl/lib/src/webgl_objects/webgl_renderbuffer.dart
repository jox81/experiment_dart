import 'dart:web_gl' as WebGL;
import 'package:webgl/src/context.dart';
import 'package:webgl/src/debug/utils_debug.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_object.dart';
//@MirrorsUsed(
//    targets: const [
//      WebGLRenderBuffer,
//    ],
//    override: '*')
//import 'dart:mirrors';

class WebGLRenderBuffer extends WebGLObject{

  final WebGL.Renderbuffer webGLRenderBuffer;

  WebGLRenderBuffer():this.webGLRenderBuffer = gl.createRenderbuffer();
  WebGLRenderBuffer.fromWebGL(this.webGLRenderBuffer);

  @override
  void delete() => gl.deleteRenderbuffer(webGLRenderBuffer);

  void bind() {
    gl.bindRenderbuffer(RenderBufferTarget.RENDERBUFFER, webGLRenderBuffer);
  }

  void unBind() {
    gl.bindRenderbuffer(RenderBufferTarget.RENDERBUFFER, null);
  }


  ////

  bool get isRenderbuffer => gl.isRenderbuffer(webGLRenderBuffer);


  /// RenderBufferTarget renderbuffer
  /// RenderBufferInternalFormatType internalFormat
  void renderbufferStorage(int renderbuffer, int internalFormat, int width, int heigth) {
    gl.renderbufferStorage(renderbuffer, internalFormat, width, heigth);
  }

  // >>> Parameteres

  /// RenderBufferParameters parameter
  dynamic getRenderbufferParameter(int parameter){
    return gl.getRenderbufferParameter(RenderBufferTarget.RENDERBUFFER,parameter);
  }

  // >>> single getParameter

  // > RENDERBUFFER_WIDTH
  int get renderBufferWidth => gl.getRenderbufferParameter(RenderBufferTarget.RENDERBUFFER,RenderBufferParameters.RENDERBUFFER_WIDTH) as int;
  // > RENDERBUFFER_HEIGHT
  int get renderBufferHeight => gl.getRenderbufferParameter(RenderBufferTarget.RENDERBUFFER,RenderBufferParameters.RENDERBUFFER_HEIGHT) as int;
  // > RENDERBUFFER_RED_SIZE
  int get renderBufferRedSize => gl.getRenderbufferParameter(RenderBufferTarget.RENDERBUFFER,RenderBufferParameters.RENDERBUFFER_RED_SIZE) as int;
  // > RENDERBUFFER_GREEN_SIZE
  int get renderBufferGreenSize => gl.getRenderbufferParameter(RenderBufferTarget.RENDERBUFFER,RenderBufferParameters.RENDERBUFFER_GREEN_SIZE) as int;
  // > RENDERBUFFER_BLUE_SIZE
  int get renderBufferBlueSize => gl.getRenderbufferParameter(RenderBufferTarget.RENDERBUFFER,RenderBufferParameters.RENDERBUFFER_BLUE_SIZE) as int;
  // > RENDERBUFFER_ALPHA_SIZE
  int get renderBufferAlphaSize => gl.getRenderbufferParameter(RenderBufferTarget.RENDERBUFFER,RenderBufferParameters.RENDERBUFFER_ALPHA_SIZE) as int;
  // > RENDERBUFFER_DEPTH_SIZE
  int get renderBufferDepthSize => gl.getRenderbufferParameter(RenderBufferTarget.RENDERBUFFER,RenderBufferParameters.RENDERBUFFER_DEPTH_SIZE) as int;
  // > RENDERBUFFER_STENCIL_SIZE
  int get renderBufferStencilSize => gl.getRenderbufferParameter(RenderBufferTarget.RENDERBUFFER,RenderBufferParameters.RENDERBUFFER_STENCIL_SIZE) as int;
  // > RENDERBUFFER_INTERNAL_FORMAT
  /// RenderBufferInternalFormatType get renderBufferInterrnalFormat
  int get renderBufferInterrnalFormat => gl.getRenderbufferParameter(RenderBufferTarget.RENDERBUFFER,RenderBufferParameters.RENDERBUFFER_INTERNAL_FORMAT) as int;

  void logRenderBufferInfos() {
    Debug.log("RenderBuffer Infos", () {
      print('isRenderbuffer : ${isRenderbuffer}');
      print('renderBufferWidth : ${renderBufferWidth}');
      print('renderBufferHeight : ${renderBufferHeight}');
      print('renderBufferRedSize : ${renderBufferRedSize}');
      print('renderBufferGreenSize : ${renderBufferGreenSize}');
      print('renderBufferBlueSize : ${renderBufferBlueSize}');
      print('renderBufferAlphaSize : ${renderBufferAlphaSize}');
      print('renderBufferDepthSize : ${renderBufferDepthSize}');
      print('renderBufferStencilSize : ${renderBufferStencilSize}');
      print('renderBufferInterrnalFormat : ${renderBufferInterrnalFormat}');
    });
  }
}
