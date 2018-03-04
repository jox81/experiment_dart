import 'dart:async';
import 'dart:html';
import 'dart:math' as Math;
import 'dart:typed_data';
import 'dart:web_gl' as webgl;
import 'package:webgl/src/gltf/renderer/materials.dart';
import 'package:webgl/src/material/shader_source.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/textures/utils_textures.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum_wrapped.dart' as GLEnum;
import 'package:webgl/src/webgl_objects/webgl_framebuffer.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_renderbuffer.dart';
import 'package:webgl/src/webgl_objects/webgl_rendering_context.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
import 'package:vector_math/vector_math.dart';

webgl.RenderingContext gl;
CanvasElement canvas;

var clock = 0;
var then = getCurrentTime();

num getCurrentTime () => new DateTime.now().millisecond * 0.008;

Future main() async {

  canvas = querySelector('#glCanvas') as CanvasElement;

  WebGLRenderingContext renderingContext = new WebGLRenderingContext.create(canvas);
  gl = renderingContext.gl;
  Context.glWrapper = renderingContext;

  webgl.Program program = buildProgram();
  gl.useProgram(program);

  List<double> positions = [
    1.0, -1.0,
    1.0,  1.0,
    -1.0,  1.0,
    -1.0, -1.0,
  ];

  List<double> texcoords = [
    1.0, 0.0,
    0.0, 0.0,
    0.0, 1.0,
    1.0, 1.0,
  ];

  List<int> indices = [
    0, 1, 2,
    0, 2, 3,
  ];

  var positionLoc = gl.getAttribLocation(program, "a_position");
  var texcoordLoc = gl.getAttribLocation(program, "a_texcoord");
  var worldViewProjectionLoc = gl.getUniformLocation(program, "u_worldViewProjection");

  //> buffer position
  webgl.Buffer buffer = gl.createBuffer();
  gl.bindBuffer(webgl.RenderingContext.ARRAY_BUFFER, buffer);
  gl.bufferData(
      webgl.RenderingContext.ARRAY_BUFFER,
      new Float32List.fromList(positions),
      webgl.RenderingContext.STATIC_DRAW);
  gl.enableVertexAttribArray(positionLoc);
  gl.vertexAttribPointer(positionLoc, 2, webgl.RenderingContext.FLOAT, false, 0, 0);

  //> buffer texcoords
  buffer = gl.createBuffer();
  gl.bindBuffer(webgl.RenderingContext.ARRAY_BUFFER, buffer);
  gl.bufferData(
      webgl.RenderingContext.ARRAY_BUFFER,
      new Float32List.fromList(texcoords),
      webgl.RenderingContext.STATIC_DRAW);
  gl.enableVertexAttribArray(texcoordLoc);
  gl.vertexAttribPointer(texcoordLoc, 2, webgl.RenderingContext.FLOAT, false, 0, 0);

  //> buffer indices
  buffer = gl.createBuffer();
  gl.bindBuffer(webgl.RenderingContext.ELEMENT_ARRAY_BUFFER, buffer);
  gl.bufferData(
      webgl.RenderingContext.ELEMENT_ARRAY_BUFFER,
      new Uint16List.fromList(indices),
      webgl.RenderingContext.STATIC_DRAW);

  //> create texture with text
  webgl.Texture texture = createTextTexture(gl, "Hello World", 128, 64);

  gl.bindTexture(webgl.RenderingContext.TEXTURE_2D, texture);

  //> create a framebuffer and attach texture to it
  webgl.Framebuffer framebuffer = gl.createFramebuffer();
  gl.bindFramebuffer(webgl.RenderingContext.FRAMEBUFFER, framebuffer);
  gl.framebufferTexture2D(
      webgl.RenderingContext.FRAMEBUFFER, webgl.RenderingContext.COLOR_ATTACHMENT0,
      webgl.RenderingContext.TEXTURE_2D, texture, 0);
  var result = gl.checkFramebufferStatus(webgl.RenderingContext.FRAMEBUFFER);
  if (result != webgl.RenderingContext.FRAMEBUFFER_COMPLETE) {
    window.alert("unsupported framebuffer");
    return;
  }

  webgl.Texture newTexture = gl.createTexture();
  gl.bindTexture(webgl.RenderingContext.TEXTURE_2D, newTexture);
  gl.copyTexImage2D(webgl.RenderingContext.TEXTURE_2D, 0, webgl.RenderingContext.RGBA, 0, 0, 128, 64, 0);
  gl.generateMipmap(webgl.RenderingContext.TEXTURE_2D);

  gl.bindFramebuffer(webgl.RenderingContext.FRAMEBUFFER, null);

  render({num time}) {
    num now = getCurrentTime();
    clock += (now - then).toInt();
    then = now;

    var scale = 4;

    gl.clear(webgl.RenderingContext.COLOR_BUFFER_BIT | webgl.RenderingContext.DEPTH_BUFFER_BIT);
    gl.enable(webgl.RenderingContext.DEPTH_TEST);

    var fieldOfView = Math.PI * 0.25;
    var aspect = canvas.clientWidth / canvas.clientHeight;
    Matrix4 projection = new Matrix4.identity();
    setPerspectiveMatrix(projection, fieldOfView, aspect, 0.0001, 500.0);

    var radius = 5;
    Vector3 eye = new Vector3(
      Math.sin(clock) * radius,
      1.0,
      Math.cos(clock) * radius);
    Vector3 target = new Vector3(0.0, 0.0, 0.0);
    Vector3 up = new Vector3(0.0, 1.0, 0.0);

    Matrix4 view = new Matrix4.identity();
    setViewMatrix(view,eye, target, up);

    var worldViewProjection = (projection * view) as Matrix4;
    gl.uniformMatrix4fv(
        worldViewProjectionLoc, false, worldViewProjection.storage);
    gl.drawElements(webgl.RenderingContext.TRIANGLES, 1 * 3 * 2, webgl.RenderingContext.UNSIGNED_SHORT, 0);
    print(gl.getError());

    window.requestAnimationFrame((num time) {
      render(time: time);
    });
  }

  render();
}

