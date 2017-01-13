import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'dart:web_gl' as WebGL;

import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/utils.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_depth_texture/webgl_depth_texture.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_framebuffer.dart';
import 'package:webgl/src/webgl_objects/webgl_object.dart';
import 'package:webgl/src/webgl_objects/webgl_renderbuffer.dart';

class WebGLTexture extends WebGLObject{
  final WebGL.Texture webGLTexture;

  WebGLTexture() : this.webGLTexture = gl.ctx.createTexture();
  WebGLTexture.fromWebGL(this.webGLTexture);

  @override
  void delete() => gl.ctx.deleteTexture(webGLTexture);


  bool get isTexture => gl.ctx.isTexture(webGLTexture);

  void logTextureInfos() {
    Utils.log("RenderingContext Infos", () {

    });
  }
}

class TextureUtils {

  static Future<ImageElement> getImageFromFile(String fileUrl) {
    Completer completer = new Completer();

    ImageElement image;

    image = new ImageElement()
      ..src = fileUrl
      ..onLoad.listen((e) {
        completer.complete(image);
      });

    return completer.future;
  }

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
    gl.activeTexture.bind(TextureTarget.TEXTURE_2D, texture);

    gl.pixelStorei(PixelStorgeType.UNPACK_FLIP_Y_WEBGL, 1);

    TextureWrapType WRAP_S = repeatU ? (mirrorU ? TextureWrapType.MIRRORED_REPEAT:TextureWrapType.REPEAT):TextureWrapType.CLAMP_TO_EDGE;
    TextureWrapType WRAP_T = repeatV ? (mirrorV ? TextureWrapType.MIRRORED_REPEAT:TextureWrapType.REPEAT):TextureWrapType.CLAMP_TO_EDGE;

    gl.activeTexture.setParameterInt(TextureTarget.TEXTURE_2D, TextureParameter.TEXTURE_WRAP_S, WRAP_S);
    gl.activeTexture.setParameterInt(TextureTarget.TEXTURE_2D, TextureParameter.TEXTURE_WRAP_T, WRAP_T);
    gl.activeTexture.setParameterInt(TextureTarget.TEXTURE_2D, TextureParameter.TEXTURE_MIN_FILTER, TextureMinificationFilterType.LINEAR);
    gl.activeTexture.setParameterInt(TextureTarget.TEXTURE_2D, TextureParameter.TEXTURE_MAG_FILTER, TextureMagnificationFilterType.LINEAR);
//    gl.generateMipmap(RenderingContext.TEXTURE_2D);

    gl.activeTexture.texImage2D(TextureAttachmentTarget.TEXTURE_2D, 0, TextureInternalFormat.RGBA, TextureInternalFormat.RGBA, TexelDataType.UNSIGNED_BYTE, image);

