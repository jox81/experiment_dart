import 'dart:async';
import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/engine.dart';
import 'package:webgl/src/camera/types/perspective_camera.dart';
import 'package:webgl/src/webgl_objects/context.dart';
import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/renderer/renderer.dart';
import 'package:webgl/src/utils/utils_textures.dart';
import 'package:webgl/asset_library.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_framebuffer.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_uniform_location.dart';

WebGLTexture textureCrate;

Future main() async {

  Webgl01 webgl01 = new Webgl01(querySelector('#glCanvas') as CanvasElement);

  await AssetLibrary.shaders.init();
  textureCrate = await TextureUtils.createTexture2DFromImageUrl("../images/crate.gif");

  webgl01.setup();
  webgl01.render();
}

class Webgl01 {
  CanvasElement canvas;
  GLTFRenderer renderer;
  WebGLBuffer vertexBuffer;
  WebGLBuffer indicesBuffer;

  List<GLTFNode> nodes = new List();

  WebGLProgram shaderProgram;

  int vertexPositionAttribute;

  WebGLUniformLocation pMatrixUniform;
  WebGLUniformLocation mvMatrixUniform;

  Webgl01(this.canvas){
    initGL(canvas);
  }

  void initGL(CanvasElement canvas) {
    new Context(canvas,enableExtensions:true,logInfos:false);
  }

  void setup(){
    renderer = new GLTFRenderer(canvas);
    setupCamera();
    setupMeshes();

    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.enable(EnableCapabilityType.DEPTH_TEST);
  }

  void setupCamera()  {
    Engine.mainCamera = new CameraPerspective(radians(45.0), 0.1, 100.0)
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
    GL.activeFrameBuffer.bind(framebuffer);
    GL.activeFrameBuffer.framebufferTexture2D(FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.COLOR_ATTACHMENT0, TextureAttachmentTarget.TEXTURE_2D, textureCrate, 0);

    // Now draw with the texture to the canvas
    // NOTE: We clear the canvas to red so we'll know
    // we're drawing the texture and not seeing the clear
    // from above.
    GL.activeFrameBuffer.unBind();
    gl.clearColor(1.0, 0.0, 0.0, 1.0); // red
    gl.clear(ClearBufferMask.COLOR_BUFFER_BIT);
    gl.drawArrays(DrawMode.TRIANGLES, 0, 6);

  }

  void render({num time : 0.0}) {
    gl.viewport(0, 0, gl.drawingBufferWidth.toInt(), gl.drawingBufferHeight.toInt());
    gl.clear(ClearBufferMask.COLOR_BUFFER_BIT | ClearBufferMask.DEPTH_BUFFER_BIT);

    for(GLTFNode node in nodes){
      renderer.drawNode(node);
    }

    window.requestAnimationFrame((num time) {
      this.render(time: time);
    });
  }

}