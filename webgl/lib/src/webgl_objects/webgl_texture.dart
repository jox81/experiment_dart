import 'dart:web_gl' as WebGL;

import 'package:webgl/src/context.dart';

class WebGLTexture{

  WebGL.Texture webGLTexture;

  WebGLTexture(){
    webGLTexture = gl.ctx.createTexture();
  }

}