    gl.activeTexture.unBind(TextureTarget.TEXTURE_2D);
    return texture;
  }

  static WebGLTexture createColorTexture(int size) {
    WebGLTexture texture = new WebGLTexture();
    gl.activeTexture.bind(TextureTarget.TEXTURE_2D, texture);

    gl.activeTexture.setParameterInt(TextureTarget.TEXTURE_2D, TextureParameter.TEXTURE_MIN_FILTER, TextureMinificationFilterType.NEAREST);
    gl.activeTexture.setParameterInt(TextureTarget.TEXTURE_2D, TextureParameter.TEXTURE_MAG_FILTER, TextureMagnificationFilterType.NEAREST);
    gl.activeTexture.setParameterInt(TextureTarget.TEXTURE_2D, TextureParameter.TEXTURE_WRAP_S, TextureWrapType.CLAMP_TO_EDGE);
    gl.activeTexture.setParameterInt(TextureTarget.TEXTURE_2D, TextureParameter.TEXTURE_WRAP_T, TextureWrapType.CLAMP_TO_EDGE);
//    gl.generateMipmap(RenderingContext.TEXTURE_2D);

    gl.activeTexture.texImage2DWithWidthAndHeight(TextureAttachmentTarget.TEXTURE_2D, 0, TextureInternalFormat.RGBA, size, size, 0, TextureInternalFormat.RGBA,
        TexelDataType.UNSIGNED_BYTE, null);

    gl.activeTexture.unBind(TextureTarget.TEXTURE_2D);

    return texture;
  }

  static WebGLTexture createColorCubeMapTexture(int size) {
    WebGLTexture texture = new WebGLTexture();
    gl.activeTexture.bind(TextureTarget.TEXTURE_CUBE_MAP, texture);

    gl.activeTexture.setParameterInt(TextureTarget.TEXTURE_CUBE_MAP, TextureParameter.TEXTURE_MIN_FILTER, TextureMinificationFilterType.LINEAR);
    gl.activeTexture.setParameterInt(TextureTarget.TEXTURE_CUBE_MAP, TextureParameter.TEXTURE_MAG_FILTER, TextureMagnificationFilterType.LINEAR);
    gl.activeTexture.setParameterInt(TextureTarget.TEXTURE_CUBE_MAP, TextureParameter.TEXTURE_WRAP_S, TextureWrapType.MIRRORED_REPEAT);
    gl.activeTexture.setParameterInt(TextureTarget.TEXTURE_CUBE_MAP, TextureParameter.TEXTURE_WRAP_T, TextureWrapType.MIRRORED_REPEAT);
//    gl.generateMipmap(RenderingContext.TEXTURE_2D);

    gl.activeTexture.texImage2DWithWidthAndHeight(TextureAttachmentTarget.TEXTURE_CUBE_MAP_POSITIVE_X, 0, TextureInternalFormat.RGBA, size, size, 0, TextureInternalFormat.RGBA,
        TexelDataType.UNSIGNED_BYTE, null);

    gl.activeTexture.unBind(TextureTarget.TEXTURE_CUBE_MAP);

    return texture;
  }

  static WebGLTexture createDepthTexture(int size) {
    //need extensions
    var OES_texture_float = gl.getExtension('OES_texture_float');
    assert(OES_texture_float != null);

    var WEBGL_depth_texture = gl.getExtension('WEBGL_depth_texture');
    assert(WEBGL_depth_texture != null);

    WebGLTexture depthTexture = new WebGLTexture();
    TextureTarget target = TextureTarget.TEXTURE_2D;

    gl.activeTexture.bind(target, depthTexture);
    gl.activeTexture.setParameterInt(target, TextureParameter.TEXTURE_MAG_FILTER, TextureMagnificationFilterType.NEAREST);
    gl.activeTexture.setParameterInt(target, TextureParameter.TEXTURE_MIN_FILTER, TextureMinificationFilterType.NEAREST);
    gl.activeTexture.setParameterInt(target, TextureParameter.TEXTURE_WRAP_S, TextureWrapType.CLAMP_TO_EDGE);
    gl.activeTexture.setParameterInt(target, TextureParameter.TEXTURE_WRAP_T, TextureWrapType.CLAMP_TO_EDGE);
    gl.activeTexture.texImage2DWithWidthAndHeight(TextureAttachmentTarget.TEXTURE_2D, 0, WEBGL_depth_texture_InternalFormat.DEPTH_COMPONENT, size, size, 0, WEBGL_depth_texture_InternalFormat.DEPTH_COMPONENT, WEBGL_depth_texture_TexelDataType.UNSIGNED_SHORT, null);
    gl.activeTexture.unBind(target);

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

    gl.activeFrameBuffer.bind(framebuffer);
    gl.activeFrameBuffer.framebufferTexture2D(
        FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.COLOR_ATTACHMENT0, TextureAttachmentTarget.TEXTURE_2D, colorTexture, 0);
    gl.activeFrameBuffer.framebufferRenderbuffer(
        FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.DEPTH_ATTACHMENT, RenderBufferTarget.RENDERBUFFER, depthRenderbuffer);
    gl.activeFrameBuffer.unBind();

    if (gl.activeFrameBuffer.checkStatus() != FrameBufferStatus.FRAMEBUFFER_COMPLETE) {
      print("createRenderBuffer : this combination of attachments does not work");
      return null;
    }

    return framebuffer;
  }

  static WebGLFrameBuffer createFrameBufferWithDepthTexture(WebGLTexture colorTexture, WebGLTexture depthTexture) {
    WebGLFrameBuffer framebuffer = new WebGLFrameBuffer();

    gl.activeFrameBuffer.bind(framebuffer);
    gl.activeFrameBuffer.framebufferTexture2D(FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.COLOR_ATTACHMENT0, TextureAttachmentTarget.TEXTURE_2D, colorTexture, 0);
    gl.activeFrameBuffer.framebufferTexture2D(FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.DEPTH_ATTACHMENT, TextureAttachmentTarget.TEXTURE_2D, depthTexture, 0);
    gl.activeFrameBuffer.unBind();

    if (gl.activeFrameBuffer.checkStatus() != FrameBufferStatus.FRAMEBUFFER_COMPLETE) {
      print("createRenderBuffer : this combination of attachments does not work");
      return null;
    }

    return framebuffer;
  }

  ///
  static List<WebGLTexture> createRenderedTextures({int size: 1024}) {

    //
    WebGLTexture colorTexture = createColorTexture(size);
    WebGLRenderBuffer depthRenderbuffer = createRenderBuffer(size);
    WebGLTexture depthTexture = createDepthTexture(size);

    WebGLFrameBuffer framebufferWithDepthRenderBuffer = createFrameBuffer(colorTexture, depthRenderbuffer);
    WebGLFrameBuffer framebufferWithDepthTexture = createFrameBufferWithDepthTexture(colorTexture, depthTexture);

    // draw something in the buffer
    // ...
    {
      List<Model> models = new List();

      //backup camera
      Camera baseCam = Context.mainCamera;
      Rectangle previousViewport = new Rectangle(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);

      gl.activeFrameBuffer.bind(framebufferWithDepthTexture);

      Camera cameraTexture = new Camera(radians(45.0), 0.1, 100.0)
        ..targetPosition = new Vector3(0.0,0.0,-12.0)
        ..position = new Vector3(5.0, 15.0, 15.0);

      Context.mainCamera = cameraTexture;

      //Each frameBuffer component will be filled up
      gl.clearColor = new Vector4(.5, .5, .5, 0.0); // green;
      gl.viewport = new Rectangle(0, 0, size, size);
      gl.clear([ClearBufferMask.COLOR_BUFFER_BIT, ClearBufferMask.DEPTH_BUFFER_BIT]);

      //plane
      QuadModel quadColor = new QuadModel()
        ..name = 'ground'
        ..material = new MaterialBaseColor(new Vector4(0.0, 0.5, 1.0, 1.0))
        ..position = new Vector3(0.0, 0.0, -50.0)
        ..transform.scale(10.0,1.0,100.0)
        ..transform.rotateX(radians(90.0));
      models.add(quadColor);

      //cubes
      for(int i = 0; i < 20; i++){
        CubeModel cube = new CubeModel()
          ..position = new Vector3(0.0,0.0,-4.0 * i.toDouble());
        models.add(cube);
      }

      for(Model model in models){
        model.render();
      }

      // Unbind the framebuffer
      gl.activeFrameBuffer.unBind();

      if(baseCam != null) {
        gl.viewport = previousViewport;
        Context.mainCamera = baseCam;
      }
    }
    //...
    //End draw

    //readPixels(rectangle:new Rectangle(0,0,20,20)); doesn't work !...

    return [colorTexture, depthTexture];
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


  static Future<List<ImageElement>> loadCubeMapImages() async {
    List<ImageElement> imageElements = new List(6);

    imageElements[0] = await TextureUtils.getImageFromFile("/application/images/cubemap/kitchen/c00.bmp");
    imageElements[1] = await TextureUtils.getImageFromFile("/application/images/cubemap/kitchen/c01.bmp");
    imageElements[2] = await TextureUtils.getImageFromFile("/application/images/cubemap/kitchen/c02.bmp");
    imageElements[3] = await TextureUtils.getImageFromFile("/application/images/cubemap/kitchen/c03.bmp");
    imageElements[4] = await TextureUtils.getImageFromFile("/application/images/cubemap/kitchen/c04.bmp");
    imageElements[5] = await TextureUtils.getImageFromFile("/application/images/cubemap/kitchen/c05.bmp");

    return imageElements;
  }

  static WebGLTexture createCubeMapFromElements(List<ImageElement> cubeMapImages) {
    assert(cubeMapImages.length == 6);

    WebGLTexture texture = new WebGLTexture();

    gl.pixelStorei(PixelStorgeType.UNPACK_FLIP_Y_WEBGL, 1);

    gl.activeTexture.bind(TextureTarget.TEXTURE_CUBE_MAP, texture);
    gl.activeTexture.setParameterInt(TextureTarget.TEXTURE_CUBE_MAP, TextureParameter.TEXTURE_MAG_FILTER, TextureMagnificationFilterType.LINEAR);
    gl.activeTexture.setParameterInt(TextureTarget.TEXTURE_CUBE_MAP, TextureParameter.TEXTURE_MIN_FILTER, TextureMinificationFilterType.LINEAR);
    gl.activeTexture.setParameterInt(TextureTarget.TEXTURE_2D, TextureParameter.TEXTURE_WRAP_S, TextureWrapType.CLAMP_TO_EDGE);
    gl.activeTexture.setParameterInt(TextureTarget.TEXTURE_2D, TextureParameter.TEXTURE_WRAP_T, TextureWrapType.CLAMP_TO_EDGE);

    for (int i = 0; i < cubeMapImages.length; i++) {
      gl.activeTexture.texImage2D(
          TextureAttachmentTarget.TEXTURE_CUBE_MAPS[i], 0, TextureInternalFormat.RGBA, TextureInternalFormat.RGBA, TexelDataType.UNSIGNED_BYTE, cubeMapImages[i]);
    }

    gl.activeTexture.unBind(TextureTarget.TEXTURE_CUBE_MAP);
    return texture;
  }
}
