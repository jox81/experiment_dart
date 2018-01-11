import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'dart:web_gl' as webgl;
import 'package:webgl/src/gltf/renderer/materials.dart';
import 'package:webgl/src/material/shader_source.dart';
import 'package:webgl/src/textures/utils_textures.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum_wrapped.dart' as GLEnum;
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_rendering_context.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
import 'package:webgl/src/context.dart';

///From : https://medium.com/david-guan/webgl-and-image-filter-101-5017b290d02f

webgl.RenderingContext gl;

Future main() async {
  CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;

  WebGLRenderingContext renderingContext = new WebGLRenderingContext.create(canvas);
  gl = renderingContext.gl;
  Context.glWrapper = renderingContext;

  webgl.Texture texture = await loadImageToTexture();

  gl.activeTexture(webgl.RenderingContext.TEXTURE1);
  gl.bindTexture(webgl.RenderingContext.TEXTURE_2D, texture);

  webgl.Program programBase = buildProgram();
  gl.useProgram(programBase);
  await setupProgram(programBase, texture);

  //> create a framebuffer to draw on it
  webgl.Texture textureRender = createTexture(512,512).webGLTexture;
  //> create a framebuffer and attach texture to it
  webgl.Framebuffer framebuffer = gl.createFramebuffer();
  gl.bindFramebuffer(webgl.RenderingContext.FRAMEBUFFER, framebuffer);
  gl.framebufferTexture2D(
      webgl.RenderingContext.FRAMEBUFFER, webgl.RenderingContext.COLOR_ATTACHMENT0,
      webgl.RenderingContext.TEXTURE_2D, textureRender, 0);
  var result = gl.checkFramebufferStatus(webgl.RenderingContext.FRAMEBUFFER);
  if (result != webgl.RenderingContext.FRAMEBUFFER_COMPLETE) {
    int status = gl.checkFramebufferStatus(FrameBufferTarget.FRAMEBUFFER);
    print(GLEnum.FrameBufferStatus.getByIndex(status));
    return;
  }

  draw();
  gl.bindFramebuffer(webgl.RenderingContext.FRAMEBUFFER, null);

  //> apply filter
  await ShaderSource.loadShaders();
  MaterialDotScreen materialDotScreen = new MaterialDotScreen();
  materialDotScreen.texture = new WebGLTexture.fromWebGL(textureRender, webgl.RenderingContext.TEXTURE_2D);
  WebGLProgram programFilter = materialDotScreen.getProgram();

  gl.useProgram(programFilter.webGLProgram);
  setAttribut(programFilter.webGLProgram);
  materialDotScreen.setUniforms(programFilter, null, null, null, null, null);

  draw();
}

WebGLTexture createTexture(int width, int height) {
  WebGLTexture texture = new WebGLTexture.texture2d();

  gl.activeTexture(webgl.RenderingContext.TEXTURE0);
  Context.glWrapper.activeTexture.texture2d.bind(texture);

  Context.glWrapper.activeTexture.texture2d.setParameterInt(
      TextureParameter.TEXTURE_MIN_FILTER,
      TextureMinificationFilterType.NEAREST);
  Context.glWrapper.activeTexture.texture2d.setParameterInt(
      TextureParameter.TEXTURE_MAG_FILTER,
      TextureMagnificationFilterType.NEAREST);
  Context.glWrapper.activeTexture.texture2d.setParameterInt(
      TextureParameter.TEXTURE_WRAP_S, TextureWrapType.CLAMP_TO_EDGE);
  Context.glWrapper.activeTexture.texture2d.setParameterInt(
      TextureParameter.TEXTURE_WRAP_T, TextureWrapType.CLAMP_TO_EDGE);
//    Context.glWrapper.activeTexture.texture2d.generateMipmap();

  Context.glWrapper.activeTexture.texture2d.attachmentTexture2d.texImage2DWithWidthAndHeight(
    //        TextureAttachmentTarget.TEXTURE_2D,
      0,
      TextureInternalFormat.RGBA,
      width,
      height,
      0,
      TextureInternalFormat.RGBA,
      TexelDataType.UNSIGNED_BYTE,
      null);
  return texture;
}

Future setupProgram(webgl.Program program, webgl.Texture texture) async {
  //attribut
  setAttribut(program);

  //uniform
  webgl.UniformLocation uniformLocation = gl.getUniformLocation(program, 'u_texture');
  int activeUnit = 3;
  gl.activeTexture(webgl.RenderingContext.TEXTURE0 + activeUnit);
  gl.bindTexture(webgl.RenderingContext.TEXTURE_2D, texture);
  gl.uniform1i(uniformLocation, activeUnit);

}

