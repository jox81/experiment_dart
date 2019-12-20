import 'dart:html';
import 'dart:typed_data' as WebGlTypedData;
import 'dart:web_gl' as WebGL;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/engine/engine.dart';
import 'package:webgl/src/render_setting.dart';
import 'package:webgl/src/utils/utils_debug.dart';
import 'package:webgl/src/introspection/introspection.dart';
import 'package:webgl/src/webgl_objects/active_framebuffer.dart';
import 'package:webgl/src/webgl_objects/context_attributs.dart';
import 'package:webgl/src/webgl_objects/webgl_active_texture.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_constants.dart';
import 'package:webgl/src/webgl_objects/webgl_parameters.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_renderbuffer.dart';

//@reflector
class WebGLRenderingContext{

  WebGL.RenderingContext gl;

  CanvasElement get canvas => gl.canvas;
  WebglConstants get webglConstants => WebglConstants.instance();
  WebglParameters get webglParameters => WebglParameters.instance();

  RenderSetting _renderSetting;
  RenderSetting get renderSettings {
    if(_renderSetting == null){
      _renderSetting = new RenderSetting(this);
    }
    return _renderSetting;
  }

  num get width => gl.drawingBufferWidth;
  num get height => gl.drawingBufferHeight;

  double get viewAspectRatio {
    if(gl != null) {
      return width / height;
    }
    return 1.0;
  }

  factory WebGLRenderingContext.fromWebGL(WebGL.RenderingContext gl){
    return new WebGLRenderingContext._init(gl);
  }

  //Todo add default parameters
  factory WebGLRenderingContext.create(CanvasElement canvas, {bool enableExtensions:false, bool initConstant : false, bool logInfos : false, bool preserveDrawingBuffer:false}){
    WebGL.RenderingContext gl;

    List<String> names = [
      "webgl",
      "experimental-webgl",
      "webkit-3d",
      "moz-webgl"
    ];
    var options = {
      'preserveDrawingBuffer': preserveDrawingBuffer,
    };

    for (int i = 0; i < names.length; i++) {
      try {
        gl = canvas.getContext(names[i], options) as WebGL.RenderingContext; //Normal context
      } catch (e) {}
      if (gl != null) {
        break;
      }
    }
    if (gl == null) {
      window.alert("Could not initialise WebGL");
      return null;
    }

    return new WebGLRenderingContext._init(gl, enableExtensions:enableExtensions, initConstant:initConstant, logInfos:logInfos);
  }

  WebGLRenderingContext._init(this.gl, {bool enableExtensions:false, bool initConstant : false, bool logInfos : false}){
    if(initConstant) {
      webglConstants.initWebglConstants();
    }

    if(enableExtensions){
      renderSettings.enableExtensions(log: logInfos);
    }

    if(logInfos) {
      _logInfos();
    }

    clear(ClearBufferMask.COLOR_BUFFER_BIT);
    frontFace = FrontFaceDirection.CCW;

    renderSettings.enableDepth(true);
    renderSettings.showBackFace(true);
    renderSettings.enableExtensions();
  }

  void _logInfos() {
    contextAttributes.logValues();
    renderSettings.logSupportedExtensions();
    webglConstants.logConstants();
    webglConstants.logParameters();
    webglParameters.logValues();
    webglParameters.testGetParameter();
  }

