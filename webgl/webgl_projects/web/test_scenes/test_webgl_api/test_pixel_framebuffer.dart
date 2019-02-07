import 'dart:html';
import 'dart:typed_data';
import 'dart:web_gl';
import 'package:webgl/src/webgl_objects/datas/webgl_attribut_location.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_rendering_context.dart';
import 'package:webgl/src/webgl_objects/webgl_framebuffer.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/context.dart';
import 'package:webgl/src/webgl_objects/webgl_renderbuffer.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_uniform_location.dart';

Context context;

final String vertexShaderSource = """
attribute vec3 a_Position;
void main(void) {
  gl_Position = vec4(a_Position, 1.0);
}
""";

final String fragmentShaderSource = """
#ifdef GL_FRAGMENT_PRECISION_HIGH
   precision highp float;
#else
   precision mediump float;
#endif
uniform vec4 u_Color;
void main(void) {
  gl_FragColor = u_Color;
}
""";

Float32List vertCoord = new Float32List.fromList(
    [0.5, 0.0, -1.0,
    -0.5, 0.0, -1.0,
    -0.5, -0.5, -1.0,
    0.5, -0.5, -1.0]);

Uint16List indices = new Uint16List.fromList(
    [0, 1, 2,
    0, 2, 3]);

void main() {
  ParagraphElement title = new ParagraphElement();
  title.text = 'Click on canvas to check color at mouse click position';
  document.body.append(title);

  CanvasElement canvas = new CanvasElement();
  canvas.id = 'webgl_canvas';
  canvas.width = 600;
  canvas.height = 400;
  canvas.style.border = '2px solid black';
  document.body.append(canvas);
  log("canvas '${canvas.id}' created: width=${canvas.width} height=${canvas.height}");

  context = new Context(canvas);

  if (gl == null) {
    log("WebGL: initialization failure");
    return;
  }
  log("WebGL: initialized");
  
  WebGLBuffer vertexPositionBuffer = new WebGLBuffer();
  final int vertexPositionBufferItemSize = 3; // coord x,y,z
  gl.bindBuffer(BufferType.ARRAY_BUFFER, vertexPositionBuffer.webGLBuffer);
  gl.bufferData(BufferType.ARRAY_BUFFER, vertCoord, BufferUsageType.STATIC_DRAW);

  WebGLBuffer vertexIndexBuffer = new WebGLBuffer();
  vertexIndexBuffer.bindBuffer(BufferType.ELEMENT_ARRAY_BUFFER);
  gl.bufferData(BufferType.ELEMENT_ARRAY_BUFFER, indices, BufferUsageType.STATIC_DRAW);
    
  WebGLShader vertShader = new WebGLShader(ShaderType.VERTEX_SHADER)
      ..source = vertexShaderSource
      ..compile();

  WebGLShader fragShader = new WebGLShader(ShaderType.FRAGMENT_SHADER)
    ..source = fragmentShaderSource
    ..compile();
  
  WebGLProgram program = new WebGLProgram();
  program.attachShader(vertShader);
  program.attachShader(fragShader);
  program.link();
  WebGLAttributLocation a_Position = program.getAttribLocation("a_Position");
  WebGLUniformLocation u_Color = program.getUniformLocation("u_Color");

  program.use();
  a_Position.enabled = true;
  
  gl.clearColor(0.5, 0.5, 0.5, 1.0);       // clear color
  gl.enable(EnableCapabilityType.DEPTH_TEST);  // enable depth testing
  gl.depthFunc(ComparisonFunction.LESS);     // gl.LESS is default depth test
  gl.depthRange(0.0, 1.0);                 // default
  gl.viewport(0, 0, canvas.width, canvas.height);

  WebGLFrameBuffer offscreen = createRenderbuffer(GL, canvas.width, canvas.height);
  
  render(GL, null, u_Color, a_Position, vertexPositionBuffer, vertexPositionBufferItemSize, vertexIndexBuffer, indices.length);      // render on canvas framebuffer
  render(GL, offscreen, u_Color, a_Position, vertexPositionBuffer, vertexPositionBufferItemSize, vertexIndexBuffer, indices.length); // render on offscreen framebuffer

  canvas.onClick.listen((MouseEvent e) {
    num offsetX = e.offset.x;
    num offsetY = e.offset.y;

    displayInfos(offsetX, offsetY);
  });
}

