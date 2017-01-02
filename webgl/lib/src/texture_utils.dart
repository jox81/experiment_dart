import 'dart:typed_data';
import 'dart:web_gl';
import 'dart:html';
import 'dart:async';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
import 'package:webgl/src/webgl_objects/webgl_context.dart';

class TextureUtils {

  static Future<WebGLTexture> getTextureFromFile(String fileUrl, {bool repeatU : false, bool mirrorU : false,bool repeatV : false, bool mirrorV : false}) {
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
  //  gl.texImage2D(RenderingContext.TEXTURE_2D, 0, RenderingContext.RGBA, RenderingContext.RGBA, RenderingContext.FLOAT, textureImage);
  //  gl.texParameteri(RenderingContext.TEXTURE_2D, RenderingContext.TEXTURE_MIN_FILTER, RenderingContext.NEAREST);
  //  gl.texParameteri(RenderingContext.TEXTURE_2D, RenderingContext.TEXTURE_MAG_FILTER, RenderingContext.NEAREST);
  static WebGLTexture createColorTextureFromElement(ImageElement image,{bool repeatU : false, bool mirrorU : false,bool repeatV : false, bool mirrorV : false}) {
    WebGLTexture texture = new WebGLTexture();
    gl.bindTexture(TextureTargetType.TEXTURE_2D, texture);

    gl.ctx.pixelStorei(RenderingContext.UNPACK_FLIP_Y_WEBGL, 1);

    int WRAP_S = repeatU ? (mirrorU ? RenderingContext.MIRRORED_REPEAT:RenderingContext.REPEAT):RenderingContext.CLAMP_TO_EDGE;
    int WRAP_T = repeatV ? (mirrorV ? RenderingContext.MIRRORED_REPEAT:RenderingContext.REPEAT):RenderingContext.CLAMP_TO_EDGE;

    gl.ctx.texParameteri(RenderingContext.TEXTURE_2D, RenderingContext.TEXTURE_WRAP_S, WRAP_S);
    gl.ctx.texParameteri(RenderingContext.TEXTURE_2D, RenderingContext.TEXTURE_WRAP_T, WRAP_T);

    gl.ctx.texParameteri(RenderingContext.TEXTURE_2D, RenderingContext.TEXTURE_MIN_FILTER, RenderingContext.LINEAR);
    gl.ctx.texParameteri(RenderingContext.TEXTURE_2D, RenderingContext.TEXTURE_MAG_FILTER, RenderingContext.LINEAR);
//    gl.generateMipmap(RenderingContext.TEXTURE_2D);

    gl.ctx.texImage2D(RenderingContext.TEXTURE_2D, 0, RenderingContext.RGBA, RenderingContext.RGBA, RenderingContext.UNSIGNED_BYTE, image);

    gl.bindTexture(TextureTargetType.TEXTURE_2D, null);

    return texture;
  }

  static WebGLTexture createColorTexture(int size) {
    WebGLTexture texture = new WebGLTexture();
    gl.bindTexture(TextureTargetType.TEXTURE_2D, texture);

    gl.ctx.texParameteri(RenderingContext.TEXTURE_2D, RenderingContext.TEXTURE_MIN_FILTER, RenderingContext.NEAREST);
    gl.ctx.texParameteri(RenderingContext.TEXTURE_2D, RenderingContext.TEXTURE_MAG_FILTER, RenderingContext.NEAREST);
    gl.ctx.texParameteri(RenderingContext.TEXTURE_2D, RenderingContext.TEXTURE_WRAP_S, RenderingContext.CLAMP_TO_EDGE);
    gl.ctx.texParameteri(RenderingContext.TEXTURE_2D, RenderingContext.TEXTURE_WRAP_T, RenderingContext.CLAMP_TO_EDGE);
//    gl.generateMipmap(RenderingContext.TEXTURE_2D);

    gl.ctx.texImage2D(RenderingContext.TEXTURE_2D, 0, RenderingContext.RGBA, size, size, 0, RenderingContext.RGBA,
        RenderingContext.UNSIGNED_BYTE, null);

    gl.bindTexture(TextureTargetType.TEXTURE_2D, null);

    return texture;
  }

  static WebGLTexture createDepthTexture(int size) {
    WebGLTexture depthTexture = new WebGLTexture();
    gl.bindTexture(TextureTargetType.TEXTURE_2D, depthTexture);
    
    gl.ctx.texParameteri(RenderingContext.TEXTURE_2D, RenderingContext.TEXTURE_MAG_FILTER, RenderingContext.NEAREST);
    gl.ctx.texParameteri(RenderingContext.TEXTURE_2D, RenderingContext.TEXTURE_MIN_FILTER, RenderingContext.NEAREST);
    gl.ctx.texParameteri(RenderingContext.TEXTURE_2D, RenderingContext.TEXTURE_WRAP_S, RenderingContext.CLAMP_TO_EDGE);
    gl.ctx.texParameteri(RenderingContext.TEXTURE_2D, RenderingContext.TEXTURE_WRAP_T, RenderingContext.CLAMP_TO_EDGE);

    gl.ctx.texImage2D(RenderingContext.TEXTURE_2D, 0, RenderingContext.DEPTH_COMPONENT, size, size, 0, RenderingContext.DEPTH_COMPONENT, RenderingContext.UNSIGNED_BYTE, null);

    gl.bindTexture(TextureTargetType.TEXTURE_2D, null);

    return depthTexture;
  }

  static Renderbuffer createRenderBuffer(int size) {
    Renderbuffer renderBuffer = gl.ctx.createRenderbuffer();

    gl.ctx.bindRenderbuffer(RenderingContext.RENDERBUFFER, renderBuffer);
    gl.ctx.renderbufferStorage(RenderingContext.RENDERBUFFER, RenderingContext.DEPTH_COMPONENT16, size, size);
    gl.ctx.bindRenderbuffer(RenderingContext.RENDERBUFFER, null);

    return renderBuffer;
  }

  static Framebuffer createFrameBuffer(WebGLTexture colorTexture, Renderbuffer depthRenderbuffer) {
    Framebuffer framebuffer = gl.ctx.createFramebuffer();
    gl.ctx.bindFramebuffer(RenderingContext.FRAMEBUFFER, framebuffer);

    gl.ctx.framebufferTexture2D(
        RenderingContext.FRAMEBUFFER, RenderingContext.COLOR_ATTACHMENT0, RenderingContext.TEXTURE_2D, colorTexture.webGLTexture, 0);
    gl.ctx.framebufferRenderbuffer(
        RenderingContext.FRAMEBUFFER, RenderingContext.DEPTH_ATTACHMENT, RenderingContext.RENDERBUFFER, depthRenderbuffer);
    gl.ctx.bindFramebuffer(RenderingContext.FRAMEBUFFER, null);

    if (gl.ctx.checkFramebufferStatus(RenderingContext.FRAMEBUFFER) != RenderingContext.FRAMEBUFFER_COMPLETE) {
      print("createRenderBuffer : this combination of attachments does not work");
      return null;
    }

    return framebuffer;
  }

  static Framebuffer createFrameBufferWithDepthTexture(WebGLTexture colorTexture, WebGLTexture depthTexture) {
    Framebuffer framebuffer = gl.ctx.createFramebuffer();
    gl.ctx.bindFramebuffer(RenderingContext.FRAMEBUFFER, framebuffer);

    gl.ctx.framebufferTexture2D(RenderingContext.FRAMEBUFFER, RenderingContext.COLOR_ATTACHMENT0, RenderingContext.TEXTURE_2D, colorTexture.webGLTexture, 0);
    gl.ctx.framebufferTexture2D(RenderingContext.FRAMEBUFFER, RenderingContext.DEPTH_ATTACHMENT, RenderingContext.TEXTURE_2D, depthTexture.webGLTexture, 0);

    gl.ctx.bindFramebuffer(RenderingContext.FRAMEBUFFER, null);

    if (gl.ctx.checkFramebufferStatus(RenderingContext.FRAMEBUFFER) != RenderingContext.FRAMEBUFFER_COMPLETE) {
      print("createRenderBuffer : this combination of attachments does not work");
      return null;
    }

    return framebuffer;
  }

  ///
  static WebGLTexture createRenderedTexture({int size: 512}) {

    //backup camera
    Camera baseCam = Context.mainCamera;

    WebGLTexture colorTexture = createColorTexture(size);
    Renderbuffer depthRenderbuffer = createRenderBuffer(size);
//    WebGLTexture depthTexture = createDepthTexture(size);
    Framebuffer framebuffer = createFrameBuffer(colorTexture, depthRenderbuffer);
//    Framebuffer framebuffer = createFrameBufferWithDepthTexture(colorTexture, depthTexture);

    gl.ctx.bindFramebuffer(RenderingContext.FRAMEBUFFER, framebuffer);

    // draw something in the buffer
    // ...

    {
      Camera cameraTexture = new Camera(radians(45.0), 0.1, 100.0)
        ..targetPosition = new Vector3(6.0,3.0,0.0)
        ..position = new Vector3(10.0, 10.0, 10.0);

      Context.mainCamera = cameraTexture;

      //Each frameBuffer component will be filled up
      gl.ctx.clearColor(.5, .5, .5, 1); // green;
      gl.setViewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
      gl.clear([ClearBufferMask.COLOR_BUFFER_BIT, ClearBufferMask.DEPTH_BUFFER_BIT]);

      CubeModel cube = new CubeModel();
      cube.render();

      CubeModel cube2 = new CubeModel()
        ..position = new Vector3(3.0,0.0,0.0)
        ..material = new MaterialBaseColor(new Vector4.all(1.0));
      cube2.render();
    }

    //...
    //End draw

//    readPixels(rectangle:new Rectangle(0,0,20,20)); doesn't work !...

    // Unbind the framebuffer
    gl.ctx.bindFramebuffer(RenderingContext.FRAMEBUFFER, null);

    //reset camera
    Context.mainCamera = baseCam;
    return colorTexture;
  }

  static void readPixels({Rectangle rectangle}) {
    if(rectangle == null) rectangle = new Rectangle(0,0,Context.width,Context.height);

    var pixels = new Uint8List(rectangle.width * rectangle.height * 4);
//    var pixels = new Float32List(rectangle.width * rectangle.height * 4);

    ///http://stackoverflow.com/questions/17981163/webgl-read-pixels-from-floating-point-render-target
    ///The readPixels is limited to the RGBA format and the UNSIGNED_BYTE type (WebGL specification).
    ///However there are some methods for "packing" floats into RGBA/UNSIGNED_BYTE described here:
    ///http://concord-consortium.github.io/lab/experiments/webgl-gpgpu/webgl.html

    print('IMPLEMENTATION_COLOR_READ_FORMAT : ${gl.ctx.getParameter(RenderingContext.IMPLEMENTATION_COLOR_READ_FORMAT)}');
    print('IMPLEMENTATION_COLOR_READ_TYPE : ${gl.ctx.getParameter(RenderingContext.IMPLEMENTATION_COLOR_READ_TYPE)}');

    gl.ctx.readPixels(
        rectangle.left,
        rectangle.top,
        rectangle.width,
        rectangle.height,
        RenderingContext.RGBA,
        RenderingContext.UNSIGNED_BYTE,
        pixels);

    print(pixels);
  }
}
