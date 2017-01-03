import 'dart:web_gl' as WebGL;

import 'package:webgl/src/context.dart';

class FrameBufferStatus{
  final index;
  const FrameBufferStatus(this.index);

  static const FrameBufferStatus FRAMEBUFFER_COMPLETE = const FrameBufferStatus(WebGL.RenderingContext.FRAMEBUFFER_COMPLETE);
  static const FrameBufferStatus FRAMEBUFFER_INCOMPLETE_ATTACHMENT = const FrameBufferStatus(WebGL.RenderingContext.FRAMEBUFFER_INCOMPLETE_ATTACHMENT);
  static const FrameBufferStatus FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT = const FrameBufferStatus(WebGL.RenderingContext.FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT);
  static const FrameBufferStatus FRAMEBUFFER_INCOMPLETE_DIMENSIONS = const FrameBufferStatus(WebGL.RenderingContext.FRAMEBUFFER_INCOMPLETE_DIMENSIONS);
  static const FrameBufferStatus FRAMEBUFFER_UNSUPPORTED = const FrameBufferStatus(WebGL.RenderingContext.FRAMEBUFFER_UNSUPPORTED);
}

class FrameBufferTarget{
  final index;
  const FrameBufferTarget(this.index);

  static const FrameBufferTarget FRAMEBUFFER = const FrameBufferTarget(WebGL.RenderingContext.FRAMEBUFFER);
}

class WebGLFrameBuffer{

  WebGL.Framebuffer webGLFrameBuffer;

  WebGLFrameBuffer(){
    webGLFrameBuffer = gl.ctx.createFramebuffer();
  }

  FrameBufferStatus checkStatus(){
    return new FrameBufferStatus(gl.ctx.checkFramebufferStatus(FrameBufferTarget.FRAMEBUFFER.index));
  }

  void bind(){
    gl.ctx.bindFramebuffer(FrameBufferTarget.FRAMEBUFFER.index, webGLFrameBuffer);
  }
  void unBind(){
    gl.ctx.bindFramebuffer(FrameBufferTarget.FRAMEBUFFER.index, null);
  }

}