void setAttribut(webgl.Program program) {
  //attribut
  var positionAttributeLocation = gl.getAttribLocation(program, 'position');
  var positionBuffer = gl.createBuffer();
  gl.bindBuffer(webgl.RenderingContext.ARRAY_BUFFER, positionBuffer);
  gl.bufferData(
      webgl.RenderingContext.ARRAY_BUFFER,
      new Float32List.fromList([
        -1.0, -1.0, //
        -1.0, 1.0,  //
        1.0, -1.0,  //
        1.0, 1.0,   //
        1.0, -1.0,  //
        -1.0, 1.0,
      ]),
      webgl.RenderingContext.STATIC_DRAW);

  gl.enableVertexAttribArray(positionAttributeLocation);
  gl.vertexAttribPointer(
      positionAttributeLocation, 2, webgl.RenderingContext.FLOAT, false, 0, 0);
}

buildProgram() {

  String vertexShaderSource = '''
    attribute vec2 position;
    varying vec2 v_coord;
    
    void main() {
      gl_Position = vec4(position, 0, 1);
      v_coord = gl_Position.xy * 0.5 + 0.5;
  }
  ''';

  String fragmentShaderSource = '''
    precision mediump float;
    
    uniform sampler2D u_texture;
    varying vec2 v_coord;
    
    void main() {
      vec4 sampleColor = texture2D(u_texture, vec2(v_coord.x, 1.0 - v_coord.y));
      gl_FragColor = sampleColor;
    }
  ''';

  webgl.Shader createShader(type, shaderSource) {
    webgl.Shader shader = gl.createShader(type);
    gl.shaderSource(shader, shaderSource);
    gl.compileShader(shader);

    var success =
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

  webgl.Program createProgram(vertexShader, fragmentShader) {
    webgl.Program program = gl.createProgram();
    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);

    var success =
    gl.getProgramParameter(program, webgl.RenderingContext.LINK_STATUS);
    if (!success) {
      print(gl.getProgramInfoLog(program));
      gl.deleteProgram(program);
    }

    return program;
  }
  var program = createProgram(vertexShader, fragmentShader);

  return program;
}

Future<webgl.Texture> loadImageToTexture() async {
  Completer completer = new Completer();
  webgl.Texture texture;
  ImageElement image = new ImageElement();
  image.crossOrigin = '';
  image.src = 'http://davidguan.me/webgl-intro/filter/github.jpg';
  image.onLoad.listen((e) {
    texture = handleLoadedTexture(image);
    completer.complete();
  });

  await completer.future;
  return texture;
}

handleLoadedTexture(image) {
  gl.activeTexture(webgl.RenderingContext.TEXTURE7);// random
  webgl.Texture texture = gl.createTexture();
  gl.bindTexture(webgl.RenderingContext.TEXTURE_2D, texture);
  gl.texParameteri(
      webgl.RenderingContext.TEXTURE_2D,
      webgl.RenderingContext.TEXTURE_WRAP_S,
      webgl.RenderingContext.CLAMP_TO_EDGE);
  gl.texParameteri(
      webgl.RenderingContext.TEXTURE_2D,
      webgl.RenderingContext.TEXTURE_WRAP_T,
      webgl.RenderingContext.CLAMP_TO_EDGE);
  gl.texParameteri(
      webgl.RenderingContext.TEXTURE_2D,
      webgl.RenderingContext.TEXTURE_MAG_FILTER,
      webgl.RenderingContext.NEAREST);
  gl.texParameteri(
      webgl.RenderingContext.TEXTURE_2D,
      webgl.RenderingContext.TEXTURE_MIN_FILTER,
      webgl.RenderingContext.NEAREST);
  gl.texImage2D(
      webgl.RenderingContext.TEXTURE_2D,
      0,
      webgl.RenderingContext.RGBA,
      webgl.RenderingContext.RGBA,
      webgl.RenderingContext.UNSIGNED_BYTE,
      image);

  return texture;
}

void draw() {
  gl.clearColor(1.0, 1.0, 1.0, 1.0);
  gl.clear(webgl.RenderingContext.COLOR_BUFFER_BIT);

  gl.drawArrays(webgl.RenderingContext.TRIANGLES, 0, 6);
}
