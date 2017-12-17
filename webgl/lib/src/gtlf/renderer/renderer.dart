import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'dart:typed_data';
import 'dart:convert' show BASE64;
import 'dart:web_gl' as webgl;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gtlf/renderer/program_setting.dart';
import 'package:webgl/src/material/shader_source.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/context.dart' as ctxWrapper;
import 'package:webgl/src/interaction.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

import 'package:webgl/src/gltf_pbr_demo/renderer_kronos_utils.dart';

import 'package:webgl/src/gtlf/accessor.dart';
import 'package:webgl/src/gtlf/animation.dart';
import 'package:webgl/src/gtlf/node.dart';
import 'package:webgl/src/gtlf/project.dart';
import 'package:webgl/src/gtlf/scene.dart';
import 'package:webgl/src/gtlf/texture.dart';

// Uint8List = Byte
// Uint16List = SCALAR : int

webgl.RenderingContext gl;
GLTFProject globalGltf;

GlobalState globalState;

// Direction from where the light is coming to origin
Vector3 lightPosition = new Vector3(50.0, 50.0, -50.0);
Vector3 get lightDirection => lightPosition.normalized();
Vector3 lightColor = new Vector3(1.0, 1.0, 1.0);
CameraPerspective get mainCamera => ctxWrapper.Context.mainCamera;

int skipTexture;

class GLTFRenderer implements Interactable {

  GLTFScene get activeScene => globalGltf.scenes[0];

  Interaction interaction;
  CameraPerspective get mainCamera => ctxWrapper.Context.mainCamera;
  CanvasElement _canvas;
  CanvasElement get canvas => _canvas;

  WebGLTexture brdfLUTTexture, cubeMapTextureDiffuse, cubeMapTextureSpecular;

  GLTFRenderer(GLTFProject gltf) {
    //debug.logCurrentFunction();
    _initContext();
    initInteraction();
    resizeCanvas();
    globalGltf = gltf;
  }

  void _initContext() {
    //debug.logCurrentFunction();

    try {
      _canvas = querySelector('#glCanvas') as CanvasElement;
      gl = _canvas.getContext("experimental-webgl") as webgl.RenderingContext;
      if (gl == null) {
        throw "x";
      }
    } catch (err) {
      throw "Your web browser does not support WebGL!";
    }

    //>
    ctxWrapper.gl = gl;
  }

  @override
  void initInteraction() {
    interaction = new Interaction(this);
    interaction.onResize.listen((dynamic event){resizeCanvas();});
  }

  void resizeCanvas() {
    var realToCSSPixels = window.devicePixelRatio;

    // Lookup the size the browser is displaying the canvas.
//    var displayWidth = (_canvas.parent.offsetWidth* realToCSSPixels).floor();
//    var displayHeight = (window.innerHeight* realToCSSPixels).floor();

    var displayWidth  = (gl.canvas.clientWidth  * realToCSSPixels).floor();
    var displayHeight = (gl.canvas.clientHeight * realToCSSPixels).floor();

    // Check if the canvas is not the same size.
    if (gl.canvas.width != displayWidth || gl.canvas.height != displayHeight) {
      // Make the canvas the same size
      gl.canvas.width = displayWidth;
      gl.canvas.height = displayHeight;

//      gl.viewport(0, 0, gl.drawingBufferWidth.toInt(), gl.drawingBufferHeight.toInt());
      gl.viewport(0, 0, gl.canvas.width, gl.canvas.height);
      ctxWrapper.Context.mainCamera?.update();
    }
  }

  Future render() async {
    //debug.logCurrentFunction();

    await ShaderSource.loadShaders();
    //> Init extensions
    //This activate extensions
    var hasSRGBExt = gl.getExtension('EXT_SRGB');
    var hasLODExtension = gl.getExtension('EXT_shader_texture_lod');
    var hasDerivativesExtension = gl.getExtension('OES_standard_derivatives');

    globalState = new GlobalState()
      ..scene = null
      ..hasLODExtension =hasLODExtension
      ..hasDerivativesExtension = hasDerivativesExtension
      ..sRGBifAvailable =
      hasSRGBExt != null ? webgl.EXTsRgb.SRGB_EXT : webgl.RGBA;

    await _initTextures();
    setupCameras();

    setupGLState();

    resizeCanvas();
    _render();
  }

