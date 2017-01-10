import 'dart:typed_data';
import 'dart:html';
import 'dart:async';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_framebuffer.dart';
import 'package:webgl/src/webgl_objects/webgl_renderbuffer.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
import 'package:webgl/src/webgl_objects/webgl_rendering_context.dart';

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
    texture.bind(TextureTarget.TEXTURE_2D);

    gl.pixelStorei(PixelStorgeType.UNPACK_FLIP_Y_WEBGL, 1);

    TextureWrapType WRAP_S = repeatU ? (mirrorU ? TextureWrapType.MIRRORED_REPEAT:TextureWrapType.REPEAT):TextureWrapType.CLAMP_TO_EDGE;
    TextureWrapType WRAP_T = repeatV ? (mirrorV ? TextureWrapType.MIRRORED_REPEAT:TextureWrapType.REPEAT):TextureWrapType.CLAMP_TO_EDGE;

    texture.setParameterInt(TextureTarget.TEXTURE_2D, TextureParameterGlEnum.TEXTURE_WRAP_S, WRAP_S);
    texture.setParameterInt(TextureTarget.TEXTURE_2D, TextureParameterGlEnum.TEXTURE_WRAP_T, WRAP_T);
    texture.setParameterInt(TextureTarget.TEXTURE_2D, TextureParameterGlEnum.TEXTURE_MIN_FILTER, TextureMinType.LINEAR);
    texture.setParameterInt(TextureTarget.TEXTURE_2D, TextureParameterGlEnum.TEXTURE_MAG_FILTER, TextureMagType.LINEAR);
