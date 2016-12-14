import 'dart:html';
import 'dart:web_gl';
import 'dart:typed_data';
import 'dart:js' as js;

void log(String msg) {
  print(msg);
  DivElement m = new DivElement();
  m.text = msg;
  document.body.append(m);
}

void main() {
  ParagraphElement title = new ParagraphElement();
  title.text = 'Click on canvas';
  document.body.append(title);

  CanvasElement canvas = new CanvasElement();
  canvas.id = 'webgl_canvas';
  canvas.width = 600;
  canvas.height = 400;
  canvas.style.border = '2px solid black';
  document.body.append(canvas);
  log("canvas '${canvas.id}' created: width=${canvas.width} height=${canvas.height}");

  RenderingContext gl = canvas.getContext3d(preserveDrawingBuffer: true);
  if (gl == null) {
    log("WebGL: initialization failure");
    return;
  }
  log("WebGL: initialized");

  gl.clearColor(0.5, 0.5, 0.5, 1.0);       // clear color
  gl.enable(RenderingContext.DEPTH_TEST);  // enable depth testing
  gl.depthFunc(RenderingContext.LESS);     // gl.LESS is default depth test
  gl.depthRange(0.0, 1.0);                 // default
  gl.viewport(0, 0, canvas.width, canvas.height);

  gl.clear(RenderingContext.COLOR_BUFFER_BIT | RenderingContext.DEPTH_BUFFER_BIT);

  canvas.onClick.listen((MouseEvent e) {
    log("mouse offset: x=${e.offset.x} y=${e.offset.y}");

    int x = e.offset.x;
    int y = canvas.height - e.offset.y;

    Uint8List color = new Uint8List(4);
    gl.bindFramebuffer(RenderingContext.FRAMEBUFFER, null); // default framebuffer
//    gl.readPixels(x, y, 1, 1, RenderingContext.RGBA, RenderingContext.UNSIGNED_BYTE, color);
    readPixelsDartium(gl,x, y);

    log("readPixels: x=$x y=$y color=$color");
  });


}

var _jsReadPixels;
get jsReadPixels {
  if (_jsReadPixels != null) return _jsReadPixels;
  js.context['eval'].apply(['function readPixelsDartium_(gl, x, y) { '
      '  var pixels = new Uint8Array(4); '
      '  gl.readPixels(x, y, 1, 1, gl.RGBA, gl.UNSIGNED_BYTE, pixels); '
      '  return pixels; '
      '}'
  ]);
  _jsReadPixels = js.context['readPixelsDartium_'];
  return _jsReadPixels;
}

readPixelsDartium(RenderingContext gl, x, y) {
  // If we're in dart2js, just call the method.
  if (1.0 is int) {
    Uint8List color = new Uint8List(4);
    gl.readPixels(
        x,
        y,
        1,
        1,
        RenderingContext.RGBA,
        RenderingContext.UNSIGNED_BYTE,
        color);
    return color;
  }
  var jsGl = new js.JsObject.fromBrowserObject(gl);
  return jsReadPixels.apply([jsGl, x, y]);
}

