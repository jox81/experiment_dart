import 'dart:html';
import 'dart:typed_data';
import 'dart:js' as js;

import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_attribut_location.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_rendering_context.dart';
import 'package:webgl/src/webgl_objects/webgl_framebuffer.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_renderbuffer.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_uniform_location.dart';

final String vertexShaderSource = """
attribute vec3 a_Position;
void main(void) {
  gl_Position = vec4(a_Position, 1.0);
}
""";

final String fragmentShaderSource = """
precision mediump float;
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

void log(String msg) {
  print(msg);
  DivElement m = new DivElement();
  m.text = msg;
  document.body.append(m); 
}

WebGLFrameBuffer createRenderbuffer(WebGLRenderingContext gl, int width, int height) {
  // 1. Init Picking Texture
  WebGLTexture texture = new WebGLTexture();
  gl.activeTexture.bind(TextureTarget.TEXTURE_2D, texture);
  try {
    gl.activeTexture.texImage2DWithWidthAndHeight(TextureAttachmentTarget.TEXTURE_2D, 0, TextureInternalFormatType.RGBA, width, height, 0, TextureInternalFormatType.RGBA, TexelDataType.UNSIGNED_BYTE, null);
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
  gl.activeTexture.unBind(TextureTarget.TEXTURE_2D);
  renderbuffer.unBind();
  gl.activeFrameBuffer.unBind();
  
  return framebuffer;
}

void render(WebGLRenderingContext gl, WebGLFrameBuffer framebuffer, WebGLUniformLocation u_Color, WebGLAttributLocation a_Position, WebGLBuffer vertexPositionBuffer, int vertexPositionBufferItemSize, WebGLBuffer vertexIndexBuffer, int indicesLength) {
  gl.activeFrameBuffer.bind(framebuffer);
  gl.clear([ClearBufferMask.COLOR_BUFFER_BIT, ClearBufferMask.DEPTH_BUFFER_BIT]);
  
  Float32List red = new Float32List.fromList([1.0, 0.0, 0.0, 1.0]);

  u_Color.uniform4fv(red);

  vertexPositionBuffer.bind(BufferType.ARRAY_BUFFER);
  a_Position.vertexAttribPointer(vertexPositionBufferItemSize, ShaderVariableType.FLOAT, false, 0, 0);

  vertexIndexBuffer.bind(BufferType.ELEMENT_ARRAY_BUFFER);
  gl.drawElements(DrawMode.TRIANGLES, indices.length, BufferElementType.UNSIGNED_SHORT, 0);
}

void readColor(String label, WebGLRenderingContext gl, int x, int y, WebGLFrameBuffer framebuffer) {
  Uint8List color = new Uint8List(4);
  gl.activeFrameBuffer.bind(framebuffer);
//  gl.readPixels(x, y, 1, 1, RenderingContext.RGBA, RenderingContext.UNSIGNED_BYTE, color);
  readPixelsDartium(gl, x, y);
  log("$label: readPixels: x=$x y=$y color=$color");     
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

  WebGLRenderingContext gl = new WebGLRenderingContext.create(canvas, preserveDrawingBuffer: true);
  if (gl == null) {
    log("WebGL: initialization failure");
    return;
  }
  log("WebGL: initialized");
  
  WebGLBuffer vertexPositionBuffer = new WebGLBuffer();
  final int vertexPositionBufferItemSize = 3; // coord x,y,z
  vertexPositionBuffer.bind(BufferType.ARRAY_BUFFER);
  gl.bufferData(BufferType.ARRAY_BUFFER, vertCoord, BufferUsageType.STATIC_DRAW);

  WebGLBuffer vertexIndexBuffer = new WebGLBuffer();
  vertexIndexBuffer.bind(BufferType.ELEMENT_ARRAY_BUFFER);
  gl.bufferData(BufferType.ELEMENT_ARRAY_BUFFER, indices, BufferUsageType.STATIC_DRAW);
    
  WebGLShader vertShader = new WebGLShader(ShaderType.VERTEX_SHADER)
      ..source = vertexShaderSource
      ..compile();

  WebGLShader fragShader = new WebGLShader(ShaderType.FRAGMENT_SHADER)
    ..source = fragmentShaderSource
    ..compile;
  
  WebGLProgram program = new WebGLProgram();
  program.attachShader(vertShader);
  program.attachShader(fragShader);
  program.link();
  WebGLAttributLocation a_Position = program.getAttribLocation("a_Position");
  WebGLUniformLocation u_Color = program.getUniformLocation("u_Color");

  program.use();
  a_Position.enabled = true;
  
  gl.clearColor = new Vector4(0.5, 0.5, 0.5, 1.0);       // clear color
  gl.enable(EnableCapabilityType.DEPTH_TEST);  // enable depth testing
  gl.depthFunc = ComparisonFunction.LESS;     // gl.LESS is default depth test
  gl.setDepthRange(0.0, 1.0);                 // default
  gl.viewport = new Rectangle(0, 0, canvas.width, canvas.height);

  WebGLFrameBuffer offscreen = createRenderbuffer(gl, canvas.width, canvas.height);
  
  render(gl, null, u_Color, a_Position, vertexPositionBuffer, vertexPositionBufferItemSize, vertexIndexBuffer, indices.length);      // render on canvas framebuffer
  render(gl, offscreen, u_Color, a_Position, vertexPositionBuffer, vertexPositionBufferItemSize, vertexIndexBuffer, indices.length); // render on offscreen framebuffer
  
  canvas.onClick.listen((MouseEvent e) {
    log("mouse offset: x=${e.offset.x} y=${e.offset.y}");
    
    int x = e.offset.x;
    int y = canvas.height - e.offset.y;
    
    readColor("screen", gl, x, y, null);         // read color from canvas framebuffer
    readColor("offscreen", gl, x, y, offscreen); // read color from offscreen framebuffer
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

readPixelsDartium(WebGLRenderingContext gl, x, y) {
  // If we're in dart2js, just call the method.
  if (1.0 is int) {
    Uint8List color = new Uint8List(4);
    gl.readPixels(
        x,
        y,
        1,
        1,
        ReadPixelDataFormat.RGBA,
        ReadPixelDataType.UNSIGNED_BYTE,
        color);
    return color;
  }
  var jsGl = new js.JsObject.fromBrowserObject(gl);
  return jsReadPixels.apply([jsGl, x, y]);
}