  void resizeCanvas() {
    var realToCSSPixels = 1.0;//window.devicePixelRatio;

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
      viewport = new Rectangle(0, 0, gl.canvas.width, gl.canvas.height);
      Engine.mainCamera?.update();
    }
  }

  // >>> Parameteres
  /// ContextParameter parameter
  dynamic getParameter(int parameter){
    dynamic result =  gl.getParameter(parameter);
    return result;
  }

  ContextAttributs get contextAttributes => new ContextAttributs(gl.getContextAttributes());

  //
  bool get isContextLost => gl.isContextLost();

  ActiveTexture get activeTexture => ActiveTexture.instance;
  ActiveFrameBuffer get activeFrameBuffer => ActiveFrameBuffer.instance;

  // >>> single getParameter

  // > VENDOR
  String get vendor => gl.getParameter(ContextParameter.VENDOR) as String;
  // > RENDERER
  String get renderer => gl.getParameter(ContextParameter.RENDERER) as String;
  // > VERSION
  String get version => gl.getParameter(ContextParameter.VERSION) as String;
  // > SHADING_LANGUAGE_VERSION
  String get shadingLanguageVersion => gl.getParameter(ContextParameter.SHADING_LANGUAGE_VERSION) as String;

  num get drawingBufferWidth => gl.drawingBufferWidth;
  num get drawingBufferHeight => gl.drawingBufferHeight;

  // > MAX_VIEWPORT_DIMS
  WebGlTypedData.Int32List get maxViewportDimensions => gl.getParameter(ContextParameter.MAX_VIEWPORT_DIMS) as WebGlTypedData.Int32List;

  // > VIEWPORT
  Rectangle<int> get viewport {
    WebGlTypedData.Int32List values = gl.getParameter(ContextParameter.VIEWPORT) as WebGlTypedData.Int32List;
    return new Rectangle<int>(values[0], values[1], values[2], values[3]);
  }
  set viewport(Rectangle<int> rect) {
    //int x, int y, num width, num height
    assert(rect.width >= 0 && rect.height >= 0);
    gl.viewport(rect.left, rect.top, rect.width, rect.height);
  }


  // > ALIASED_LINE_WIDTH_RANGE [2]
  WebGlTypedData.Float32List get aliasedLineWidthRange => gl.getParameter(ContextParameter.ALIASED_LINE_WIDTH_RANGE) as WebGlTypedData.Float32List;

  // > ALIASED_POINT_SIZE_RANGE [2]
  WebGlTypedData.Float32List get aliasedPointSizeRange => gl.getParameter(ContextParameter.ALIASED_POINT_SIZE_RANGE) as WebGlTypedData.Float32List;

  // > RED_BITS
  int get redBits => gl.getParameter(ContextParameter.RED_BITS) as int;
  // > GREEN_BITS
  int get greenBits => gl.getParameter(ContextParameter.GREEN_BITS) as int;
  // > BLUE_BITS
  int get blueBits => gl.getParameter(ContextParameter.BLUE_BITS) as int;
  // > ALPHA_BITS
  int get alphaBits => gl.getParameter(ContextParameter.ALPHA_BITS) as int;
  // > DEPTH_BITS
  int get depthBits => gl.getParameter(ContextParameter.DEPTH_BITS) as int;
  // > STENCIL_BITS
  int get stencilBits => gl.getParameter(ContextParameter.STENCIL_BITS) as int;
  // > SUBPIXEL_BITS
  int get subPixelBits => gl.getParameter(ContextParameter.SUBPIXEL_BITS) as int;

  // > COLOR_CLEAR_VALUE [4]
  Vector4 get clearColor => new Vector4.fromFloat32List(gl.getParameter(ContextParameter.COLOR_CLEAR_VALUE) as WebGlTypedData.Float32List);
  set clearColor(Vector4 color) => gl.clearColor(color.r, color.g, color.b, color.a);

  // > COLOR_WRITEMASK [4]
  List<bool> get colorMask => gl.getParameter(ContextParameter.COLOR_WRITEMASK) as List<bool>;
  set colorMask(List<bool> mask){
    assert(mask.length == 4);
    gl.colorMask(mask[0], mask[1], mask[2], mask[3]);
  }

  // > COMPRESSED_TEXTURE_FORMATS [4]
  WebGlTypedData.Uint32List get compressTextureFormats => gl.getParameter(ContextParameter.COMPRESSED_TEXTURE_FORMATS) as WebGlTypedData.Uint32List;

  // > CURRENT_PROGRAM
  WebGLProgram get currentProgram => new WebGLProgram.fromWebGL(gl.getParameter(ContextParameter.CURRENT_PROGRAM) as WebGL.Program);

  // > ARRAY_BUFFER_BINDING
  WebGLBuffer get arrayBufferBinding => new WebGLBuffer.fromWebGL(gl.getParameter(ContextParameter.ARRAY_BUFFER_BINDING)as WebGL.Buffer);
  // > ELEMENT_ARRAY_BUFFER_BINDING
  WebGLBuffer get elementArrayBufferBinding => new WebGLBuffer.fromWebGL(gl.getParameter(ContextParameter.ELEMENT_ARRAY_BUFFER_BINDING) as WebGL.Buffer);
  // > RENDERBUFFER_BINDING
  WebGLRenderBuffer get renderBufferBinding => new WebGLRenderBuffer.fromWebGL(gl.getParameter(ContextParameter.RENDERBUFFER_BINDING) as WebGL.Renderbuffer);

  // > MAX_VERTEX_TEXTURE_IMAGE_UNITS
  int get maxVertexTextureImageUnits => gl.getParameter(ContextParameter.MAX_VERTEX_TEXTURE_IMAGE_UNITS) as int;
  // > MAX_VERTEX_ATTRIBS
  int get maxVertexAttributs => gl.getParameter(ContextParameter.MAX_VERTEX_ATTRIBS) as int;
  // > MAX_VERTEX_UNIFORM_VECTORS
  int get maxVertexUnifromVectors => gl.getParameter(ContextParameter.MAX_VERTEX_UNIFORM_VECTORS) as int;
  // > MAX_VARYING_VECTORS
  int get maxVaryingVectors => gl.getParameter(ContextParameter.MAX_VARYING_VECTORS) as int;
  // > MAX_FRAGMENT_UNIFORM_VECTORS
  int get maxFragmentUnifromVectors => gl.getParameter(ContextParameter.MAX_FRAGMENT_UNIFORM_VECTORS) as int;
  // > MAX_RENDERBUFFER_SIZE
  int get maxRenderBufferSize => gl.getParameter(ContextParameter.MAX_RENDERBUFFER_SIZE) as int;


  // > SAMPLES
  int get samples => gl.getParameter(ContextParameter.SAMPLES) as int;
  // > SAMPLE_BUFFERS
  int get sampleBuffers => gl.getParameter(ContextParameter.SAMPLE_BUFFERS) as int;


  // >> pixelStorei

  // > PACK_ALIGNMENT
  int get packAlignment => gl.getParameter(ContextParameter.PACK_ALIGNMENT) as int;
  // > UNPACK_ALIGNMENT
  int get unpackAlignment => gl.getParameter(ContextParameter.UNPACK_ALIGNMENT) as int;
  // > UNPACK_FLIP_Y_WEBGL
  bool get unpackFlipYWebGL => gl.getParameter(ContextParameter.UNPACK_FLIP_Y_WEBGL) as bool;
  // > UNPACK_PREMULTIPLY_ALPHA_WEBGL
  bool get unpackPreMultiplyAlphaWebGL => gl.getParameter(ContextParameter.UNPACK_PREMULTIPLY_ALPHA_WEBGL) as bool;
  // > UNPACK_COLORSPACE_CONVERSION_WEBGL
  /// PixelStorgeType get unpackColorSpaceConversionWebGL
  int get unpackColorSpaceConversionWebGL => gl.getParameter(ContextParameter.UNPACK_COLORSPACE_CONVERSION_WEBGL) as int;

  /// PixelStorgeType storage
  void pixelStorei(int storage, int value) => gl.pixelStorei(storage, value);


  // >>

  // > IMPLEMENTATION_COLOR_READ_FORMAT // Todo : GLenum ?
  int get implementationColorReadFormat => gl.getParameter(ContextParameter.IMPLEMENTATION_COLOR_READ_FORMAT) as int;
  // > IMPLEMENTATION_COLOR_READ_TYPE // Todo : GLenum ?
  int get implementationColorReadType => gl.getParameter(ContextParameter.IMPLEMENTATION_COLOR_READ_TYPE) as int;

  // > LINE_WIDTH
  num get lineWidth => gl.getParameter(ContextParameter.LINE_WIDTH) as num;
  set lineWidth(num width) => gl.lineWidth(width);


  //>>>


  //Enagling CullFace
  // > CULL_FACE //Todo : ? identique à get parameter ? BLEND
  bool get cullFaceEnabled => isEnabled(EnableCapabilityType.CULL_FACE);
  set cullFaceEnabled(bool enable) => _setEnabled(EnableCapabilityType.CULL_FACE, enable);

  // > CULL_FACE_MODE
  /// FacingType get getCullFace
  int get getCullFace => gl.getParameter(ContextParameter.CULL_FACE_MODE)as int;
  void cullFace(int mode) {
    gl.cullFace(mode);
  }

  // > FRONT_FACE
  /// FrontFaceDirection get frontFace
  int get frontFace => gl.getParameter(ContextParameter.FRONT_FACE)as int;
  set frontFace(int mode) => gl.frontFace(mode);

  //Depth
  // > DEPTH_TEST
  bool get depthTestEnabled => gl.isEnabled(EnableCapabilityType.DEPTH_TEST);
  set depthTestEnabled(bool enable) => _setEnabled(EnableCapabilityType.DEPTH_TEST, enable);

  // > DEPTH_WRITEMASK
  bool get depthMask => gl.getParameter(ContextParameter.DEPTH_WRITEMASK) as bool;
  set depthMask(bool enable) => gl.depthMask(enable);

  // > DEPTH_FUNC
  /// ComparisonFunction get depthFunc
  int get depthFunc => gl.getParameter(ContextParameter.DEPTH_FUNC) as int;
  set depthFunc(int depthComparisionFunction) => gl.depthFunc(depthComparisionFunction);

  // > DEPTH_RANGE [2]
  WebGlTypedData.Float32List getDepthRange() => gl.getParameter(ContextParameter.DEPTH_RANGE) as WebGlTypedData.Float32List;
  void setDepthRange(num zNear, num zFar) => gl.depthRange(zNear, zFar);

  // > DEPTH_CLEAR_VALUE
  num get clearDepth => gl.getParameter(ContextParameter.DEPTH_CLEAR_VALUE) as num;
  set clearDepth(num depthValue){
    assert(0.0 <= depthValue && depthValue <= 1.0);
    gl.clearDepth(depthValue);
  }

  //Scissor

  // > SCISSOR_TEST
  bool get scissorTest => isEnabled(EnableCapabilityType.SCISSOR_TEST);
  set scissorTest(bool enabled) => _setEnabled(EnableCapabilityType.SCISSOR_TEST, enabled);


  // > SCISSOR_BOX
  Rectangle<int> get scissor {
    WebGlTypedData.Int32List values = gl.getParameter(ContextParameter.SCISSOR_BOX) as WebGlTypedData.Int32List;
    return new Rectangle(values[0], values[1], values[2], values[3]);
  }
  set scissor(Rectangle<int> rect) {
    //int x, int y, num width, num height
    assert(rect.width >= 0 && rect.height >= 0);
    gl.scissor(rect.left, rect.top, rect.width, rect.height);
  }

  //Polygon offset
  // > POLYGON_OFFSET_FILL
  bool get polygonOffset => gl.isEnabled(EnableCapabilityType.POLYGON_OFFSET_FILL);
  set polygonOffset(bool enabled) =>_setEnabled(EnableCapabilityType.POLYGON_OFFSET_FILL, enabled);

  // > POLYGON_OFFSET_FACTOR
  num get polygonOffsetFactor => gl.getParameter(ContextParameter.POLYGON_OFFSET_FACTOR) as num;
  // > POLYGON_OFFSET_UNITS
  num get polygonOffsetUnits => gl.getParameter(ContextParameter.POLYGON_OFFSET_UNITS) as num;

  void setPolygonOffest(num factor, num units){
    gl.polygonOffset(factor, units);
  }

  //MultiSampleCoverage
  bool get sampleCovarage => isEnabled(EnableCapabilityType.SAMPLE_COVERAGE);
  set sampleCoverage(bool enabled) => _setEnabled(EnableCapabilityType.SAMPLE_COVERAGE, enabled);

  bool get sampleAlphaToCoverage => isEnabled(EnableCapabilityType.SAMPLE_ALPHA_TO_COVERAGE);
  set sampleAlphaToCoverage(bool enabled) => _setEnabled(EnableCapabilityType.SAMPLE_ALPHA_TO_COVERAGE, enabled);

  // > SAMPLE_COVERAGE_VALUE
  num get sampleCoverageValue => gl.getParameter(ContextParameter.SAMPLE_COVERAGE_VALUE) as num;
  // > SAMPLE_COVERAGE_INVERT
  bool get sampleCoverageInvert => gl.getParameter(ContextParameter.SAMPLE_COVERAGE_INVERT) as bool;
  void setSampleCoverage(num value, bool invert) => gl.sampleCoverage(value, invert);

  //Stencils
  /// FacingType faceType
  /// ComparisonFunction comparisonFunction
  void stencilFuncSeparate(int faceType, int comparisonFunction, int ref, int mask){
    gl.stencilFuncSeparate(faceType, comparisonFunction, ref, mask);
  }
  /// FacingType faceType
  void stencilMaskSeparate(int faceType, int mask){
    gl.stencilMaskSeparate(faceType, mask);
  }
  /// StencilOpMode fail
  /// StencilOpMode zFail
  /// StencilOpMode zPass
  void stencilOp(int fail, int zFail, int zPass){
    gl.stencilOp(fail, zFail, zPass);
  }
  /// FacingType faceType
  /// StencilOpMode fail
  /// StencilOpMode zFail
  /// StencilOpMode zPass
  void stencilOpSeparate(int faceType, int fail, int zFail, int zPass){
    gl.stencilOpSeparate(faceType, fail, zFail, zPass);
  }

  // > STENCIL_TEST //Todo : ? identique à get parameter ? STENCIL_TEST
  bool get stencilTest => isEnabled(EnableCapabilityType.STENCIL_TEST);
  set stencilTest (bool enabled) => _setEnabled(EnableCapabilityType.STENCIL_TEST, enabled);

  // > STENCIL_FUNC
  /// ComparisonFunction get stencilFunc
  int get stencilFunc => gl.getParameter(ContextParameter.STENCIL_FUNC)as int;
  // > STENCIL_BACK_FUNC
  int get stencilBackFunc => gl.getParameter(ContextParameter.STENCIL_BACK_FUNC) as int;
  void setStencilFunc(int comparisonFunction, int ref, int mask){
    gl.stencilFunc(comparisonFunction, ref, mask);
  }

  // > STENCIL_VALUE_MASK
  int get stencilValueMask => gl.getParameter(ContextParameter.STENCIL_VALUE_MASK) as int;
  // > STENCIL_WRITEMASK
  int get stencilWriteMask => gl.getParameter(ContextParameter.STENCIL_WRITEMASK) as int;
  // > STENCIL_BACK_WRITEMASK
  int get stencilBackWriteMask => gl.getParameter(ContextParameter.STENCIL_BACK_WRITEMASK) as int;
  set stencilMaks(int value) => gl.stencilMask(value);

  // > STENCIL_REF
  int get stencilRef => gl.getParameter(ContextParameter.STENCIL_REF) as int;
  // > STENCIL_BACK_REF
  int get stencilBackRef => gl.getParameter(ContextParameter.STENCIL_BACK_REF) as int;
  // > STENCIL_BACK_VALUE_MASK
  int get stencilBackValueMask => gl.getParameter(ContextParameter.STENCIL_BACK_VALUE_MASK)as int;

  // > STENCIL_CLEAR_VALUE
  int get clearStencil => gl.getParameter(ContextParameter.STENCIL_CLEAR_VALUE)as int;
  set clearStencil(int index) => gl.clearStencil(index);

  // > STENCIL_FAIL
  ///StencilOpMode get stencilFail
  int get stencilFail => gl.getParameter(ContextParameter.STENCIL_FAIL) as int;
  // > STENCIL_PASS_DEPTH_PASS
  int get stencilPassDepthPass => gl.getParameter(ContextParameter.STENCIL_PASS_DEPTH_PASS) as int;
  // > STENCIL_PASS_DEPTH_FAIL
  int get stencilPassDepthFail => gl.getParameter(ContextParameter.STENCIL_PASS_DEPTH_FAIL) as int;
  // > STENCIL_BACK_FAIL
  int get stencilBackFail => gl.getParameter(ContextParameter.STENCIL_BACK_FAIL) as int;
  // > STENCIL_BACK_PASS_DEPTH_PASS
  int get stencilBackPassDepthPass => gl.getParameter(ContextParameter.STENCIL_BACK_PASS_DEPTH_PASS) as int;
  // > STENCIL_BACK_PASS_DEPTH_FAIL
  int get stencilBackPassDepthFail => gl.getParameter(ContextParameter.STENCIL_BACK_PASS_DEPTH_FAIL) as int;

  //Blend
  //Todo : ? identique à get parameter ? BLEND
  bool get blend => isEnabled(EnableCapabilityType.BLEND);
  set blend (bool enabled) => _setEnabled(EnableCapabilityType.BLEND, enabled);

  /// BlendFactorMode sourceFactor
  /// BlendFactorMode destinationFactor
  void blendFunc(int sourceFactor, int destinationFactor){
    gl.blendFunc(sourceFactor, destinationFactor);
  }
  /// BlendFactorMode srcRGB
  /// BlendFactorMode dstRGB
  /// BlendFactorMode srcAlpha
  /// BlendFactorMode dstAlpha
  void blendFuncSeparate(int srcRGB, int dstRGB, int srcAlpha, int dstAlpha){
    gl.blendFuncSeparate(srcRGB, dstRGB, srcAlpha, dstAlpha);
  }
  void setBlendColor(num red, num green, num blue, num alpha){
    assert(0.0 <= red && red <= 1.0);
    assert(0.0 <= green && green <= 1.0);
    assert(0.0 <= blue && blue <= 1.0);
    assert(0.0 <= alpha && alpha <= 1.0);
    gl.blendColor(red, green, blue, alpha);
  }
  // > BLEND_COLOR
  WebGlTypedData.Float32List get blendColor => gl.getParameter(ContextParameter.BLEND_COLOR)as WebGlTypedData.Float32List;
  set blendColor(WebGlTypedData.Float32List values){
    assert(values.length == 4);
    setBlendColor(values[0], values[1], values[2], values[3]);
  }
  // > BLEND_SRC_RGB, BLEND_DST_RGB, BLEND_SRC_ALPHA, BLEND_DST_ALPHA
  /// BlendFactorMode get blendSrcRGB
  int get blendSrcRGB => gl.getParameter(ContextParameter.BLEND_SRC_RGB)as int;
  int get blendSrcAlpha => gl.getParameter(ContextParameter.BLEND_SRC_ALPHA)as int;
  int get blendDstRGB => gl.getParameter(ContextParameter.BLEND_DST_RGB)as int;
  int get blendDstAlpha => gl.getParameter(ContextParameter.BLEND_DST_ALPHA)as int;

  // > BLEND_EQUATION, BLEND_EQUATION_RGB, BLEND_EQUATION_ALPHA
  
  /// BlendFunctionMode get blendEquation
  int get blendEquation => gl.getParameter(ContextParameter.BLEND_EQUATION)as int;
  int get blendEquationRGB => gl.getParameter(ContextParameter.BLEND_EQUATION_RGB)as int;
  int get blendEquationAlpha => gl.getParameter(ContextParameter.BLEND_EQUATION_ALPHA )as int;
  set blendEquation(int mode) => gl.blendEquation(mode);

  /// BlendFunctionMode modeRGB
  /// BlendFunctionMode modeAlpha
  void blendEquationSeparate(int modeRGB, int modeAlpha){
    gl.blendEquationSeparate(modeRGB, modeAlpha);
  }

  //Dither
  // > DITHER
  bool get dither => isEnabled(EnableCapabilityType.DITHER);
  set dither (bool enabled) => _setEnabled(EnableCapabilityType.DITHER, enabled);

  /////

  //EnableCapabilityType enabling
  /// EnableCapabilityType cap
  void enable(int cap) {
    gl.enable(cap);
  }
  void disable(int cap) {
    gl.disable(cap);
  }
  void _setEnabled(int enableCapType, bool enabled){
    if(enabled){
      enable(enableCapType);
    } else {
      disable(enableCapType);
    }
  }

  /// EnableCapabilityType cap
  bool isEnabled(int cap) {
    return gl.isEnabled(cap);
  }


  // Buffers
  /// BufferType bufferType
  void bindBuffer(int bufferType, WebGLBuffer webglBuffer) {
    gl.bindBuffer(bufferType, webglBuffer?.webGLBuffer);
  }

  /// BufferType bufferType
  /// BufferUsageType usageType
  void bufferData(int bufferType,
      WebGlTypedData.TypedData typedData, int usageType) {
    gl.bufferData(bufferType, typedData, usageType);
  }

  /// BufferType bufferType
  /// BufferUsageType usageType
  void bufferDataWithSize(int bufferType, int size,
      WebGLBuffer webglBuffer, int usageType) {
    assert(size != null);
    gl.bufferData(bufferType, size, usageType);
  }

  /// BufferType bufferType
  /// BufferUsageType usageType
  void bufferDataWithByteBuffer(int bufferType,
      WebGlTypedData.ByteBuffer byteBuffer, int usageType) {
    gl.bufferData(bufferType, byteBuffer, usageType);
  }

  //data type ?
  /// BufferType bufferType
  void bufferSubData(int bufferType,int offset, {dynamic data}) {
    assert(data != null);
    gl.bufferSubData(bufferType, offset, data);
  }

  //RenderBuffer
  /// RenderBufferTarget target
  void bindRenderBuffer(int target, WebGLRenderBuffer renderBuffer) {
    gl.bindRenderbuffer(target, renderBuffer?.webGLRenderBuffer);
  }

  //Extensions
  List<String> getSupportedExtensions() => gl.getSupportedExtensions();

  //Todo : get specific extension
  dynamic getExtension(String extensionName){
    return gl.getExtension(extensionName);
  }

  // >> DRAW to the drawing buffer

  //if glEnume isWrapped or not
  ///masks : List<ClearBufferMask> || int
  void clear(dynamic masks) {
    int bitmask;
    
    if(isWrapper && masks is List<ClearBufferMask>) {
      bitmask = 0;
      for (dynamic mask in masks) {
        bitmask |= mask as int;
      }
    }else if(!isWrapper && masks is List<int>) {
      bitmask = 0;
      for (dynamic mask in masks) {
        bitmask |= mask as int;
      }
    }else {
      bitmask = masks as int;
    }
    
    gl.clear(bitmask);
  }

  ///
  /// DrawMode mode
  void drawArrays(int mode, int firstVertexIndex, int vertexCount) {
    assert(firstVertexIndex >= 0 && vertexCount >= 0);
    gl.drawArrays(mode, firstVertexIndex, vertexCount);
  }

  ///[offset] is in bytes
  /// DrawMode mode
  /// BufferElementType type
  void drawElements(int mode, int count, int type, int offset) {
    gl.drawElements(mode, count, type, offset);
  }

  ///avoid this method.
  ///blocks execution until all previously called commands are finished.
  void finish(){
    gl.finish();
  }

  ///empties different buffer commands, causing all commands to be
  ///executed as quickly as possible.
  void flush(){
    gl.flush();
  }


  // >>
  /// ReadPixelDataFormat format
  /// ReadPixelDataType type
  void readPixels(int left, int top, int width, int height, int format, int type, WebGlTypedData.TypedData pixels) {
    assert(width >= 0);
    assert(height >= 0);
    gl.readPixels(left, top, width, height, format, type, pixels);
  }

  //Errors
  /// ErrorCode getError
  int getError(){
    return gl.getError();
  }

  void logRenderingContextInfos() {
    Debug.log("RenderingContext Infos", () {
      print('vendor : ${vendor}');
      print('renderer : ${renderer}');
      print('version : ${version}');
      print('shadingLanguageVersion : ${shadingLanguageVersion}');

      print('drawingBufferWidth : ${drawingBufferWidth}');
      print('drawingBufferHeight : ${drawingBufferHeight}');
      print('isContextLost : ${isContextLost}');
      print('viewportDimensions : ${maxViewportDimensions}');
      print('viewport : ${viewport}');

      contextAttributes.logValues();

      print('redBits : ${redBits}');
      print('greenBits : ${greenBits}');
      print('blueBits : ${blueBits}');
      print('alphaBits : ${alphaBits}');
      print('depthBits : ${depthBits}');
      print('stencilBits : ${stencilBits}');
      print('subPixelBits : ${subPixelBits}');
      print('colorClear : ${clearColor}');
      print('colorMask : ${colorMask}');
      print('compressTextureFormats : ${compressTextureFormats}');
      print('maxVertexTextureImageUnits : ${maxVertexTextureImageUnits}');
      print('maxVertexAttributs : ${maxVertexAttributs}');
      print('maxVertexUnifromVectors : ${maxVertexUnifromVectors}');
      print('maxVaryingVectors : ${maxVaryingVectors}');
      print('maxFragmentUnifromVectors : ${maxFragmentUnifromVectors}');
      print('maxRenderBufferSize : ${maxRenderBufferSize}');
      print('samples : ${samples}');
      print('sampleBuffers : ${sampleBuffers}');
      print('packAlignment : ${packAlignment}');
      print('unpackAlignment : ${unpackAlignment}');
      print('unpackColorSpaceConversionWebGL : ${unpackColorSpaceConversionWebGL}');
      print('unpackFlipYWebGL : ${unpackFlipYWebGL}');
      print('unpackPreMultiplyAlphaWebGL : ${unpackPreMultiplyAlphaWebGL}');
      print('lineWidth : ${lineWidth}');

      print('###  CullFace  ####################################################');
      print('cullFaceEnabled : ${cullFaceEnabled}');
      print('cullFace : ${cullFace}');
      print('frontFace : ${frontFace}');

      print('### Depth  #######################################################');
      print('depthTestEnabled : ${depthTestEnabled}');
      print('depthMask : ${depthMask}');
      print('depthFunc : ${depthFunc}');
      print('getDepthRange : ${getDepthRange()}');
      print('clearDepth : ${clearDepth}');

      print('### scissor  #####################################################');
      print('scissorTest : ${scissorTest}');
      print('scissor : ${scissor}');

      print('###  polygonOffset  ##############################################');
      print('polygonOffset : ${polygonOffset}');
      print('polygonOffsetFactor : ${polygonOffsetFactor}');
      print('polygonOffsetUnits : ${polygonOffsetUnits}');

      print('###  MultiSampleCoverage  ########################################');
      print('sampleCovarage : ${sampleCovarage}');
      print('sampleAlphaToCoverage : ${sampleAlphaToCoverage}');
      print('sampleCoverageValue : ${sampleCoverageValue}');
      print('sampleCoverageInvert : ${sampleCoverageInvert}');

      print('###  stencil #####################################################');
      print('stencilTest : ${stencilTest}');
      print('stencilFunc : ${stencilFunc}');
      print('stencilBackFunc : ${stencilBackFunc}');
      print('stencilValueMask : ${stencilValueMask}');
      print('stencilWriteMask : ${stencilWriteMask}');
      print('stencilBackWriteMask : ${stencilBackWriteMask}');
      print('stencilRef : ${stencilRef}');
      print('stencilBackRef : ${stencilBackRef}');
      print('stencilBackValueMask : ${stencilBackValueMask}');
      print('clearStencil : ${clearStencil}');
      print('stencilFail : ${stencilFail}');
      print('stencilPassDepthPass : ${stencilPassDepthPass}');
      print('stencilPassDepthFail : ${stencilPassDepthFail}');
      print('stencilBackFail : ${stencilBackFail}');
      print('stencilBackPassDepthPass : ${stencilBackPassDepthPass}');
      print('stencilBackPassDepthFail : ${stencilBackPassDepthFail}');

      print('###  Blend  ######################################################');
      print('blend : ${blend}');
      print('blendColor : ${blendColor}');
      print('blendSrcRGB : ${blendSrcRGB}');
      print('blendSrcAlpha : ${blendSrcAlpha}');
      print('blendDstRGB : ${blendDstRGB}');
      print('blendDstAlpha : ${blendDstAlpha}');
      print('blendEquation : ${blendEquation}');
      print('blendEquationRGB : ${blendEquationRGB}');
      print('blendEquationAlpha : ${blendEquationAlpha}');

      print('###  Dither  #####################################################');
      print('dither : ${dither}');

      print('###  Texture  ####################################################');
      print('-- Todo show globals');

      print('###  Extensions  #################################################');
      print('###  supportedExtensions  ########################################');
      getSupportedExtensions().forEach((ext) => print('$ext'));

      print('###  currentProgram  ##############################################');
      print('currentProgram :${currentProgram}');
      currentProgram.logProgramInfos();

      print('###################################################################');
      print('###################################################################');
      print('###  Bindings  ####################################################');
      print('arrayBufferBinding : ${arrayBufferBinding}');
      arrayBufferBinding.logBufferInfos();
      print('...................................................................');
      print('elementArrayBufferBinding : ${elementArrayBufferBinding}');
      elementArrayBufferBinding.logBufferInfos();
      print('...................................................................');
      print('renderBufferBinding : ${renderBufferBinding}');
      renderBufferBinding.logRenderBufferInfos();
      print('...................................................................');

      print('###################################################################');
      print('###################################################################');

    });
  }
}