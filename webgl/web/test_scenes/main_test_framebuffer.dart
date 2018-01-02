import 'dart:async';
import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera/camera.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/gltf/mesh.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/material/shader_source.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_framebuffer.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_uniform_location.dart';

WebGLTexture textureCrate;

Future main() async {

  Webgl01 webgl01 = new Webgl01(querySelector('#glCanvas') as CanvasElement);

  await ShaderSource.loadShaders();
  textureCrate = await TextureUtils.createTexture2DFromFile("../images/crate.gif");

  webgl01.setup();
  webgl01.render();
}

class Webgl01 {

  WebGLBuffer vertexBuffer;
  WebGLBuffer indicesBuffer;

  List<GLTFNode> nodes = new List();

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

    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.enable(EnableCapabilityType.DEPTH_TEST);
  }

  void setupCamera()  {
    Context.mainCamera = new CameraPerspective(radians(45.0), 0.1, 100.0)
      ..targetPosition = new Vector3.zero()
      ..translation = new Vector3(10.0,10.0,10.0);
  }

  void setupMeshes() {
    GLTFMesh meshQuad = new GLTFMesh.quad();
    GLTFNode nodeQuad = new GLTFNode()
      ..mesh = meshQuad
      ..matrix = (new Matrix4.identity()..setTranslation(new Vector3(2.0,0.0,0.0)));
    nodes.add(nodeQuad);

    // Create a framebuffer and attach the texture.
    WebGLFrameBuffer framebuffer = new WebGLFrameBuffer();
    Context.glWrapper.activeFrameBuffer.bind(framebuffer);
    Context.glWrapper.activeFrameBuffer.framebufferTexture2D(FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.COLOR_ATTACHMENT0, TextureAttachmentTarget.TEXTURE_2D, textureCrate, 0);

    // Now draw with the texture to the canvas
    // NOTE: We clear the canvas to red so we'll know
    // we're drawing the texture and not seeing the clear
    // from above.
    Context.glWrapper.activeFrameBuffer.unBind();
    gl.clearColor(1.0, 0.0, 0.0, 1.0); // red
    gl.clear(ClearBufferMask.COLOR_BUFFER_BIT);
    gl.drawArrays(DrawMode.TRIANGLES, 0, 6);

  }

  void render({num time : 0.0}) {
    gl.viewport(0, 0, gl.drawingBufferWidth.toInt(), gl.drawingBufferHeight.toInt());
    gl.clear(ClearBufferMask.COLOR_BUFFER_BIT | ClearBufferMask.DEPTH_BUFFER_BIT);

    for(Mesh model in nodes){
      model.render();
    }

    window.requestAnimationFrame((num time) {
      this.render(time: time);
    });
  }

}