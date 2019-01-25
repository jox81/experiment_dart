import 'dart:web_gl' as WebGL;
import 'package:webgl/src/context.dart';
import 'package:webgl/src/utils/utils_debug.dart';
import 'package:webgl/src/webgl_objects/webgl_object.dart';

class WebGLFrameBuffer extends WebGLObject{

  final WebGL.Framebuffer webGLFrameBuffer;

  WebGLFrameBuffer():this.webGLFrameBuffer = gl.createFramebuffer();
  WebGLFrameBuffer.fromWebGL(this.webGLFrameBuffer);

  @override
  void delete() => gl.deleteFramebuffer(webGLFrameBuffer);

  bool get isFramebuffer => gl.isFramebuffer(webGLFrameBuffer);

  void logFrameBufferInfos() {
    Debug.log("FrameBuffer Infos", () {
      print('isFramebuffer : ${isFramebuffer}');
    });
  }

}
