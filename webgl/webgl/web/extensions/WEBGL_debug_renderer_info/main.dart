import 'dart:async';
import 'dart:html';
import 'dart:web_gl' as webgl;
import 'package:webgl/src/webgl_objects/context.dart';


Future main() async {
  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;

  new Context(canvas);

  List<String> extensions = gl.getSupportedExtensions();

  extensions.forEach((e)=>print(e));

  test_WEBGL_debug_renderer_info(extensions);
}

void test_WEBGL_debug_renderer_info(List<String> extensions) {
  if(extensions.contains('WEBGL_debug_renderer_info')) {
    print('### : WEBGL_debug_renderer_info');
    var debugInfo = gl.getExtension(
        'WEBGL_debug_renderer_info');
    var vendor = gl.getParameter(webgl.DebugRendererInfo.UNMASKED_VENDOR_WEBGL);
    var renderer = gl.getParameter(
        webgl.DebugRendererInfo.UNMASKED_RENDERER_WEBGL);

    print('vendor : UNMASKED_VENDOR_WEBGL $vendor');
    print('renderer : UNMASKED_RENDERER_WEBGL $renderer');
  }
}