void displayInfos(num offsetX, num offsetY) {
  log("mouse offset: x=${offsetX} y=${offsetY}");

  int x = offsetX as int;
  int y = context.canvas.height - offsetY as int;

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

WebGLFrameBuffer createRenderbuffer(WebGLRenderingContext gl, int width, int height) {
  // 1. Init Picking Texture
  WebGLTexture texture = new WebGLTexture.texture2d();
  gl.activeTexture.texture2d.bind(texture);
  try {
    gl.activeTexture.texture2d.attachmentTexture2d.texImage2DWithWidthAndHeight(0, TextureInternalFormat.RGBA, width, height, 0, TextureInternalFormat.RGBA, TexelDataType.UNSIGNED_BYTE, null);
  }
  catch (e) {
    // https://code.google.com/p/dart/issues/detail?id=11498
    log("gl.texImage2D: exception: $e");
  }

  // 2. Init Render Buffer
  WebGLRenderBuffer renderbuffer = new WebGLRenderBuffer();
  renderbuffer.bind();
  renderbuffer.renderbufferStorage(RenderBufferTarget.RENDERBUFFER, RenderBufferInternalFormatType.DEPTH_COMPONENT16, width, height);

  // 3. Init Frame Buffer
  WebGLFrameBuffer framebuffer = new WebGLFrameBuffer();
  gl.activeFrameBuffer.bind(framebuffer);
  gl.activeFrameBuffer.framebufferTexture2D(FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.COLOR_ATTACHMENT0, TextureAttachmentTarget.TEXTURE_2D, texture, 0);
  gl.activeFrameBuffer.framebufferRenderbuffer(FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.DEPTH_ATTACHMENT, RenderBufferTarget.RENDERBUFFER, renderbuffer);

  // 4. Clean up
  gl.activeTexture.texture2d.unBind();
  renderbuffer.unBind();
  gl.activeFrameBuffer.unBind();

  return framebuffer;
}

void render(WebGLRenderingContext gl, WebGLFrameBuffer framebuffer, WebGLUniformLocation u_Color, WebGLAttributLocation a_Position, WebGLBuffer vertexPositionBuffer, int vertexPositionBufferItemSize, WebGLBuffer vertexIndexBuffer, int indicesLength) {
  gl.activeFrameBuffer.bind(framebuffer);
  gl.clear(ClearBufferMask.COLOR_BUFFER_BIT | ClearBufferMask.DEPTH_BUFFER_BIT);

  Float32List red = new Float32List.fromList([1.0, 0.0, 0.0, 1.0]);

  u_Color.uniform4fv(red);

  vertexPositionBuffer.bindBuffer(BufferType.ARRAY_BUFFER);
  a_Position.vertexAttribPointer(vertexPositionBufferItemSize, ShaderVariableType.FLOAT, false, 0, 0);

  vertexIndexBuffer.bindBuffer(BufferType.ELEMENT_ARRAY_BUFFER);
  gl.drawElements(DrawMode.TRIANGLES, indices.length, BufferElementType.UNSIGNED_SHORT, 0);
}

void readColor(String label, WebGLRenderingContext gl, int x, int y, WebGLFrameBuffer framebuffer) {
  Uint8List color = new Uint8List(4);
  gl.activeFrameBuffer.bind(framebuffer);
  gl.readPixels(x, y, 1, 1, WebGL.RGBA, WebGL.UNSIGNED_BYTE, color);
//  readPixelsDartium(gl, x, y);
  log("$label: readPixels: x=$x y=$y color=$color");
}
