import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'dart:web_gl' as webgl;
import 'package:webgl/src/shaders/shader_source.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/utils/utils_textures.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_framebuffer.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
import 'package:webgl/src/materials/types/dot_screen_material.dart';

Future main() async {
  await ShaderSource.loadShaders();

  new Renderer()..render();
}

class Renderer{
  webgl.RenderingContext gl;

  List<double> vertices;
  int elementsByVertices;

  String vsSource = '''
    attribute vec3 pos;

    void main() {
      gl_Position = vec4(pos, 3.0);
    }
  ''';

  String fsSource = '''
    void main() {
      gl_FragColor = vec4(0.5, 0.5, 1.0, 1.0);
    }
  ''';

  webgl.Program program;

  Renderer(){
    CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;
    Context.init(canvas);
    gl = GL.gl;
    gl.clearColor(0.8, 0.8, 0.8, 1);

    program = buildProgram(vsSource,fsSource);
    gl.useProgram(program);

    elementsByVertices = 3;
    vertices = [
      0.0, 0.0, 0.0,
      1.0, 0.0, 0.0,
      0.0, 1.0, 0.0
    ];

    setupAttribut(program, "pos", elementsByVertices , vertices);
  }

  webgl.Program buildProgram(String vs, String fs) {
    webgl.Program prog = gl.createProgram();

    addShader(prog, 'vertex', vs);
    addShader(prog, 'fragment', fs);

    gl.linkProgram(prog);
    if (gl.getProgramParameter(prog, webgl.WebGL.LINK_STATUS) == null) {
      throw "Could not link the shader program!";
    }
    return prog;
  }

  void addShader(webgl.Program prog, String type, String source) {
    webgl.Shader s = gl.createShader((type == 'vertex') ?
    webgl.WebGL.VERTEX_SHADER : webgl.WebGL.FRAGMENT_SHADER);
    gl.shaderSource(s, source);
    gl.compileShader(s);
    if (gl.getShaderParameter(s, webgl.WebGL.COMPILE_STATUS) == null) {
      throw "Could not compile " + type +
          " shader:\n\n"+gl.getShaderInfoLog(s);
    }
    gl.attachShader(prog, s);
  }

  void setupAttribut(webgl.Program prog, String attributName, int rsize, List<double> arr) {
    gl.bindBuffer(webgl.WebGL.ARRAY_BUFFER, gl.createBuffer());
    gl.bufferData(webgl.WebGL.ARRAY_BUFFER, new Float32List.fromList(arr),
        webgl.WebGL.STATIC_DRAW);
    int attr = gl.getAttribLocation(prog, attributName);
    gl.enableVertexAttribArray(attr);
    gl.vertexAttribPointer(attr, rsize, webgl.WebGL.FLOAT, false, 0, 0);
  }

  Future render({num time : 0.0}) async {
//    webgl.Texture texture = drawToFrameBuffer();

    gl.clearColor(.0, .5, .5, 1.0); // green;
    gl.clear(webgl.WebGL.COLOR_BUFFER_BIT);

    webgl.Texture texture = (await TextureUtils.createTexture2DFromImageUrl("packages/webgl/images/utils/uv.png")).webGLTexture;
    gl.bindTexture(webgl.WebGL.TEXTURE_2D, texture);
    gl.activeTexture(webgl.WebGL.TEXTURE0);



    webgl.Buffer positionBuffer = gl.createBuffer();
    gl.bindBuffer(webgl.WebGL.ARRAY_BUFFER, positionBuffer);


    MaterialDotScreen materialDotScreen = new MaterialDotScreen();
    materialDotScreen.texture = new WebGLTexture.fromWebGL(texture, webgl.WebGL.TEXTURE_2D);
    WebGLProgram program = materialDotScreen.getProgram();
    program.use();




    int positionLocation = gl.getAttribLocation(program.webGLProgram, 'position');
    gl.enableVertexAttribArray(positionLocation);

    gl.vertexAttribPointer(positionLocation, 2, webgl.WebGL.FLOAT, false, 0, 0);

    gl.bufferData(webgl.WebGL.ARRAY_BUFFER, new Float32List.fromList([
      -1.0, -1.0, -1.0, 1.0, 1.0, -1.0,
      1.0, 1.0, 1.0, -1.0, -1.0, 1.0,
    ]), webgl.WebGL.STATIC_DRAW);


    gl.drawArrays(webgl.WebGL.TRIANGLES, 0, 6);


    window.requestAnimationFrame((num time) {
      this.render(time: time);
    });
  }

//  void draw() {
//    gl.clear(webgl.WebGL.COLOR_BUFFER_BIT);
//    gl.drawArrays(webgl.WebGL.TRIANGLE_STRIP, 0, vertices.length ~/ elementsByVertices);
//  }

  webgl.Texture drawToFrameBuffer() {

  //The texture to bind must have a correct InternalFormatType
    WebGLTexture texture = createEmptyTexture(512,512);


    WebGLFrameBuffer frameBuffer = new WebGLFrameBuffer();
    GL.activeFrameBuffer.bind(frameBuffer);
    GL.activeFrameBuffer.framebufferTexture2D(
        FrameBufferTarget.FRAMEBUFFER,
        FrameBufferAttachment.COLOR_ATTACHMENT0,
        TextureAttachmentTarget.TEXTURE_2D,
        texture,
        0);

    gl.clearColor(.5, .5, .5, 1.0); // green;


    // Now draw with the texture to the canvas
    gl.clear(webgl.WebGL.COLOR_BUFFER_BIT);
    gl.drawArrays(webgl.WebGL.TRIANGLE_STRIP, 0, vertices.length ~/ elementsByVertices);
    GL.activeFrameBuffer.unBind();


    ImageElement image = TextureUtils.createImageFromTexture(texture.webGLTexture, 512, 512);
    document.body.children.add(image);
    return texture.webGLTexture;
  }

  WebGLTexture createEmptyTexture(int width, int height) {
    WebGLTexture texture = new WebGLTexture.texture2d();

    gl.activeTexture(webgl.WebGL.TEXTURE0);
    GL.activeTexture.texture2d.bind(texture);

    GL.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_MIN_FILTER,
        TextureMinificationFilterType.NEAREST);
    GL.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_MAG_FILTER,
        TextureMagnificationFilterType.NEAREST);
    GL.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_WRAP_S, TextureWrapType.CLAMP_TO_EDGE);
    GL.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_WRAP_T, TextureWrapType.CLAMP_TO_EDGE);
//    GL.activeTexture.texture2d.generateMipmap();

    GL.activeTexture.texture2d.attachmentTexture2d.texImage2DWithWidthAndHeight(
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
}
