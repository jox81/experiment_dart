import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
import 'package:webgl/src/webgl_objects/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_framebuffer.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';

Future main() async {
  await ShaderSource.loadShaders();

  WebglTest webglTest =
      new WebglTest(querySelector('#glCanvas'));

  webglTest.setup();
}

class WebglTest {

  WebglTest(CanvasElement canvas) {
    Context.init(canvas, enableExtensions: true, logInfos: false);
  }

  void setup() {

    WebGLFrameBuffer frameBuffer = new WebGLFrameBuffer();
    frameBuffer.logFrameBufferInfos();

    //Tant que le frameBuffer n'est pas bindé, il n'est pas vraiment initialisé
    frameBuffer.bind();
    frameBuffer.logFrameBufferInfos();

    //Il reste initialisé après être détaché
    frameBuffer.unBind();
    frameBuffer.logFrameBufferInfos();

  }

}
