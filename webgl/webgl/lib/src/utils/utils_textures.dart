import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera/types/perspective_camera.dart';
import 'package:webgl/src/webgl_objects/context.dart';
import 'package:webgl/materials.dart';
import 'package:webgl/src/engine/engine.dart';
import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_depth_texture/webgl_depth_texture_wrapped.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_framebuffer.dart';
import 'package:webgl/src/webgl_objects/webgl_renderbuffer.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
import 'dart:web_gl' as webgl;
import 'package:webgl/src/webgl_objects/datas/webgl_enum_wrapped.dart' as GLEnum;
import 'package:path/path.dart' as path;

class TextureLibrary{

  List<String> paths = [
    "images/crate.gif",
    "images/fabric_bump.jpg",
  ];

  List<ImageElement> _images;
  List<ImageElement> get images => _images ??= Engine.assetsManager.loadImages(paths);

  TextureLibrary();
}

class TextureUtils {




  // To use float :
  //  var ext = gl.getExtension("OES_texture_float");
  //  gl.texImage2D(RenderingContext.TEXTURE_2D, 0, RenderingContext.RGBA, RenderingContext.RGBA, RenderingContext.FLOAT, textureImage);
  //  gl.texParameteri(RenderingContext.TEXTURE_2D, RenderingContext.TEXTURE_MIN_FILTER, RenderingContext.NEAREST);
  //  gl.texParameteri(RenderingContext.TEXTURE_2D, RenderingContext.TEXTURE_MAG_FILTER, RenderingContext.NEAREST);
  static WebGLTexture createTexture2DFromImageElement(ImageElement image,
      {bool repeatU: false,
        bool mirrorU: false,
        bool repeatV: false,
        bool mirrorV: false}) {
    WebGLTexture texture = new WebGLTexture.texture2d();

    GL.activeTexture.texture2d.bind(texture);

    gl.pixelStorei(PixelStorgeType.UNPACK_FLIP_Y_WEBGL, 1);

    ///TextureWrapType WRAP_S
    int WRAP_S = repeatU
        ? (mirrorU ? TextureWrapType.MIRRORED_REPEAT : TextureWrapType.REPEAT)
        : TextureWrapType.CLAMP_TO_EDGE;
    int WRAP_T = repeatV
        ? (mirrorV ? TextureWrapType.MIRRORED_REPEAT : TextureWrapType.REPEAT)
        : TextureWrapType.CLAMP_TO_EDGE;

    GL.activeTexture.texture2d
        .setParameterInt(TextureParameter.TEXTURE_WRAP_S, WRAP_S);
    GL.activeTexture.texture2d
        .setParameterInt(TextureParameter.TEXTURE_WRAP_T, WRAP_T);
    GL.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_MIN_FILTER,
        TextureMinificationFilterType.LINEAR);
    GL.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_MAG_FILTER,
        TextureMagnificationFilterType.LINEAR);
