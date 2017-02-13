import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'dart:web_gl' as WebGL;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/material/materials.dart';
import 'package:webgl/src/geometry/models.dart';
import 'package:webgl/src/utils/utils_assets.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_depth_texture/webgl_depth_texture.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_active_texture.dart';
import 'package:webgl/src/webgl_objects/webgl_framebuffer.dart';
import 'package:webgl/src/webgl_objects/webgl_object.dart';
import 'package:webgl/src/webgl_objects/webgl_renderbuffer.dart';
@MirrorsUsed(targets: const [
  WebGLTexture,
  TextureUtils,
], override: '*')
import 'dart:mirrors';

///
class WebGLTexture extends EditTexture {
  final WebGL.Texture webGLTexture;
  final TextureTarget textureTarget;

  ImageElement image;

  Matrix4 textureMatrix = new Matrix4.identity();

  bool get isTexture => gl.ctx.isTexture(webGLTexture);

  WebGLTexture.texture2d() : this.textureTarget = TextureTarget.TEXTURE_2D, this.webGLTexture = gl.ctx.createTexture();
  WebGLTexture.textureCubeMap() : this.textureTarget = TextureTarget.TEXTURE_CUBE_MAP, this.webGLTexture = gl.ctx.createTexture();
  WebGLTexture.fromWebGL(WebGL.Texture webGLTexture, TextureTarget textureTarget): this.webGLTexture = webGLTexture, this.textureTarget = textureTarget;

  @override
  void delete() => gl.ctx.deleteTexture(webGLTexture);

  void logTextureInfos() {
    UtilsAssets.log("WebGLTexture Infos", () {

      print('editTextureUnit : ${editTextureUnit}');
      print('webGLTexture : ${webGLTexture}');
      print('textureTarget : ${textureTarget}');
      print('isTexture : ${isTexture}');

//      ActiveTexture.instance.activeUnit = editTextureUnit;
//
//      ActiveTexture.instance
//        ..texture2d.bind(this);

    });
  }

  void edit() {
    TextureUnit lastTextureUnit = ActiveTexture.instance.activeUnit;

    ActiveTexture.instance.activeUnit = editTextureUnit;

    switch(textureTarget){
      case TextureTarget.TEXTURE_2D:
        ActiveTexture.instance.texture2d.bind(this);
        break;
      case TextureTarget.TEXTURE_CUBE_MAP:
        ActiveTexture.instance.textureCubeMap.bind(this);
        break;
    }

    ActiveTexture.instance.activeUnit = lastTextureUnit;
  }
}

abstract class EditTexture extends WebGLObject{

  TextureTarget textureTarget;

  TextureUnit editTextureUnit = TextureUnit.TEXTURE8;

  // >>> single getParameter

  // >> Bind

  void bind({TextureUnit textureUnit}) {
    if(textureUnit != null){
      gl.activeTexture.activeUnit = textureUnit;
    }
    gl.activeTexture.bind(this, textureTarget);
  }

  // > TEXTURE_MAG_FILTER
  TextureMagnificationFilterType get textureMagFilter{
    bind(textureUnit: editTextureUnit);
    return TextureMagnificationFilterType.getByIndex(gl.ctx.getTexParameter(textureTarget.index,TextureParameter.TEXTURE_MAG_FILTER.index));
  }
  set textureMagFilter(TextureMagnificationFilterType  textureMagnificationFilterType){
    bind(textureUnit: editTextureUnit);
    gl.ctx.texParameteri(textureTarget.index, TextureParameter.TEXTURE_MAG_FILTER.index, textureMagnificationFilterType.index);
  }

  // > TEXTURE_MIN_FILTER
  TextureMinificationFilterType get textureMinFilter {
    bind(textureUnit: editTextureUnit);
    return TextureMinificationFilterType.getByIndex(gl.ctx.getTexParameter(
        textureTarget.index,
        TextureParameter.TEXTURE_MIN_FILTER.index));
  }
  set textureMinFilter(TextureMinificationFilterType  textureMinificationFilterType){
    bind(textureUnit: editTextureUnit);
    gl.ctx.texParameteri(textureTarget.index, TextureParameter.TEXTURE_MIN_FILTER.index, textureMinificationFilterType.index);
  }