  Future _initTextures() async {
    //debug.logCurrentFunction();

    ImageElement imageElement;
    ///TextureFilterType magFilter;
    int magFilter;
    /// TextureFilterType minFilter;
    int minFilter;
    /// TextureWrapType wrapS;
    int wrapS;
    /// TextureWrapType wrapT;
    int wrapT;

    //brdfLUT
    imageElement = await TextureUtils.loadImage('packages/webgl/images/utils/brdfLUT.png');
    magFilter = TextureFilterType.LINEAR;
    minFilter = TextureFilterType.LINEAR;
    wrapS = TextureWrapType.REPEAT;
    wrapT = TextureWrapType.REPEAT;
    brdfLUTTexture = new WebGLTexture.fromWebGL(createImageTexture(TextureUnit.TEXTURE0 + 0, imageElement, magFilter, minFilter, wrapS, wrapT), TextureTarget.TEXTURE_2D);

    //Environnement
    gl.activeTexture(TextureUnit.TEXTURE0 + 1);
    List<List<ImageElement>> papermill_diffuse =
        await TextureUtils.loadCubeMapImages('papermill_diffuse', webPath: 'packages/webgl/');
    cubeMapTextureDiffuse = TextureUtils.createCubeMapWithImages(papermill_diffuse, flip: false); //, textureInternalFormat: globalState.sRGBifAvailable
    gl.bindTexture(TextureTarget.TEXTURE_CUBE_MAP, cubeMapTextureDiffuse.webGLTexture);

    gl.activeTexture(TextureUnit.TEXTURE0 + 2);
    List<List<ImageElement>> papermill_specular =
        await TextureUtils.loadCubeMapImages('papermill_specular', webPath: 'packages/webgl/');
    cubeMapTextureSpecular = TextureUtils.createCubeMapWithImages(papermill_specular, flip: false); //, textureInternalFormat: globalState.sRGBifAvailable
    gl.bindTexture(TextureTarget.TEXTURE_CUBE_MAP, cubeMapTextureSpecular.webGLTexture);

    skipTexture = 3;

    bool useDebugTexture = false;
    for (int i = 0; i < globalGltf.textures.length; i++) {
      int textureUnitId = 0;

      GLTFTexture gltfTexture;
      if (!useDebugTexture) {
        gltfTexture = globalGltf.textures[i];
        if (gltfTexture.source.data == null) {
          //load image
          String fileUrl =
              globalGltf.baseDirectory + gltfTexture.source.uri.toString();
          imageElement = await TextureUtils.loadImage(fileUrl);
          textureUnitId = gltfTexture.textureId;
        } else {
          String base64Encoded = BASE64.encode(gltfTexture.source.data);
          imageElement = new ImageElement(
              src: "data:${gltfTexture.source.mimeType};base64,$base64Encoded");
        }

        magFilter = gltfTexture.sampler != null
            ? gltfTexture.sampler.magFilter
            : TextureFilterType.LINEAR;
        minFilter = gltfTexture.sampler != null
            ? gltfTexture.sampler.minFilter
            : TextureFilterType.LINEAR;
        wrapS = gltfTexture.sampler != null
            ? gltfTexture.sampler.wrapS
            : TextureWrapType.REPEAT;
        wrapT = gltfTexture.sampler != null
            ? gltfTexture.sampler.wrapT
            : TextureWrapType.REPEAT;
      } else {
//        String imagePath = '/images/utils/uv.png';
        String imagePath = '/images/utils/uv_grid.png';
//      String imagePath = '/images/crate.gif';
//      String imagePath = '/gltf/samples/gltf_2_0/BoxTextured/CesiumLogoFlat.png';
//      String imagePath = '/gltf/samples/gltf_2_0/BoxTextured/CesiumLogoFlat_256.png';
        imageElement = await TextureUtils.loadImage(imagePath);

        magFilter = TextureFilterType.LINEAR;
        minFilter = TextureFilterType.LINEAR;
        wrapS = TextureWrapType.CLAMP_TO_EDGE;
        wrapT = TextureWrapType.CLAMP_TO_EDGE;
      }

      //create model texture
      webgl.Texture texture = createImageTexture(TextureUnit.TEXTURE0 + textureUnitId + skipTexture, imageElement, magFilter, minFilter, wrapS, wrapT);
      if(gltfTexture != null){
        gltfTexture.webglTexture = texture;
      }
    }
  }

