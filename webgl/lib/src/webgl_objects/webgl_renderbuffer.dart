import 'dart:web_gl' as WebGL;

import 'package:webgl/src/context.dart';

class WebGLRenderBuffer{

  WebGL.Renderbuffer webGLRenderBuffer;

  WebGLRenderBuffer(){
    webGLRenderBuffer = gl.ctx.createRenderbuffer();
  }

}
