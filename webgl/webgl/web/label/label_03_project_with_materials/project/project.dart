import 'dart:web_gl';
import 'dart:math' as Math;
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/asset_library.dart';
import 'package:webgl/src/base/project/project.dart';
import 'package:webgl/src/materials/types/base_texture_material.dart';
import 'package:webgl/src/textures/text_texture.dart';
import 'package:webgl/webgl.dart';

class LabelProject extends BaseProject{

  int radius = 5;
  num speed = 0.001;
  Vector3 target = new Vector3(0.0, 0.0, 0.0);
  Vector3 up = new Vector3(0.0, 1.0, 0.0);
  Matrix4 projectionMatrix = new Matrix4.identity();
  Matrix4 modelMatrix = new Matrix4.identity();
  Matrix4 viewMatrix = new Matrix4.identity();

  LabelProject._();
  static Future<LabelProject> build() async {
    await AssetLibrary.loadDefault();
    return new LabelProject._().._setup();
  }

  MaterialBaseTexture rectangleTextureMaterial;
  void _setup() {

    rectangleTextureMaterial = new MaterialBaseTexture();
    WebGLProgram program = rectangleTextureMaterial.program;
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

    //> buffer position
    WebGLBuffer buffer = new WebGLBuffer();
    buffer.bindBuffer(BufferType.ARRAY_BUFFER);
    GL.bufferData(
        WebGL.ARRAY_BUFFER,
        new Float32List.fromList(positions),
        WebGL.STATIC_DRAW);
    program.getAttribLocation("a_Position")
      ..enabled = true
      ..vertexAttribPointer(2, WebGL.FLOAT, false, 0, 0);

    //> buffer texcoords
    buffer = new WebGLBuffer();
    buffer.bindBuffer(BufferType.ARRAY_BUFFER);
    GL.bufferData(
        WebGL.ARRAY_BUFFER,
        new Float32List.fromList(texcoords),
        WebGL.STATIC_DRAW);
    program.getAttribLocation("a_UV")
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
    TextTexture label = new TextTexture(128, 64)
      ..text = "Hello World !"
      ..draw();

    rectangleTextureMaterial..texture = label;

//    // 2 methods to render :
//    // - via a FrameBuffer to study how it works
//    // - directly by binding the active texture
//    bool useFrameBuffer = true;
//    if(useFrameBuffer){
//      //> create a framebuffer and attach texture to it
//      WebGLFrameBuffer framebuffer = new WebGLFrameBuffer();
//      ActiveFrameBuffer.instance.bind(framebuffer);
//      gl.framebufferTexture2D(
//          WebGL.FRAMEBUFFER, WebGL.COLOR_ATTACHMENT0,
//          WebGL.TEXTURE_2D, label.webGLTexture, 0);
//      int result = gl.checkFramebufferStatus(WebGL.FRAMEBUFFER);
//      if (result != WebGL.FRAMEBUFFER_COMPLETE) {
//        window.alert("unsupported framebuffer");
//        return;
//      }
//
//      new WebGLTexture.texture2d()..bind();
//      new TextureAttachment(TextureAttachmentTarget.TEXTURE_2D).copyTexImage2D(0, WebGL.RGBA, 0, 0, 128, 64, 0);
//      ActiveTexture.instance.texture2d.generateMipmap();
//
//      gl.bindFramebuffer(WebGL.FRAMEBUFFER, null);
//    }else{
//      label.bind();
//    }

    render() {
      gl.enable(WebGL.DEPTH_TEST);

      double fieldOfView = Math.pi * 0.25;
      num aspect = canvas.clientWidth / canvas.clientHeight;
      setPerspectiveMatrix(projectionMatrix, fieldOfView, aspect, 0.0001, 500.0);
    }

    render();
  }

  void update({num currentTime : 0.0}) {

    gl.clear(WebGL.COLOR_BUFFER_BIT | WebGL.DEPTH_BUFFER_BIT);

    //camera rotation
    Vector3 cameraPosition = new Vector3(
        Math.sin(currentTime * speed) * radius,
        1.0,
        Math.cos(currentTime * speed) * radius);

    setViewMatrix(viewMatrix, cameraPosition, target, up);

    rectangleTextureMaterial.setUniforms(rectangleTextureMaterial.program, modelMatrix, viewMatrix, projectionMatrix, cameraPosition, null);

    //draw
    gl.drawElements(WebGL.TRIANGLES, 1 * 3 * 2, WebGL.UNSIGNED_SHORT, 0);
  }
}