import 'dart:async';
import 'dart:html';
import 'package:webgl/src/webgl_objects/context.dart';
import 'package:webgl/asset_library.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_renderbuffer.dart';

Future main() async {
  await AssetLibrary.shaders.loadAll();

  WebglTest webglTest =
      new WebglTest(querySelector('#glCanvas') as CanvasElement);

  webglTest.setup();
}

class WebglTest {

  WebglTest(CanvasElement canvas) {
    new Context(canvas, enableExtensions: true, logInfos: false);
  }

  void setup() {
    WebGLRenderBuffer renderbuffer = new WebGLRenderBuffer();
    renderbuffer.logRenderBufferInfos();
    renderbuffer.bind();
    renderbuffer.logRenderBufferInfos();
    renderbuffer.renderbufferStorage(RenderBufferTarget.RENDERBUFFER, RenderBufferInternalFormatType.DEPTH_COMPONENT16, 256, 256);
    renderbuffer.logRenderBufferInfos();
  }

}
