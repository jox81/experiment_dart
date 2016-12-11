import 'dart:typed_data';
import 'dart:web_gl';
import 'dart:html';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'dart:async';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/globals/context.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/scene.dart';

class TextureUtils {

  static Future<Texture> getTextureFromFile(String fileUrl, {bool repeatU : false, bool mirrorU : false,bool repeatV : false, bool mirrorV : false}) {
    Completer completer = new Completer();

    ImageElement image;

    image = new ImageElement()
      ..src = fileUrl
      ..onLoad.listen((e) {
        completer.complete(createColorTextureFromElement(image, repeatU:repeatU, mirrorU: mirrorU, repeatV: repeatV, mirrorV: mirrorV));
      });

    return completer.future;
  }

  // To use float :
  //  var ext = gl.getExtension("OES_texture_float");
  //  gl.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, GL.RGBA, GL.FLOAT, textureImage);
  //  gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
  //  gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
  static Texture createColorTextureFromElement(ImageElement image,{bool repeatU : false, bool mirrorU : false,bool repeatV : false, bool mirrorV : false}) {
    Texture texture = gl.createTexture();
    gl.bindTexture(GL.TEXTURE_2D, texture);

    gl.pixelStorei(GL.UNPACK_FLIP_Y_WEBGL, 1);

    int WRAP_S = repeatU ? (mirrorU ? GL.MIRRORED_REPEAT:GL.REPEAT):GL.CLAMP_TO_EDGE;
    int WRAP_T = repeatV ? (mirrorV ? GL.MIRRORED_REPEAT:GL.REPEAT):GL.CLAMP_TO_EDGE;

    gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, WRAP_S);
    gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, WRAP_T);

    gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR);
    gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
//    gl.generateMipmap(GL.TEXTURE_2D);

    gl.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, GL.RGBA, GL.UNSIGNED_BYTE, image);

    gl.bindTexture(GL.TEXTURE_2D, null);

    return texture;
  }

  static Texture createColorTexture(int size) {
    Texture texture = gl.createTexture();
    gl.bindTexture(GL.TEXTURE_2D, texture);

    gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR);
    gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
//    gl.generateMipmap(GL.TEXTURE_2D);

    gl.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, size, size, 0, GL.RGBA,
        GL.UNSIGNED_BYTE, null);

    gl.bindTexture(GL.TEXTURE_2D, null);

    return texture;
  }

  static Texture createDepthTexture(int size) {
    var depthTexture = gl.createTexture();
    gl.bindTexture(GL.TEXTURE_2D, depthTexture);
    gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
    gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
    gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
    gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
    gl.texImage2D(GL.TEXTURE_2D, 0, GL.DEPTH_COMPONENT, size, size, 0, GL.DEPTH_COMPONENT, GL.UNSIGNED_SHORT, null);

    gl.bindTexture(GL.TEXTURE_2D, null);

    return depthTexture;
  }

  static Renderbuffer createRenderBuffer(int size) {
    Renderbuffer renderBuffer = gl.createRenderbuffer();

    gl.bindRenderbuffer(GL.RENDERBUFFER, renderBuffer);
    gl.renderbufferStorage(GL.RENDERBUFFER, GL.DEPTH_COMPONENT16, size, size);
    gl.bindRenderbuffer(GL.RENDERBUFFER, null);

    return renderBuffer;
  }

  static Framebuffer createFrameBuffer(Texture colorTexture, Renderbuffer depthRenderbuffer) {
    Framebuffer framebuffer = gl.createFramebuffer();
    gl.bindFramebuffer(GL.FRAMEBUFFER, framebuffer);

    gl.framebufferTexture2D(
        GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, colorTexture, 0);
    gl.framebufferRenderbuffer(
        GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.RENDERBUFFER, depthRenderbuffer);
    gl.bindFramebuffer(GL.FRAMEBUFFER, null);

    if (gl.checkFramebufferStatus(GL.FRAMEBUFFER) != GL.FRAMEBUFFER_COMPLETE) {
      print("createRenderBuffer : this combination of attachments does not work");
      return null;
    }

    return framebuffer;
  }

  static Framebuffer createFrameBufferWithDepthTexture(Texture colorTexture, Texture depthTexture) {
    Framebuffer framebuffer = gl.createFramebuffer();
    gl.bindFramebuffer(GL.FRAMEBUFFER, framebuffer);

    gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, colorTexture, 0);
    gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.TEXTURE_2D, depthTexture, 0);

    gl.bindFramebuffer(GL.FRAMEBUFFER, null);

    if (gl.checkFramebufferStatus(GL.FRAMEBUFFER) != GL.FRAMEBUFFER_COMPLETE) {
      print("createRenderBuffer : this combination of attachments does not work");
      return null;
    }

    return framebuffer;
  }

  ///
  static Texture createRenderedTexture({int size: 512}) {

    //backup camera
    Camera baseCam = Context.mainCamera;

    Texture colorTexture = createColorTexture(size);
    Renderbuffer depthRenderbuffer = createRenderBuffer(size);
    Texture depthTexture = createDepthTexture(size);
//    Framebuffer framebuffer = createFrameBuffer(colorTexture, depthRenderbuffer);
    Framebuffer framebuffer = createFrameBufferWithDepthTexture(colorTexture, depthTexture);

    gl.bindFramebuffer(GL.FRAMEBUFFER, framebuffer);

    // draw something in the buffer
    // ...

    {
      Camera cameraTexture = new Camera(radians(45.0), 0.1, 100.0)
        ..targetPosition = new Vector3(6.0,3.0,0.0)
        ..position = new Vector3(10.0, 10.0, 10.0);

      Context.mainCamera = cameraTexture;

      //Each frameBuffer component will be filled up
      gl.clearColor(.5, .5, .5, 1); // green;
      gl.viewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
      gl.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);

      CubeModel cube = new CubeModel();
      cube.render();

      CubeModel cube2 = new CubeModel()
        ..position = new Vector3(3.0,0.0,0.0)
        ..material = new MaterialBaseColor(new Vector4.all(1.0));
      cube2.render();
    }

    //...
    //End draw

    readPixels(rectangle:new Rectangle(0,0,1,1));

    // Unbind the framebuffer
    gl.bindFramebuffer(GL.FRAMEBUFFER, null);

    //reset camera
    Context.mainCamera = baseCam;

    return colorTexture;
  }

  static void readPixels({Rectangle rectangle}) {
    if(rectangle == null) rectangle = new Rectangle(0,0,Context.width,Context.height);

    var pixels = new Uint8List(rectangle.width * rectangle.height * 4);

    gl.readPixels(
        rectangle.left,
        rectangle.top,
        rectangle.width,
        rectangle.height,
        GL.RGBA,
        GL.UNSIGNED_BYTE,
        pixels);

    print(pixels);
  }
}
