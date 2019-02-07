import 'dart:html';
import 'dart:web_gl';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_rendering_context.dart';

CanvasElement canvas;
WebGLRenderingContext gl;

void main() {
  ParagraphElement title = new ParagraphElement();
  title.text = 'Click on canvas to check color at mouse click position';
  document.body.append(title);

  canvas = new CanvasElement();
  canvas.id = 'webgl_canvas';
  canvas.width = 600;
  canvas.height = 400;
  canvas.style.border = '2px solid black';
  document.body.append(canvas);
  log("canvas '${canvas.id}' created: width=${canvas.width} height=${canvas.height}");

  gl = new WebGLRenderingContext.create(canvas, preserveDrawingBuffer: true);
  if (gl == null) {
    log("WebGL: initialization failure");
    return;
  }
  log("WebGL: initialized");

  gl.clearColor = new Vector4(0.5, 0.5, 0.5, 1.0);        // clear color
  gl.enable(EnableCapabilityType.DEPTH_TEST);             // enable depth testing
  gl.depthFunc = ComparisonFunction.LESS;                 // gl.LESS is default depth test
  gl.setDepthRange(0.0, 1.0);                             // default
  gl.viewport = new Rectangle(0, 0, canvas.width, canvas.height);

  gl.clear([ClearBufferMask.COLOR_BUFFER_BIT , ClearBufferMask.DEPTH_BUFFER_BIT]);

  canvas.onClick.listen((MouseEvent e) {
    num offsetX = e.offset.x;
    num offsetY = e.offset.y;

    displayInfos(offsetX, offsetY);
  });
}

void displayInfos(num offsetX, num offsetY) {
  log("mouse offset: x=${offsetX} y=${offsetY}");

  int x = offsetX as int;
  int y = canvas.height - offsetY as int;

  Uint8List color = new Uint8List(4);
  gl.readPixels(x, y, 1, 1, WebGL.RGBA, WebGL.UNSIGNED_BYTE, color);

  log("readPixels: x=$x y=$y color=$color");
}

void log(String msg) {
  print(msg);
  DivElement m = new DivElement();
  m.text = msg;
  document.body.append(m);
}