  // > TEXTURE_WRAP_S
  TextureWrapType get textureWrapS
  {
    bind(textureUnit: editTextureUnit);
    return TextureWrapType.getByIndex(gl.ctx.getTexParameter(textureTarget.index,TextureParameter.TEXTURE_WRAP_S.index));
  }
  set textureWrapS(TextureWrapType  textureWrapType){
    bind(textureUnit: editTextureUnit);
    gl.ctx.texParameteri(textureTarget.index, TextureParameter.TEXTURE_WRAP_S.index, textureWrapType.index);
  }

  // > TEXTURE_WRAP_T
  TextureWrapType get textureWrapT {
    bind(textureUnit: editTextureUnit);
    return TextureWrapType.getByIndex(gl.ctx.getTexParameter(textureTarget.index,TextureParameter.TEXTURE_WRAP_T.index));
  }
  set textureWrapT(TextureWrapType  textureWrapType){
    bind(textureUnit: editTextureUnit);
    gl.ctx.texParameteri(textureTarget.index, TextureParameter.TEXTURE_WRAP_T.index, textureWrapType.index);
  }

}

class TextureUtils {
  static List<String> pathes = [
    "images/crate.gif",
    "images/fabric_bump.jpg",
  ];

  static List<ImageElement> images;

  static List<ImageElement> loadImages() {

    images = [];

    for(String fileUrl in pathes) {
      ImageElement image = new ImageElement()
        ..src = fileUrl;
      images.add(image);
    }

    return images;
  }

  static Future<ImageElement> loadImage(String fileUrl) {
    Completer completer = new Completer();

    ImageElement image;

    image = new ImageElement()
      ..src = fileUrl
      ..onLoad.listen((e) {
        completer.complete(image);
      });

    return completer.future;
  }

  static Future<WebGLTexture> createTexture2DFromFile(String fileUrl,
      {bool repeatU: false,
      bool mirrorU: false,
      bool repeatV: false,
      bool mirrorV: false}) async {

    ImageElement image = await loadImage(fileUrl);
    WebGLTexture texture = createTexture2DWithImage(image,
        repeatU: repeatU,
        mirrorU: mirrorU,
        repeatV: repeatV,
        mirrorV: mirrorV);

    return texture;
  }

  // To use float :
  //  var ext = gl.getExtension("OES_texture_float");
  //  gl.texImage2D(RenderingContext.TEXTURE_2D, 0, RenderingContext.RGBA, RenderingContext.RGBA, RenderingContext.FLOAT, textureImage);
  //  gl.texParameteri(RenderingContext.TEXTURE_2D, RenderingContext.TEXTURE_MIN_FILTER, RenderingContext.NEAREST);
  //  gl.texParameteri(RenderingContext.TEXTURE_2D, RenderingContext.TEXTURE_MAG_FILTER, RenderingContext.NEAREST);
  static WebGLTexture createTexture2DWithImage(ImageElement image,
      {bool repeatU: false,
      bool mirrorU: false,
      bool repeatV: false,
      bool mirrorV: false}) {
    WebGLTexture texture = new WebGLTexture.texture2d();
    gl.activeTexture.texture2d.bind(texture);

    gl.pixelStorei(PixelStorgeType.UNPACK_FLIP_Y_WEBGL, 1);

    TextureWrapType WRAP_S = repeatU
        ? (mirrorU ? TextureWrapType.MIRRORED_REPEAT : TextureWrapType.REPEAT)
        : TextureWrapType.CLAMP_TO_EDGE;
    TextureWrapType WRAP_T = repeatV
        ? (mirrorV ? TextureWrapType.MIRRORED_REPEAT : TextureWrapType.REPEAT)
        : TextureWrapType.CLAMP_TO_EDGE;

    gl.activeTexture.texture2d
        .setParameterInt(TextureParameter.TEXTURE_WRAP_S, WRAP_S);
    gl.activeTexture.texture2d
        .setParameterInt(TextureParameter.TEXTURE_WRAP_T, WRAP_T);
    gl.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_MIN_FILTER,
        TextureMinificationFilterType.LINEAR);
    gl.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_MAG_FILTER,
        TextureMagnificationFilterType.LINEAR);