  webgl.Texture createImageTexture(int textureUnitId, ImageElement imageElement, int magFilter, int minFilter, int wrapS, int wrapT) {
    //debug.logCurrentFunction();

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

  num currentTime = 0;
  num deltaTime = 0;
  num timeFps = 0;
  int fps = 0;
  num speedFactor = 1.0;
  void _render({num time: 0.0}) {
    //debug.logCurrentFunction(
//        '\n------------------------------------------------');

    deltaTime = time - currentTime;
    timeFps += deltaTime;
    fps++;
    currentTime = time * speedFactor;

    if (fps >= 1000) {
      timeFps = 0;
      fps = 0;
    }

    try {
      update();
      draw();
    } catch (ex) {
      print("Error: $ex");
    }

    window.requestAnimationFrame((num time) {
      this._render(time: time);
    });
  }

  void draw() {
    //debug.logCurrentFunction();

    gl.clear(
        ClearBufferMask.COLOR_BUFFER_BIT | ClearBufferMask.DEPTH_BUFFER_BIT);

    drawNodes(activeScene.nodes);
  }

  void drawNodes(List<GLTFNode> nodes) {
    //debug.logCurrentFunction();
    for (int i = 0; i < nodes.length; i++) {
      GLTFNode node = nodes[i];
      if (node.mesh != null) {

        node.programSetting ??= new ProgramSetting(node);
        node.programSetting.drawPrimitives();
      }
      drawNodes(node.children);
    }
  }

  void setupGLState() {
    //debug.logCurrentFunction();

    gl.enable(webgl.DEPTH_TEST);
    gl.clearColor(.2, 0.2, 0.2, 1.0);

//    gl.frontFace(FrontFaceDirection.CCW);
//
//    //Enable depth test
//
//    gl.depthFunc(webgl.LESS);
//    //gl.enable(webgl.BLEND);
//    gl.disable(webgl.CULL_FACE);
//    //
//    gl.cullFace(FacingType.FRONT);
  }

  void setupCameras() {
    //debug.logCurrentFunction();

    Camera currentCamera;

    bool debugCamera = true;

    if(debugCamera){
      currentCamera = new CameraPerspective(radians(47.0), 0.1, 1000.0)
        ..targetPosition = new Vector3(0.0, 0.0, 0.0)
        ..position = new Vector3(10.0, 10.0, 10.0);
    }else {
      //find first activeScene camera
      currentCamera = findActiveSceneCamera(activeScene.nodes);
      //or use first in project else default
      if (currentCamera == null) {
        currentCamera = findActiveSceneCamera(globalGltf.nodes);
      }
      if (currentCamera == null) {
        if (globalGltf.cameras.length > 0) {
          currentCamera = globalGltf.cameras[0];
        } else {
          currentCamera = new CameraPerspective(radians(47.0), 0.1, 100.0)
            ..targetPosition = new Vector3(0.0, 0.03, 0.0);
//          ..targetPosition = new Vector3(0.0, .03, 0.0);//Avocado
        }
        currentCamera.position = new Vector3(5.0, 5.0, 10.0);
//      currentCamera.position = new Vector3(.5, 0.0, 0.2);//Avocado
      }
    }
    //>
    if (currentCamera is CameraPerspective) {
      ctxWrapper.Context.mainCamera = currentCamera;
    } else {
      // ortho ?
    }
  }

  Camera findActiveSceneCamera(List<GLTFNode> nodes) {

    //debug.logCurrentFunction();

    Camera result;

    for (var i = 0; i < nodes.length && result == null; i++) {
      GLTFNode node = nodes[i];
      if (node.camera != null) {
        setupNodeCamera(node);
        result = node.camera;
      }
    }

    return result;
  }

  void setupNodeCamera(GLTFNode node) {
    //debug.logCurrentFunction();

    CameraPerspective camera = node.camera as CameraPerspective;
    camera.position = node.translation;
  }

  void update() {
    //debug.logCurrentFunction();

    interaction.update();

    for (int i = 0; i < gltfProject.animations.length; i++) {
      GLTFAnimation animation = gltfProject.animations[i];
      for (int j = 0; i < animation.channels.length; i++) {
        GLTFAnimationChannel channel = animation.channels[j];

        ByteBuffer byteBuffer = getNextInterpolatedValues(channel.sampler);
        channel.target.node.rotation = new Quaternion.fromBuffer(byteBuffer, 0);
      }
    }
  }

  ByteBuffer getNextInterpolatedValues(GLTFAnimationSampler sampler) {
    //debug.logCurrentFunction();

    Float32List keyTimes = getKeyTimes(sampler.input);
    Float32List keyValues = getKeyValues(sampler.output);

    num playTime =
        (currentTime / 1000) % keyTimes.last; // Todo (jpu) : find less cost ?

    //> playtime range
    int previousIndex = 0;
    double previousTime = 0.0;
    while (keyTimes[previousIndex] < playTime) {
      previousTime = keyTimes[previousIndex];
      previousIndex++;
    }
    previousIndex--;

    int nextIndex = (previousIndex + 1) % keyTimes.length;
    double nextTime = keyTimes[nextIndex];

    //> values
    Float32List previousValues = keyValues.buffer.asFloat32List(
        sampler.output.byteOffset +
            previousIndex *
                sampler.output.components *
                sampler.output.componentLength,
        sampler.output.components);
    Float32List nextValues = keyValues.buffer.asFloat32List(
        sampler.output.byteOffset +
            nextIndex *
                sampler.output.components *
                sampler.output.componentLength,
        sampler.output.components);

    double interpolationValue =
        (playTime - previousTime) / (nextTime - previousTime);

    // Todo (jpu) : add easer ratio interpolation

    Quaternion result = getQuaternionInterpolation(
        previousValues,
        nextValues,
        interpolationValue,
        previousIndex,
        previousTime,
        playTime,
        nextIndex,
        nextTime);

    return result.storage.buffer;
  }

  Quaternion getQuaternionInterpolation(
      Float32List previousValues,
      Float32List nextValues,
      double interpolationValue,
      int previousIndex,
      double previousTime,
      num playTime,
      int nextIndex,
      double nextTime) {
    //debug.logCurrentFunction();

    Quaternion previous = new Quaternion.fromFloat32List(previousValues);
    Quaternion next = new Quaternion.fromFloat32List(nextValues);

    //
    double angle = next.radians - previous.radians;
    if (angle.abs() > PI) {
      next[3] *= -1;
    }

    Quaternion result = slerp(previous, next, interpolationValue);

    //debug.logCurrentFunction('interpolationValue : $interpolationValue');
    //debug.logCurrentFunction(
//        'previous : $previousIndex > ${previousTime.toStringAsFixed(3)} \t: ${degrees(previous.radians).toStringAsFixed(3)} ${previousTime.toStringAsFixed(3)} \t| $previous');
    //debug.logCurrentFunction(
//        'result   : - > ${playTime.toStringAsFixed(3)} \t: ${degrees(result.radians).toStringAsFixed(3)} ${playTime.toStringAsFixed(3)} \t| $result');
    //debug.logCurrentFunction(
//        'next     : $nextIndex > ${nextTime.toStringAsFixed(3)} \t: ${degrees(next.radians).toStringAsFixed(3)} ${nextTime.toStringAsFixed(3)} \t| $next');
    //debug.logCurrentFunction('');

    return result;
  }

  Float32List getInterpolatedValues(Float32List previousValues,
      Float32List nextValues, num interpolationValue) {
    //debug.logCurrentFunction();

    Float32List result = new Float32List(previousValues.length);

    for (int i = 0; i < previousValues.length; i++) {
      result[i] = previousValues[i] +
          interpolationValue * (nextValues[i] - previousValues[i]);
    }
    return result;
  }

  Quaternion slerp(Quaternion qa, Quaternion qb, double t) {
    //debug.logCurrentFunction();

    // quaternion to return
    Quaternion qm = new Quaternion.identity();

    // Calculate angle between them.
    double cosHalfTheta = qa.w * qb.w + qa.x * qb.x + qa.y * qb.y + qa.z * qb.z;

    // if qa=qb or qa=-qb then theta = 0 and we can return qa
    if (cosHalfTheta.abs() >= 1.0) {
      qm.w = qa.w;
      qm.x = qa.x;
      qm.y = qa.y;
      qm.z = qa.z;
      return qm;
    }

    // Calculate temporary values.
    double halfTheta = acos(cosHalfTheta);
    double sinHalfTheta = sqrt(1.0 - cosHalfTheta * cosHalfTheta);

    // if theta = 180 degrees then result is not fully defined
    // we could rotate around any axis normal to qa or qb
    if (sinHalfTheta.abs() < 0.001) {
      qm.w = (qa.w * 0.5 + qb.w * 0.5);
      qm.x = (qa.x * 0.5 + qb.x * 0.5);
      qm.y = (qa.y * 0.5 + qb.y * 0.5);
      qm.z = (qa.z * 0.5 + qb.z * 0.5);
      return qm;
    }
    double ratioA = sin((1 - t) * halfTheta) / sinHalfTheta;
    double ratioB = sin(t * halfTheta) / sinHalfTheta;

    //calculate Quaternion.
    qm.w = (qa.w * ratioA + qb.w * ratioB);
    qm.x = (qa.x * ratioA + qb.x * ratioB);
    qm.y = (qa.y * ratioA + qb.y * ratioB);
    qm.z = (qa.z * ratioA + qb.z * ratioB);

    return qm;
  }

  Float32List getKeyTimes(GLTFAccessor accessor) {
    //debug.logCurrentFunction();

    Float32List keyTimes = accessor.bufferView.buffer.data.buffer.asFloat32List(
        accessor.byteOffset, accessor.count * accessor.components);
    return keyTimes;
  }

  // Todo (jpu) : try to return only buffer
  Float32List getKeyValues(GLTFAccessor accessor) {
    //debug.logCurrentFunction();

    Float32List keyValues = accessor.bufferView.buffer.data.buffer
        .asFloat32List(
            accessor.byteOffset, accessor.count * accessor.components);
    return keyValues;
  }
}