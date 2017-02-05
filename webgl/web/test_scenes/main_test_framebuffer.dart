import 'dart:async';
import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_framebuffer.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_uniform_location.dart';

WebGLTexture textureCrate;

Future main() async {

  Webgl01 webgl01 = new Webgl01(querySelector('#glCanvas'));

  await ShaderSource.loadShaders();
  textureCrate = await TextureUtils.getTextureFromFile("../images/crate.gif");

  webgl01.setup();
  webgl01.render();
}

class Webgl01 {

  WebGLBuffer vertexBuffer;
  WebGLBuffer indicesBuffer;

  List<Model> models = new List();

  WebGLProgram shaderProgram;

  int vertexPositionAttribute;

  WebGLUniformLocation pMatrixUniform;
  WebGLUniformLocation mvMatrixUniform;

  Webgl01(CanvasElement canvas){
    initGL(canvas);
  }

  void initGL(CanvasElement canvas) {
    Context.init(canvas,enableExtensions:true,logInfos:false);
  }

  void setup(){
    setupCamera();
    setupMeshes();

    gl.clearColor = new Vector4(0.0, 0.0, 0.0, 1.0);
    gl.depthTest = true;
  }

  void setupCamera()  {
    Context.mainCamera = new Camera(radians(45.0), 0.1, 100.0)
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(10.0,10.0,10.0);
  }

  void setupMeshes() {
    QuadModel quad = new QuadModel()
      ..transform.translate(0.0, 0.0, 0.0);
    models.add(quad);

    // Create a framebuffer and attach the texture.
    WebGLFrameBuffer framebuffer = new WebGLFrameBuffer();
    gl.activeFrameBuffer.bind(framebuffer);
    gl.activeFrameBuffer.framebufferTexture2D(FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.COLOR_ATTACHMENT0, TextureAttachmentTarget.TEXTURE_2D, textureCrate, 0);

    // Now draw with the texture to the canvas
    // NOTE: We clear the canvas to red so we'll know
    // we're drawing the texture and not seeing the clear
    // from above.
    gl.activeFrameBuffer.unBind();
    gl.clearColor = new Vector4(1.0, 0.0, 0.0, 1.0); // red
    gl.clear([ClearBufferMask.COLOR_BUFFER_BIT]);
    gl.drawArrays(DrawMode.TRIANGLES, 0, 6);

  }

  void render({num time : 0.0}) {
    gl.viewport = new Rectangle(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
    gl.clear([ClearBufferMask.COLOR_BUFFER_BIT, ClearBufferMask.DEPTH_BUFFER_BIT]);

    for(Model model in models){
      model.render();
    }

    window.requestAnimationFrame((num time) {
      this.render(time: time);
    });
  }

}