//    gl.generateMipmap(RenderingContext.TEXTURE_2D);

    gl.texImage2D(TextureAttachmentTarget.TEXTURE_2D, 0, TextureInternalFormatType.RGBA, TextureInternalFormatType.RGBA, TexelDataType.UNSIGNED_BYTE, image);

    texture.unBind(TextureTarget.TEXTURE_2D);
    return texture;
  }

  static WebGLTexture createColorTexture(int size) {
    WebGLTexture texture = new WebGLTexture();
    texture.bind(TextureTarget.TEXTURE_2D);

    texture.setParameterInt(TextureTarget.TEXTURE_2D, TextureParameterGlEnum.TEXTURE_MIN_FILTER, TextureMinType.NEAREST);
    texture.setParameterInt(TextureTarget.TEXTURE_2D, TextureParameterGlEnum.TEXTURE_MAG_FILTER, TextureMagType.NEAREST);
    texture.setParameterInt(TextureTarget.TEXTURE_2D, TextureParameterGlEnum.TEXTURE_WRAP_S, TextureWrapType.CLAMP_TO_EDGE);
    texture.setParameterInt(TextureTarget.TEXTURE_2D, TextureParameterGlEnum.TEXTURE_WRAP_T, TextureWrapType.CLAMP_TO_EDGE);
//    gl.generateMipmap(RenderingContext.TEXTURE_2D);

    gl.texImage2DWithWidthAndHeight(TextureAttachmentTarget.TEXTURE_2D, 0, TextureInternalFormatType.RGBA, size, size, 0, TextureInternalFormatType.RGBA,
        TexelDataType.UNSIGNED_BYTE, null);

    gl.bindTexture(TextureTarget.TEXTURE_2D, null);

    return texture;
  }

  static WebGLTexture createDepthTexture(int size) {
    WebGLTexture depthTexture = new WebGLTexture();
    TextureTarget target = TextureTarget.TEXTURE_2D;
    depthTexture.bind(target);

    depthTexture.setParameterInt(target, TextureParameterGlEnum.TEXTURE_MAG_FILTER, TextureMagType.NEAREST);
    depthTexture.setParameterInt(target, TextureParameterGlEnum.TEXTURE_MIN_FILTER, TextureMinType.NEAREST);
    depthTexture.setParameterInt(target, TextureParameterGlEnum.TEXTURE_WRAP_S, TextureWrapType.CLAMP_TO_EDGE);
    depthTexture.setParameterInt(target, TextureParameterGlEnum.TEXTURE_WRAP_T, TextureWrapType.CLAMP_TO_EDGE);

    gl.texImage2DWithWidthAndHeight(TextureAttachmentTarget.TEXTURE_2D, 0, WEBGL_depth_texture_InternalFormatType.DEPTH_COMPONENT, size, size, 0, WEBGL_depth_texture_InternalFormatType.DEPTH_COMPONENT, TexelDataType.UNSIGNED_BYTE, null);

    depthTexture.unBind(target);

    return depthTexture;
  }

  static WebGLRenderBuffer createRenderBuffer(int size) {
    WebGLRenderBuffer renderBuffer = new WebGLRenderBuffer();

    renderBuffer.bind();
    renderBuffer.renderbufferStorage(RenderBufferTarget.RENDERBUFFER, RenderBufferInternalFormatType.DEPTH_COMPONENT16, size, size);
    renderBuffer.unBind();

    return renderBuffer;
  }

  static WebGLFrameBuffer createFrameBuffer(WebGLTexture colorTexture, WebGLRenderBuffer depthRenderbuffer) {
    WebGLFrameBuffer framebuffer = new WebGLFrameBuffer();
    framebuffer.bind();

    colorTexture.framebufferTexture2D(
        FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.COLOR_ATTACHMENT0, TextureAttachmentTarget.TEXTURE_2D, 0);
    depthRenderbuffer.framebufferRenderbuffer(
        FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.DEPTH_ATTACHMENT, RenderBufferTarget.RENDERBUFFER);
    framebuffer.unBind();

    if (framebuffer.checkStatus() != FrameBufferStatus.FRAMEBUFFER_COMPLETE) {
      print("createRenderBuffer : this combination of attachments does not work");
      return null;
    }

    return framebuffer;
  }

  static WebGLFrameBuffer createFrameBufferWithDepthTexture(WebGLTexture colorTexture, WebGLTexture depthTexture) {
    WebGLFrameBuffer framebuffer = new WebGLFrameBuffer();
    framebuffer.bind();

    colorTexture.framebufferTexture2D(FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.COLOR_ATTACHMENT0, TextureAttachmentTarget.TEXTURE_2D, 0);
    depthTexture.framebufferTexture2D(FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.DEPTH_ATTACHMENT, TextureAttachmentTarget.TEXTURE_2D, 0);

    framebuffer.unBind();

    if (framebuffer.checkStatus() != FrameBufferStatus.FRAMEBUFFER_COMPLETE) {
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
    WebGLRenderBuffer depthRenderbuffer = createRenderBuffer(size);
//    WebGLTexture depthTexture = createDepthTexture(size);
    WebGLFrameBuffer framebuffer = createFrameBuffer(colorTexture, depthRenderbuffer);
//    Framebuffer framebuffer = createFrameBufferWithDepthTexture(colorTexture, depthTexture);

    framebuffer.bind();

    // draw something in the buffer
    // ...

    {
      Camera cameraTexture = new Camera(radians(45.0), 0.1, 100.0)
        ..targetPosition = new Vector3(6.0,3.0,0.0)
        ..position = new Vector3(10.0, 10.0, 10.0);

      Context.mainCamera = cameraTexture;

      //Each frameBuffer component will be filled up
      gl.clearColor = new Vector4(.5, .5, .5, 1.0); // green;
      gl.viewport = new Rectangle(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
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
    framebuffer.unBind();

    //reset camera
    if(baseCam != null) {
      Context.mainCamera = baseCam;
    }
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

    print('IMPLEMENTATION_COLOR_READ_FORMAT : ${gl.getParameter(ContextParameter.IMPLEMENTATION_COLOR_READ_FORMAT)}');
    print('IMPLEMENTATION_COLOR_READ_TYPE : ${gl.getParameter(ContextParameter.IMPLEMENTATION_COLOR_READ_TYPE)}');

    gl.readPixels(
        rectangle.left,
        rectangle.top,
        rectangle.width,
        rectangle.height,
        ReadPixelDataFormat.RGBA,
        ReadPixelDataType.UNSIGNED_BYTE,
        pixels);

    print(pixels);
  }
}