//    gl.activeTexture.texture2d.generateMipmap();

    gl.activeTexture.texture2d.attachmentTexture2d.texImage2D(
        0,
        TextureInternalFormat.RGBA,
        TextureInternalFormat.RGBA,
        TexelDataType.UNSIGNED_BYTE,
        image);

    gl.activeTexture.texture2d.unBind();

    texture.image = image;

    return texture;
  }

  static WebGLTexture createEmptyTexture2D(int size) {
    WebGLTexture texture = new WebGLTexture.texture2d();
    gl.activeTexture.texture2d.bind(texture);

    gl.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_MIN_FILTER,
        TextureMinificationFilterType.NEAREST);
    gl.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_MAG_FILTER,
        TextureMagnificationFilterType.NEAREST);
    gl.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_WRAP_S, TextureWrapType.REPEAT);
    gl.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_WRAP_T, TextureWrapType.REPEAT);
//    gl.activeTexture.texture2d.generateMipmap();

    gl.activeTexture.texture2d.attachmentTexture2d.texImage2DWithWidthAndHeight(
        0,
        TextureInternalFormat.RGBA,
        size,
        size,
        0,
        TextureInternalFormat.RGBA,
        TexelDataType.UNSIGNED_BYTE,
        null);

    gl.activeTexture.texture2d.unBind();


    return texture;
  }

  static WebGLTexture createEmptyTextureCubeMap(int size) {
    WebGLTexture texture = new WebGLTexture.textureCubeMap();
    gl.activeTexture.textureCubeMap.bind(texture);

    gl.activeTexture.textureCubeMap.setParameterInt(
        TextureParameter.TEXTURE_MIN_FILTER,
        TextureMinificationFilterType.LINEAR);
    gl.activeTexture.textureCubeMap.setParameterInt(
        TextureParameter.TEXTURE_MAG_FILTER,
        TextureMagnificationFilterType.LINEAR);
    gl.activeTexture.textureCubeMap.setParameterInt(
        TextureParameter.TEXTURE_WRAP_S, TextureWrapType.MIRRORED_REPEAT);
    gl.activeTexture.textureCubeMap.setParameterInt(
        TextureParameter.TEXTURE_WRAP_T, TextureWrapType.MIRRORED_REPEAT);
//    gl.activeTexture.textureCubeMap.generateMipmap();

    gl.activeTexture.textureCubeMap.attachmentPositiveX.texImage2DWithWidthAndHeight(
        0,
        TextureInternalFormat.RGBA,
        size,
        size,
        0,
        TextureInternalFormat.RGBA,
        TexelDataType.UNSIGNED_BYTE,
        null);

    gl.activeTexture.textureCubeMap.unBind();

    return texture;
  }

  static WebGLTexture createDepthTexture2D(int size) {
    //need extensions
    var OES_texture_float = gl.getExtension('OES_texture_float');
    assert(OES_texture_float != null);

    var WEBGL_depth_texture = gl.getExtension('WEBGL_depth_texture');
    assert(WEBGL_depth_texture != null);

    WebGLTexture depthTexture = new WebGLTexture.texture2d();

    gl.activeTexture.texture2d.bind(depthTexture);
    gl.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_MAG_FILTER,
        TextureMagnificationFilterType.NEAREST);
    gl.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_MIN_FILTER,
        TextureMinificationFilterType.NEAREST);
    gl.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_WRAP_S, TextureWrapType.CLAMP_TO_EDGE);
    gl.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_WRAP_T, TextureWrapType.CLAMP_TO_EDGE);
    gl.activeTexture.texture2d.attachmentTexture2d.texImage2DWithWidthAndHeight(
        0,
        WEBGL_depth_texture_InternalFormat.DEPTH_COMPONENT,
        size,
        size,
        0,
        WEBGL_depth_texture_InternalFormat.DEPTH_COMPONENT,
        WEBGL_depth_texture_TexelDataType.UNSIGNED_SHORT,
        null);
    gl.activeTexture.texture2d.unBind();

    return depthTexture;
  }

  static WebGLRenderBuffer createEmptyRenderBuffer(int size) {
    WebGLRenderBuffer renderBuffer = new WebGLRenderBuffer();

    renderBuffer.bind();
    renderBuffer.renderbufferStorage(RenderBufferTarget.RENDERBUFFER,
        RenderBufferInternalFormatType.DEPTH_COMPONENT16, size, size);
    renderBuffer.unBind();

    return renderBuffer;
  }

  static WebGLFrameBuffer createFrameBuffer(
      WebGLTexture colorTexture, WebGLRenderBuffer depthRenderbuffer) {
    WebGLFrameBuffer framebuffer = new WebGLFrameBuffer();

    gl.activeFrameBuffer.bind(framebuffer);
    gl.activeFrameBuffer.framebufferTexture2D(
        FrameBufferTarget.FRAMEBUFFER,
        FrameBufferAttachment.COLOR_ATTACHMENT0,
        TextureAttachmentTarget.TEXTURE_2D,
        colorTexture,
        0);

    if(depthRenderbuffer != null) {
      gl.activeFrameBuffer.framebufferRenderbuffer(
          FrameBufferTarget.FRAMEBUFFER,
          FrameBufferAttachment.DEPTH_ATTACHMENT,
          RenderBufferTarget.RENDERBUFFER,
          depthRenderbuffer);
    }
    gl.activeFrameBuffer.unBind();

    if (gl.activeFrameBuffer.checkStatus() !=
        FrameBufferStatus.FRAMEBUFFER_COMPLETE) {
      print(
          "createRenderBuffer : this combination of attachments does not work");
      return null;
    }

    return framebuffer;
  }

  static WebGLFrameBuffer createFrameBufferWithDepthTexture(
      WebGLTexture colorTexture, WebGLTexture depthTexture) {
    WebGLFrameBuffer framebuffer = new WebGLFrameBuffer();

    gl.activeFrameBuffer.bind(framebuffer);
    gl.activeFrameBuffer.framebufferTexture2D(
        FrameBufferTarget.FRAMEBUFFER,
        FrameBufferAttachment.COLOR_ATTACHMENT0,
        TextureAttachmentTarget.TEXTURE_2D,
        colorTexture,
        0);
    gl.activeFrameBuffer.framebufferTexture2D(
        FrameBufferTarget.FRAMEBUFFER,
        FrameBufferAttachment.DEPTH_ATTACHMENT,
        TextureAttachmentTarget.TEXTURE_2D,
        depthTexture,
        0);
    gl.activeFrameBuffer.unBind();

    if (gl.activeFrameBuffer.checkStatus() !=
        FrameBufferStatus.FRAMEBUFFER_COMPLETE) {
      print(
          "createRenderBuffer : this combination of attachments does not work");
      return null;
    }

    return framebuffer;
  }

  /// Default 1px Texture2D to assign new objects
  static WebGLTexture getDefaultColoredTexture() {
    WebGLTexture _defaultColoredTexture = createEmptyTexture2D(1);

    WebGLFrameBuffer framebuffer = new WebGLFrameBuffer();

    gl.activeFrameBuffer.bind(framebuffer);
    gl.activeFrameBuffer.framebufferTexture2D(
        FrameBufferTarget.FRAMEBUFFER,
        FrameBufferAttachment.COLOR_ATTACHMENT0,
        TextureAttachmentTarget.TEXTURE_2D,
        _defaultColoredTexture,
        0);

    Rectangle previousViewport =
    new Rectangle(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);

    // draw pixels
    {
      //Each frameBuffer component will be filled up
      gl.clearColor = new Vector4(1.0, 0.0, 1.0, 1.0); // green;
      gl.viewport = new Rectangle(0, 0, 1, 1);
      gl.clear([ClearBufferMask.COLOR_BUFFER_BIT]);
    }
    // End draw

    // Unbind the framebuffer
    gl.activeFrameBuffer.unBind();
    gl.viewport = previousViewport;

    return _defaultColoredTexture;
  }

  /// build a frameBuffer and render something to it
  static List<WebGLTexture> buildRenderedTextures({int size: 1024}) {
    //
    WebGLTexture colorTexture = createEmptyTexture2D(size);
//    WebGLRenderBuffer depthRenderbuffer = createRenderBuffer(size);
    WebGLTexture depthTexture = createDepthTexture2D(size);

//    WebGLFrameBuffer framebufferWithDepthRenderBuffer =
//        createFrameBuffer(colorTexture, depthRenderbuffer);
    WebGLFrameBuffer framebufferWithDepthTexture =
        createFrameBufferWithDepthTexture(colorTexture, depthTexture);

    // draw something in the buffer
    // ...
    {
      List<Model> models = new List();

      //backup camera
      Camera baseCam = Context.mainCamera;
      Rectangle previousViewport =
          new Rectangle(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);

      gl.activeFrameBuffer.bind(framebufferWithDepthTexture);

      Camera cameraTexture = new Camera(radians(45.0), 0.1, 100.0)
        ..targetPosition = new Vector3(0.0, 0.0, -12.0)
        ..position = new Vector3(5.0, 15.0, 15.0);

      Context.mainCamera = cameraTexture;

      //Each frameBuffer component will be filled up
      gl.clearColor = new Vector4(.5, .5, .5, 0.0); // green;
      gl.viewport = new Rectangle(0, 0, size, size);
      gl.clear(
          [ClearBufferMask.COLOR_BUFFER_BIT, ClearBufferMask.DEPTH_BUFFER_BIT]);

      //plane
      QuadModel quadColor = new QuadModel()
        ..name = 'ground'
        ..material = new MaterialBaseColor(new Vector4(0.0, 0.5, 1.0, 1.0))
        ..position = new Vector3(0.0, 0.0, -50.0)
        ..transform.scale(10.0, 1.0, 100.0)
        ..transform.rotateX(radians(90.0));
      models.add(quadColor);

      //cubes
      for (int i = 0; i < 20; i++) {
        CubeModel cube = new CubeModel()
          ..position = new Vector3(0.0, 0.0, -4.0 * i.toDouble());
        models.add(cube);
      }

      for (Model model in models) {
        model.render();
      }

      // Unbind the framebuffer
      gl.activeFrameBuffer.unBind();

      if (baseCam != null) {
        gl.viewport = previousViewport;
        Context.mainCamera = baseCam;
      }
    }

    //...
    //End draw

    //readPixels(rectangle:new Rectangle(0,0,20,20)); doesn't work !...

    return [colorTexture, depthTexture];
  }

  static ImageElement createImageFromTexture(WebGLTexture texture, width, height) {
    // Create a framebuffer backed by the texture
    WebGLFrameBuffer framebuffer = new WebGLFrameBuffer();
    gl.activeFrameBuffer.bind(framebuffer);
    gl.activeFrameBuffer.framebufferTexture2D(FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.COLOR_ATTACHMENT0, TextureAttachmentTarget.TEXTURE_2D, texture, 0);

    gl.activeTexture.texture2d.attachmentTexture2d.copyTexImage2D(0, TextureInternalFormat.RGBA, 0, 0, 512, 512, 0);

    // Read the contents of the framebuffer
    Uint8List data = new Uint8List(width * height * 4);
    gl.readPixels(0, 0, width, height, ReadPixelDataFormat.RGBA, ReadPixelDataType.UNSIGNED_BYTE, data);
    Uint8ClampedList dataClamped = new Uint8ClampedList.fromList(data.toList());
    framebuffer.delete();

    // Create a 2D canvas to store the result
    CanvasElement canvas = document.createElement('canvas');
    canvas.width = width;
    canvas.height = height;
    var context = canvas.getContext('2d');

    // Copy the pixels to a 2D canvas
    ImageData imgData = new ImageData(dataClamped, width);

    ImageData imageData = context.createImageData(imgData);

    context.putImageData(imageData, 0, 0);

    var img = new ImageElement();
    img.src = canvas.toDataUrl();
    return img;
  }

  static ImageElement createImageFromTextureNoReadPixel(WebGLTexture texture, width, height) {
    // Create a framebuffer backed by the texture
//    WebGLFrameBuffer framebuffer = new WebGLFrameBuffer();
//    gl.activeFrameBuffer.bind(framebuffer);
//    gl.activeFrameBuffer.framebufferTexture2D(FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.COLOR_ATTACHMENT0, TextureAttachmentTarget.TEXTURE_2D, texture, 0);

    // Read the contents of the framebuffer
    Uint8List data = new Uint8List(width * height * 4);
    gl.activeTexture.texture2d.bind(texture);
    gl.activeTexture.texture2d.attachmentTexture2d.copyTexImage2D(0, TextureInternalFormat.RGBA, 0, 0, width, height, data);

//    gl.readPixels(0, 0, width, height, ReadPixelDataFormat.RGBA, ReadPixelDataType.UNSIGNED_BYTE, data);
//    Uint8ClampedList dataClamped = new Uint8ClampedList.fromList(data.toList());
//    framebuffer.delete();

    // Create a 2D canvas to store the result
    CanvasElement canvas = document.createElement('canvas');
    canvas.width = width;
    canvas.height = height;
    var context = canvas.getContext('2d');

    // Copy the pixels to a 2D canvas
    ImageData imgData = new ImageData(data, width);

    ImageData imageData = context.createImageData(imgData);

    context.putImageData(imageData, 0, 0);

    var img = new ImageElement();
    img.src = canvas.toDataUrl();
    return img;
  }

  static void readPixels({Rectangle rectangle}) {
    if (rectangle == null)
      rectangle = new Rectangle(0, 0, Context.width, Context.height);

    var pixels = new Uint8List(rectangle.width * rectangle.height * 4);
//    var pixels = new Float32List(rectangle.width * rectangle.height * 4);

    ///http://stackoverflow.com/questions/17981163/webgl-read-pixels-from-floating-point-render-target
    ///The readPixels is limited to the RGBA format and the UNSIGNED_BYTE type (WebGL specification).
    ///However there are some methods for "packing" floats into RGBA/UNSIGNED_BYTE described here:
    ///http://concord-consortium.github.io/lab/experiments/webgl-gpgpu/webgl.html

    print(
        'IMPLEMENTATION_COLOR_READ_FORMAT : ${gl.getParameter(ContextParameter.IMPLEMENTATION_COLOR_READ_FORMAT)}');
    print(
        'IMPLEMENTATION_COLOR_READ_TYPE : ${gl.getParameter(ContextParameter.IMPLEMENTATION_COLOR_READ_TYPE)}');

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

  static Future<List<ImageElement>> loadCubeMapImages(
      String cubeMapName) async {
    Map<String, List<String>> cubeMapsPath = {
      'test': [
        "images/cubemap/test/test_px.png",
        "images/cubemap/test/test_nx.png",
        "images/cubemap/test/test_py.png",
        "images/cubemap/test/test_ny.png",
        "images/cubemap/test/test_pz.png",
        "images/cubemap/test/test_nz.png",
      ],
      'kitchen': [
        "images/cubemap/kitchen/c00.bmp",
        "images/cubemap/kitchen/c01.bmp",
        "images/cubemap/kitchen/c02.bmp",
        "images/cubemap/kitchen/c03.bmp",
        "images/cubemap/kitchen/c04.bmp",
        "images/cubemap/kitchen/c05.bmp"
      ],
      'pisa': [
        "images/cubemap/pisa/pisa_posx.jpg",
        "images/cubemap/pisa/pisa_negx.jpg",
        "images/cubemap/pisa/pisa_posy.jpg",
        "images/cubemap/pisa/pisa_negy.jpg",
        "images/cubemap/pisa/pisa_posz.jpg",
        "images/cubemap/pisa/pisa_negz.jpg",
      ]
    };

    List<String> paths = cubeMapsPath[cubeMapName];

    List<ImageElement> imageElements = new List(6);

    for (int i = 0; i < 6; i++) {
      imageElements[i] = await TextureUtils.loadImage(paths[i]);
    }

    return imageElements;
  }

  static WebGLTexture createCubeMapWithImages(
      List<ImageElement> cubeMapImages,
      {bool flip: true}) {
    assert(cubeMapImages.length == 6);

    WebGLTexture texture = new WebGLTexture.textureCubeMap();

    gl.pixelStorei(PixelStorgeType.UNPACK_FLIP_Y_WEBGL, flip ? 1 : 0);

    gl.activeTexture.textureCubeMap.bind(texture);
    gl.activeTexture.textureCubeMap.setParameterInt(
        TextureParameter.TEXTURE_MAG_FILTER,
        TextureMagnificationFilterType.LINEAR);
    gl.activeTexture.textureCubeMap.setParameterInt(
        TextureParameter.TEXTURE_MIN_FILTER,
        TextureMinificationFilterType.LINEAR);
    gl.activeTexture.textureCubeMap.setParameterInt(
        TextureParameter.TEXTURE_WRAP_S, TextureWrapType.CLAMP_TO_EDGE);
    gl.activeTexture.textureCubeMap.setParameterInt(
        TextureParameter.TEXTURE_WRAP_T, TextureWrapType.CLAMP_TO_EDGE);

    for (int i = 0; i < cubeMapImages.length; i++) {
      gl.activeTexture.textureCubeMap.attachments[i].texImage2D(
//          TextureAttachmentTarget.TEXTURE_CUBE_MAPS[i],
          0,
          TextureInternalFormat.RGBA,
          TextureInternalFormat.RGBA,
          TexelDataType.UNSIGNED_BYTE,
          cubeMapImages[i]);
    }

    gl.activeTexture.textureCubeMap.unBind();
    return texture;
  }
}