//    gl.activeTexture.texture2d.generateMipmap();

    GL.activeTexture.texture2d.unBind();

    texture.image = image;

    return texture;
  }

  static Future<WebGLTexture> createTexture2DFromImageUrl(String fileUrl,
      {bool repeatU: false,
        bool mirrorU: false,
        bool repeatV: false,
        bool mirrorV: false}) async {

    ImageElement image = await Engine.assetsManager.loadImage(fileUrl);
    WebGLTexture texture = createTexture2DFromImageElement(image,
        repeatU: repeatU,
        mirrorU: mirrorU,
        repeatV: repeatV,
        mirrorV: mirrorV);

    return texture;
  }

  static WebGLTexture createEmptyTexture2D(int size) {
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
//    glWrapper.activeTexture.texture2d.generateMipmap();

    GL.activeTexture.texture2d.attachmentTexture2d.texImage2DWithWidthAndHeight(
        0,
        TextureInternalFormat.RGBA,
        size,
        size,
        0,
        TextureInternalFormat.RGBA,
        TexelDataType.UNSIGNED_BYTE,
        null);

    GL.activeTexture.texture2d.unBind();

    texture.image = null;

    return texture;
  }

  static WebGLTexture createEmptyTextureCubeMap(int size) {
    WebGLTexture texture = new WebGLTexture.textureCubeMap();
    GL.activeTexture.textureCubeMap.bind(texture);

    GL.activeTexture.textureCubeMap.setParameterInt(
        TextureParameter.TEXTURE_MIN_FILTER,
        TextureMinificationFilterType.LINEAR);
    GL.activeTexture.textureCubeMap.setParameterInt(
        TextureParameter.TEXTURE_MAG_FILTER,
        TextureMagnificationFilterType.LINEAR);
    GL.activeTexture.textureCubeMap.setParameterInt(
        TextureParameter.TEXTURE_WRAP_S, TextureWrapType.MIRRORED_REPEAT);
    GL.activeTexture.textureCubeMap.setParameterInt(
        TextureParameter.TEXTURE_WRAP_T, TextureWrapType.MIRRORED_REPEAT);
//    gl.activeTexture.textureCubeMap.generateMipmap();

    GL.activeTexture.textureCubeMap.attachmentPositiveX.texImage2DWithWidthAndHeight(
        0,
        TextureInternalFormat.RGBA,
        size,
        size,
        0,
        TextureInternalFormat.RGBA,
        TexelDataType.UNSIGNED_BYTE,
        null);

    GL.activeTexture.textureCubeMap.unBind();

    return texture;
  }

  static WebGLTexture createDepthTexture2D(int size) {
    //need extensions
    dynamic OES_texture_float = gl.getExtension('OES_texture_float');
    assert(OES_texture_float != null);

    dynamic WEBGL_depth_texture = gl.getExtension('WEBGL_depth_texture');
    assert(WEBGL_depth_texture != null);

    WebGLTexture depthTexture = new WebGLTexture.texture2d();

    GL.activeTexture.texture2d.bind(depthTexture);
    GL.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_MAG_FILTER,
        TextureMagnificationFilterType.NEAREST);
    GL.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_MIN_FILTER,
        TextureMinificationFilterType.NEAREST);
    GL.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_WRAP_S, TextureWrapType.CLAMP_TO_EDGE);
    GL.activeTexture.texture2d.setParameterInt(
        TextureParameter.TEXTURE_WRAP_T, TextureWrapType.CLAMP_TO_EDGE);
    GL.activeTexture.texture2d.attachmentTexture2d.texImage2DWithWidthAndHeight(
        0,
        WEBGL_depth_texture_InternalFormat.DEPTH_COMPONENT.index,
        size,
        size,
        0,
        WEBGL_depth_texture_InternalFormat.DEPTH_COMPONENT.index,
        WEBGL_depth_texture_TexelDataType.UNSIGNED_SHORT.index,
        null);
    GL.activeTexture.texture2d.unBind();

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

    GL.activeFrameBuffer.bind(framebuffer);
    GL.activeFrameBuffer.framebufferTexture2D(
        FrameBufferTarget.FRAMEBUFFER,
        FrameBufferAttachment.COLOR_ATTACHMENT0,
        TextureAttachmentTarget.TEXTURE_2D,
        colorTexture,
        0);

    if(depthRenderbuffer != null) {
      GL.activeFrameBuffer.framebufferRenderbuffer(
          FrameBufferTarget.FRAMEBUFFER,
          FrameBufferAttachment.DEPTH_ATTACHMENT,
          RenderBufferTarget.RENDERBUFFER,
          depthRenderbuffer);
    }

    if (GL.activeFrameBuffer.checkFramebufferStatus() !=
        FrameBufferStatus.FRAMEBUFFER_COMPLETE) {
      print(
          "createRenderBuffer : this combination of attachments does not work");
      int status = gl.checkFramebufferStatus(FrameBufferTarget.FRAMEBUFFER);
      print(GLEnum.FrameBufferStatus.getByIndex(status));
      return null;
    }

    GL.activeFrameBuffer.unBind();

    return framebuffer;
  }

  static WebGLFrameBuffer createFrameBufferWithDepthTexture(
      WebGLTexture colorTexture, WebGLTexture depthTexture) {
    WebGLFrameBuffer framebuffer = new WebGLFrameBuffer();

    GL.activeFrameBuffer.bind(framebuffer);
    GL.activeFrameBuffer.framebufferTexture2D(
        FrameBufferTarget.FRAMEBUFFER,
        FrameBufferAttachment.COLOR_ATTACHMENT0,
        TextureAttachmentTarget.TEXTURE_2D,
        colorTexture,
        0);
    GL.activeFrameBuffer.framebufferTexture2D(
        FrameBufferTarget.FRAMEBUFFER,
        FrameBufferAttachment.DEPTH_ATTACHMENT,
        TextureAttachmentTarget.TEXTURE_2D,
        depthTexture,
        0);

    if (GL.activeFrameBuffer.checkFramebufferStatus() !=
        FrameBufferStatus.FRAMEBUFFER_COMPLETE) {
      print(
          "createRenderBuffer : this combination of attachments does not work");
      int status = gl.checkFramebufferStatus(FrameBufferTarget.FRAMEBUFFER);
      print(GLEnum.FrameBufferStatus.getByIndex(status));
      return null;
    }

    GL.activeFrameBuffer.unBind();

    return framebuffer;
  }

  /// Default 1px Texture2D to assign new objects
  static WebGLTexture getDefaultColoredTexture() {
    WebGLTexture _defaultColoredTexture = createEmptyTexture2D(1);

    WebGLFrameBuffer framebuffer = new WebGLFrameBuffer();

    GL.activeFrameBuffer.bind(framebuffer);
    GL.activeFrameBuffer.framebufferTexture2D(
        FrameBufferTarget.FRAMEBUFFER,
        FrameBufferAttachment.COLOR_ATTACHMENT0,
        TextureAttachmentTarget.TEXTURE_2D,
        _defaultColoredTexture,
        0);

    Rectangle<int> previousViewport =
    new Rectangle(0, 0, gl.drawingBufferWidth.toInt(), gl.drawingBufferHeight.toInt());

    // draw pixels
    {
      //Each frameBuffer component will be filled up
      gl.clearColor(1.0, 0.0, 1.0, 1.0); // green;
      gl.viewport(0, 0, 1, 1);
      gl.clear(ClearBufferMask.COLOR_BUFFER_BIT);
    }
    // End draw

    // Unbind the framebuffer
    GL.activeFrameBuffer.unBind();
    GL.viewport = previousViewport;

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
      List<GLTFNode> models = new List();

      //backup camera
      CameraPerspective baseCam = Engine.mainCamera;
      Rectangle<int> previousViewport =
      new Rectangle(0, 0, gl.drawingBufferWidth.toInt(), gl.drawingBufferHeight.toInt());

      GL.activeFrameBuffer.bind(framebufferWithDepthTexture);

      CameraPerspective cameraTexture = new CameraPerspective(radians(45.0), 0.1, 100.0)
        ..targetPosition = new Vector3(0.0, 0.0, -12.0)
        ..translation = new Vector3(5.0, 15.0, 15.0);

      Engine.mainCamera = cameraTexture;

      //bound frameBuffer component will be filled up
      gl.clearColor(.5, .5, .5, 0.0); // green;
      GL.viewport = new Rectangle(0, 0, size, size);
      gl.clear(
          ClearBufferMask.COLOR_BUFFER_BIT | ClearBufferMask.DEPTH_BUFFER_BIT);

      GLTFMesh meshQuad = new GLTFMesh.quad()
        ..name = 'ground'
        ..primitives[0].material = new MaterialBaseColor(new Vector4(0.0, 0.5, 1.0, 1.0));
      GLTFNode nodeQuad = new GLTFNode()
        ..mesh = meshQuad
        ..translation = new Vector3(0.0, 0.0, -50.0)
        ..matrix.scale(10.0, 1.0, 100.0)
        ..matrix.rotateX(radians(90.0));
      models.add(nodeQuad);

      //cubes
      for (int i = 0; i < 20; i++) {

        GLTFMesh meshCube = new GLTFMesh.cube();
        GLTFNode nodeCube = new GLTFNode()
          ..mesh = meshCube
          ..translation = new Vector3(0.0, 0.0, -4.0 * i.toDouble());
        models.add(nodeCube);
      }

      // Todo (jpu) : gltf remove this
//      for (Mesh model in models) {
//        model.render();
//      }

      // Unbind the framebuffer
      GL.activeFrameBuffer.unBind();

      if (baseCam != null) {
        GL.viewport = previousViewport;
        Engine.mainCamera = baseCam;
      }
    }

    //...
    //End draw

    //readPixels(rectangle:new Rectangle(0,0,20,20)); doesn't work !...

    return [colorTexture, depthTexture];
  }

  // Todo (jpu) : This doesen't work in chromium : readPixel, but ok in chrome
  static ImageElement createImageFromTexture(webgl.Texture texture, int width, int height) {
    // Create a framebuffer backed by the texture
    var framebuffer = gl.createFramebuffer();
    gl.bindFramebuffer(webgl.WebGL.FRAMEBUFFER, framebuffer);
    gl.framebufferTexture2D(webgl.WebGL.FRAMEBUFFER, webgl.WebGL.COLOR_ATTACHMENT0, webgl.WebGL.TEXTURE_2D, texture, 0);

    // Read the contents of the framebuffer
    Uint8List data = new Uint8List(width * height * 4);
    gl.readPixels(0, 0, width, height, webgl.WebGL.RGBA, webgl.WebGL.UNSIGNED_BYTE, data);

    gl.deleteFramebuffer(framebuffer);

    // Create a 2D canvas to store the result
    CanvasElement canvas = document.createElement('canvas') as CanvasElement;
    canvas.width = width;
    canvas.height = height;
    CanvasRenderingContext2D context = canvas.getContext('2d');

    // Copy the pixels to a 2D canvas
    ImageData imageData = context.createImageData(width, height);
    imageData.data.setAll(0,data);
    context.putImageData(imageData, 0, 0);

    ImageElement img = new ImageElement();
    img.src = canvas.toDataUrl();
    return img;
  }

  static ImageElement createImageFromTextureNoReadPixel(WebGLTexture texture, int width, int height) {
    // Create a framebuffer backed by the texture
//    WebGLFrameBuffer framebuffer = new WebGLFrameBuffer();
//    gl.activeFrameBuffer.bind(framebuffer);
//    gl.activeFrameBuffer.framebufferTexture2D(FrameBufferTarget.FRAMEBUFFER, FrameBufferAttachment.COLOR_ATTACHMENT0, TextureAttachmentTarget.TEXTURE_2D, texture, 0);

    // Read the contents of the framebuffer
    Uint8List data = new Uint8List(width * height * 4);
    GL.activeTexture.texture2d.bind(texture);
    GL.activeTexture.texture2d.attachmentTexture2d.copyTexImage2D(0, TextureInternalFormat.RGBA, 0, 0, width, height, 0);

//    gl.readPixels(0, 0, width, height, ReadPixelDataFormat.RGBA, ReadPixelDataType.UNSIGNED_BYTE, data);
//    Uint8ClampedList dataClamped = new Uint8ClampedList.fromList(data.toList());
//    framebuffer.delete();

    // Create a 2D canvas to store the result
    CanvasElement canvas = document.createElement('canvas') as CanvasElement;
    canvas.width = width;
    canvas.height = height;
    dynamic context = canvas.getContext('2d');

    // Copy the pixels to a 2D canvas
    ImageData imageData = context.createImageData(width, height);
    imageData.data.setAll(0,data);
    context.putImageData(imageData, 0, 0);

    ImageElement img = new ImageElement();
    img.src = canvas.toDataUrl();
    return img;
  }

  static void readPixels({Rectangle<int> rectangle}) {
    if (rectangle == null)
      rectangle = new Rectangle(0, 0, GL.width.toInt(), GL.height.toInt());

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

  static Future<List<List<ImageElement>>> loadCubeMapImages(
      String cubeMapName, {String webPath:""}) async {

    ///List of List because it can have multiple mips level images
    Map<String, List<List<String>>> cubeMapsPath = {
      'test': [[
        path.join(Uri.base.origin, "packages/webgl/images/cubemap/test/test_px.png"),
        path.join(Uri.base.origin, "packages/webgl/images/cubemap/test/test_nx.png"),
        path.join(Uri.base.origin, "packages/webgl/images/cubemap/test/test_py.png"),
        path.join(Uri.base.origin, "packages/webgl/images/cubemap/test/test_ny.png"),
        path.join(Uri.base.origin, "packages/webgl/images/cubemap/test/test_pz.png"),
        path.join(Uri.base.origin, "packages/webgl/images/cubemap/test/test_nz.png"),
      ]],
      'kitchen': [[
        path.join(Uri.base.origin, "packages/webgl/images/cubemap/kitchen/c00.bmp"),
        path.join(Uri.base.origin, "packages/webgl/images/cubemap/kitchen/c01.bmp"),
        path.join(Uri.base.origin, "packages/webgl/images/cubemap/kitchen/c02.bmp"),
        path.join(Uri.base.origin, "packages/webgl/images/cubemap/kitchen/c03.bmp"),
        path.join(Uri.base.origin, "packages/webgl/images/cubemap/kitchen/c04.bmp"),
        path.join(Uri.base.origin, "packages/webgl/images/cubemap/kitchen/c05.bmp")
      ]],
      'pisa': [[
        path.join(Uri.base.origin, "packages/webgl/images/cubemap/pisa/pisa_posx.jpg"),
        path.join(Uri.base.origin, "packages/webgl/images/cubemap/pisa/pisa_negx.jpg"),
        path.join(Uri.base.origin, "packages/webgl/images/cubemap/pisa/pisa_posy.jpg"),
        path.join(Uri.base.origin, "packages/webgl/images/cubemap/pisa/pisa_negy.jpg"),
        path.join(Uri.base.origin, "packages/webgl/images/cubemap/pisa/pisa_posz.jpg"),
        path.join(Uri.base.origin, "packages/webgl/images/cubemap/pisa/pisa_negz.jpg"),
      ]],
      'papermill_diffuse': [[
        path.join(Uri.base.origin, "packages/webgl/images/cubemap/papermill/diffuse/diffuse_right_0.jpg"),
        path.join(Uri.base.origin, "packages/webgl/images/cubemap/papermill/diffuse/diffuse_left_0.jpg"),
        path.join(Uri.base.origin, "packages/webgl/images/cubemap/papermill/diffuse/diffuse_top_0.jpg"),
        path.join(Uri.base.origin, "packages/webgl/images/cubemap/papermill/diffuse/diffuse_bottom_0.jpg"),
        path.join(Uri.base.origin, "packages/webgl/images/cubemap/papermill/diffuse/diffuse_front_0.jpg"),
        path.join(Uri.base.origin, "packages/webgl/images/cubemap/papermill/diffuse/diffuse_back_0.jpg"),
      ]],
      'papermill_specular': (){
        int mipsLevel = 10;
        List<List<String>> images = [];

        for (int i = 0; i < mipsLevel; ++i) {
          images.add(
              [
                path.join(Uri.base.origin, "packages/webgl/images/cubemap/papermill/specular/specular_right_$i.jpg"),
                path.join(Uri.base.origin, "packages/webgl/images/cubemap/papermill/specular/specular_left_$i.jpg"),
                path.join(Uri.base.origin, "packages/webgl/images/cubemap/papermill/specular/specular_top_$i.jpg"),
                path.join(Uri.base.origin, "packages/webgl/images/cubemap/papermill/specular/specular_bottom_$i.jpg"),
                path.join(Uri.base.origin, "packages/webgl/images/cubemap/papermill/specular/specular_front_$i.jpg"),
                path.join(Uri.base.origin, "packages/webgl/images/cubemap/papermill/specular/specular_back_$i.jpg"),
              ]);
        }

        return images;
      }()
    };

    List<List<String>> paths = cubeMapsPath[cubeMapName];

    List<List<ImageElement>> imageElements = new List.generate(paths.length, (i) => new List(6));

    for (int mipsLevels = 0; mipsLevels < paths.length; mipsLevels++) {
      for (int i = 0; i < 6; i++) {
        imageElements[mipsLevels][i] = await Engine.assetsManager.loadImage(paths[mipsLevels][i]);
      }
    }

    return imageElements;
  }

  static WebGLTexture createCubeMapFromImages(
      List<List<ImageElement>> cubeMapImages,
      {bool flip: true}) {
//    assert(cubeMapImages.length == 6);

    WebGLTexture texture = new WebGLTexture.textureCubeMap();

    GL.activeTexture.textureCubeMap.bind(texture);

    GL.activeTexture.textureCubeMap.setParameterInt(
        TextureParameter.TEXTURE_WRAP_S, TextureWrapType.CLAMP_TO_EDGE);
    GL.activeTexture.textureCubeMap.setParameterInt(
        TextureParameter.TEXTURE_WRAP_T, TextureWrapType.CLAMP_TO_EDGE);

    int mipsLevel = cubeMapImages.length;

    int textureInternalFormat = TextureInternalFormat.RGBA;

    if (mipsLevel < 2) {
      GL.activeTexture.textureCubeMap.setParameterInt(
          TextureParameter.TEXTURE_MIN_FILTER,
          TextureMinificationFilterType.LINEAR);
      GL.activeTexture.textureCubeMap.setParameterInt(
          TextureParameter.TEXTURE_MAG_FILTER,
          TextureMagnificationFilterType.LINEAR);
    } else {
      GL.activeTexture.textureCubeMap.setParameterInt(
          TextureParameter.TEXTURE_MIN_FILTER,
          TextureMinificationFilterType.LINEAR_MIPMAP_LINEAR);
      GL.activeTexture.textureCubeMap.setParameterInt(
          TextureParameter.TEXTURE_MAG_FILTER,
          TextureMagnificationFilterType.LINEAR);
    }

    gl.pixelStorei(PixelStorgeType.UNPACK_FLIP_Y_WEBGL, flip ? 1 : 0);

    for (int mipLevels = 0; mipLevels < cubeMapImages.length; mipLevels++) {
      for (int i = 0; i < cubeMapImages[mipLevels].length; i++) {
        GL.activeTexture.textureCubeMap.attachments[i].texImage2D(
            mipLevels,
            textureInternalFormat,
            textureInternalFormat,
            TexelDataType.UNSIGNED_BYTE,
            cubeMapImages[mipLevels][i]);
      }
    }

    GL.activeTexture.textureCubeMap.unBind();
    return texture;
  }

  static webgl.Texture createImageTexture(int textureUnitId, ImageElement imageElement, int magFilter, int minFilter, int wrapS, int wrapT) {

    //create texture
    webgl.Texture texture = gl.createTexture();

    //bind it to an active texture unit
    gl.activeTexture(textureUnitId);
    gl.bindTexture(TextureTarget.TEXTURE_2D, texture);
    gl.pixelStorei(PixelStorgeType.UNPACK_FLIP_Y_WEBGL, 0);

    //fill texture data
    int mipMapLevel = 0;
    gl.texImage2D(
        TextureAttachmentTarget.TEXTURE_2D,
        mipMapLevel,
        TextureInternalFormat.RGBA,
        TextureInternalFormat.RGBA,
        TexelDataType.UNSIGNED_BYTE,
        imageElement);
    gl.generateMipmap(TextureTarget.TEXTURE_2D);

    //set textureUnit format
    gl.texParameteri(TextureTarget.TEXTURE_2D,
        TextureParameter.TEXTURE_MAG_FILTER, magFilter);
    gl.texParameteri(TextureTarget.TEXTURE_2D,
        TextureParameter.TEXTURE_MIN_FILTER, minFilter);
    gl.texParameteri(
        TextureTarget.TEXTURE_2D, TextureParameter.TEXTURE_WRAP_S, wrapS);
    gl.texParameteri(
        TextureTarget.TEXTURE_2D, TextureParameter.TEXTURE_WRAP_T, wrapT);

    return texture;
  }
}