CanvasRenderingContext2D  ctxForMakingTextures;
webgl.Texture createTextTexture(webgl.RenderingContext gl, String str, int width, int height) {
  // create an offscreen canvas with a 2D canvas context
  if (ctxForMakingTextures == null) {
    CanvasElement canvas = new CanvasElement();
    ctxForMakingTextures = canvas.getContext("2d") as CanvasRenderingContext2D ;
  }
  CanvasRenderingContext2D  ctx = ctxForMakingTextures;

  // make it a desired size
  ctx.canvas.width = width;
  ctx.canvas.height = height;

  // fill it a certain color
  ctx.fillStyle = "rgb(255,0,0)";  // red
  ctx.fillRect(0, 0, ctx.canvas.width, ctx.canvas.height);

  // draw some text into it.
  ctx.fillStyle = "rgb(255,255,0)";  // yellow
  ctx.font = "20px sans-serif";
  ctx.fillText("Hello World", 5, 40);

  // Now make a texture from it
  webgl.Texture texture = gl.createTexture();
  gl.bindTexture(webgl.RenderingContext.TEXTURE_2D, texture);
  gl.texImage2D(webgl.RenderingContext.TEXTURE_2D, 0, webgl.RenderingContext.RGBA, webgl.RenderingContext.RGBA, webgl.RenderingContext.UNSIGNED_BYTE, ctx.canvas);

  // generate mipmaps or set filtering
  gl.generateMipmap(webgl.RenderingContext.TEXTURE_2D);

  gl.bindTexture(webgl.RenderingContext.TEXTURE_2D, null);

  return texture;
}

webgl.Program buildProgram() {

  String vertexShaderSource = '''
    attribute vec4 a_position;
    attribute vec2 a_texcoord;
    
    varying vec2 v_texcoord;
        
    uniform mat4 u_worldViewProjection;
    
    void main() {
       gl_Position = u_worldViewProjection * a_position;
       v_texcoord = a_texcoord;
    }
  ''';

  String fragmentShaderSource = '''
    precision mediump float;
        
    varying vec2 v_texcoord;
    
    uniform sampler2D u_texture;
    void main() {
       gl_FragColor = texture2D(u_texture, v_texcoord);
    }
  ''';

  webgl.Shader createShader(int type, String shaderSource) {
    webgl.Shader shader = gl.createShader(type);
    gl.shaderSource(shader, shaderSource);
    gl.compileShader(shader);

    bool success =
    gl.getShaderParameter(shader, webgl.RenderingContext.COMPILE_STATUS);
    if (!success) {
      print(gl.getShaderInfoLog(shader));
      gl.deleteShader(shader);
    }

    return shader;
  }

  var vertexShader =
  createShader(webgl.RenderingContext.VERTEX_SHADER, vertexShaderSource);
  var fragmentShader = createShader(
      webgl.RenderingContext.FRAGMENT_SHADER, fragmentShaderSource);

  webgl.Program createProgram(webgl.Shader vertexShader, webgl.Shader fragmentShader) {
    webgl.Program program = gl.createProgram();
    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);

    bool success =
    gl.getProgramParameter(program, webgl.RenderingContext.LINK_STATUS);
    if (!success) {
      print(gl.getProgramInfoLog(program));
      gl.deleteProgram(program);
    }

    return program;
  }
  webgl.Program program = createProgram(vertexShader, fragmentShader);

  return program;
}