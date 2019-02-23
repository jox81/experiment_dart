import 'dart:async';
import 'dart:html';
import 'dart:math' as Math;
import 'dart:typed_data';
import 'dart:web_gl';
import 'package:webgl/src/engine/engine_clock.dart';
import 'package:webgl/src/webgl_objects/active_framebuffer.dart';
import 'package:webgl/src/webgl_objects/context.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_uniform_location.dart';
import 'package:webgl/src/webgl_objects/textures/type/2d_texture.dart';
import 'package:webgl/src/webgl_objects/textures/type/attachment_texture.dart';
import 'package:webgl/src/webgl_objects/webgl_active_texture.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
import 'package:webgl/src/webgl_objects/webgl_framebuffer.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

Future main() async {

  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;

  new Context(canvas);

  EngineClock engineClock = new EngineClock();

  WebGLProgram program = buildProgram();
  program.use();

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

  WebGLUniformLocation worldViewProjectionLoc = program.getUniformLocation("u_worldViewProjection");

  //> buffer position
  WebGLBuffer buffer = new WebGLBuffer();
  buffer.bindBuffer(BufferType.ARRAY_BUFFER);
  GL.bufferData(
      WebGL.ARRAY_BUFFER,
      new Float32List.fromList(positions),
      WebGL.STATIC_DRAW);
  program.getAttribLocation("a_position")
      ..enabled = true
      ..vertexAttribPointer(2, WebGL.FLOAT, false, 0, 0);

  //> buffer texcoords
  buffer = new WebGLBuffer();
  buffer.bindBuffer(BufferType.ARRAY_BUFFER);
  GL.bufferData(
      WebGL.ARRAY_BUFFER,
      new Float32List.fromList(texcoords),
      WebGL.STATIC_DRAW);
  program.getAttribLocation("a_texcoord")
    ..enabled = true
    ..vertexAttribPointer(2, WebGL.FLOAT, false, 0, 0);

  //> buffer indices
  buffer = new WebGLBuffer();
  buffer.bindBuffer(BufferType.ELEMENT_ARRAY_BUFFER);
  GL.bufferData(
      WebGL.ELEMENT_ARRAY_BUFFER,
      new Uint16List.fromList(indices),
      WebGL.STATIC_DRAW);

  //> create label texture
  Label label = new Label(128, 64)
      ..text = "Hello World !"
      ..draw();

  // 2 methods to render :
  // - via a FrameBuffer to study how it works
  // - directly by binding the active texture
  bool useFrameBuffer = false;
  if(useFrameBuffer){
    //> create a framebuffer and attach texture to it
    WebGLFrameBuffer framebuffer = new WebGLFrameBuffer();
    ActiveFrameBuffer.instance.bind(framebuffer);
    gl.framebufferTexture2D(
        WebGL.FRAMEBUFFER, WebGL.COLOR_ATTACHMENT0,
        WebGL.TEXTURE_2D, label.webGLTexture, 0);
    int result = gl.checkFramebufferStatus(WebGL.FRAMEBUFFER);
    if (result != WebGL.FRAMEBUFFER_COMPLETE) {
      window.alert("unsupported framebuffer");
      return;
    }

    new WebGLTexture.texture2d()..bind();
    new TextureAttachment(TextureAttachmentTarget.TEXTURE_2D).copyTexImage2D(0, WebGL.RGBA, 0, 0, 128, 64, 0);
    ActiveTexture.instance.texture2d.generateMipmap();

    gl.bindFramebuffer(WebGL.FRAMEBUFFER, null);
  }else{
    label.bind();
  }

  int radius = 5;
  num speed = 0.001;
  Matrix4 projection;
  Vector3 target = new Vector3(0.0, 0.0, 0.0);
  Vector3 up = new Vector3(0.0, 1.0, 0.0);
  Matrix4 view = new Matrix4.identity();

  _render({num currentTime: 0.0}) {
    engineClock.currentTime = currentTime;

    gl.clear(WebGL.COLOR_BUFFER_BIT | WebGL.DEPTH_BUFFER_BIT);

    //camera rotation
    Vector3 eye = new Vector3(
      Math.sin(engineClock.currentTime * speed) * radius,
      1.0,
      Math.cos(engineClock.currentTime * speed) * radius);

    {
      setViewMatrix(view, eye, target, up);

      Matrix4 worldViewProjection = (projection * view) as Matrix4;

      gl.uniformMatrix4fv(
          worldViewProjectionLoc.webGLUniformLocation, false,
          worldViewProjection.storage);
    }

    //draw
    gl.drawElements(WebGL.TRIANGLES, 1 * 3 * 2, WebGL.UNSIGNED_SHORT, 0);
    print(gl.getError());

    window.requestAnimationFrame((num currentTime) {
      _render(currentTime: currentTime);
    });
  }

  render() {
    gl.enable(WebGL.DEPTH_TEST);

    //Camera
    double fieldOfView = Math.pi * 0.25;
    num aspect = canvas.clientWidth / canvas.clientHeight;
    projection = new Matrix4.identity();
    setPerspectiveMatrix(projection, fieldOfView, aspect, 0.0001, 500.0);

    _render();
  }

  render();
}

class Label extends WebGLTexture{
  String text = '';

  int width;
  int height;

  // create an offScreen canvas with a 2D canvas context to render text content
  CanvasRenderingContext2D  _ctxForMakingTextures = new CanvasElement().getContext("2d") as CanvasRenderingContext2D;
  CanvasRenderingContext2D  get ctx => _ctxForMakingTextures;

  Label(this.width, this.height):super.texture2d();

  void draw() {

    // make it a desired size
    ctx.canvas.width = width;
    ctx.canvas.height = height;

    // fill it a certain color
    ctx.fillStyle = "rgb(0,0,255)";  // blue
    ctx.fillRect(0, 0, ctx.canvas.width, ctx.canvas.height);

    // draw some text into it.
    ctx.fillStyle = "rgb(255,255,255)";  // white
    ctx.font = "20px sans-serif";
    ctx.fillText(text, 5, 40);

    // Now make a texture from it
    bind();

    gl.texImage2D(TextureTarget.TEXTURE_2D, 0, WebGL.RGBA, WebGL.RGBA, WebGL.UNSIGNED_BYTE, ctx.canvas);

    // generate mipmaps or set filtering
    gl.generateMipmap(WebGL.TEXTURE_2D);

    //on détache la texture, elle sera réutilisée plus tard
    gl.bindTexture(WebGL.TEXTURE_2D, null);
  }
}

WebGLProgram buildProgram() {

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

  WebGLShader createShader(int type, String shaderSource) {
    WebGLShader shader = new WebGLShader(type)
      ..source = shaderSource
      ..compile();

    bool success = shader.compileStatus;
    if (!success) {
      shader.logShaderInfos();
      shader.delete();
    }

    return shader;
  }

  WebGLShader vertexShader =
  createShader(ShaderType.VERTEX_SHADER, vertexShaderSource);
  WebGLShader fragmentShader = createShader(
      ShaderType.FRAGMENT_SHADER, fragmentShaderSource);

  WebGLProgram createProgram(WebGLShader vertexShader, WebGLShader fragmentShader) {
    WebGLProgram program = new WebGLProgram();
    program.attachShader(vertexShader);
    program.attachShader(fragmentShader);
    program.link();

    bool success = program.linkStatus;
    if (!success) {
      print(program.infoLog);
      program.delete();
    }

    return program;
  }
  WebGLProgram program = createProgram(vertexShader, fragmentShader);

  return program;
}