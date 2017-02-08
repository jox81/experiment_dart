import 'dart:html';
import 'dart:typed_data' as WebGlTypedData;
import 'dart:web_gl' as WebGL;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/webgl_objects/context_attributs.dart';
import 'package:webgl/src/debug_rendering_context.dart';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/utils/utils_assets.dart';
import 'package:webgl/src/webgl_objects/webgl_active_texture.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_framebuffer.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_renderbuffer.dart';
@MirrorsUsed(
    targets: const [
      WebGLRenderingContext,
    ],
    override: '*')
import 'dart:mirrors';

class WebGLRenderingContext extends IEditElement {

  WebGLRenderingContext._init(this.ctx);

  //Todo add default parameters
  factory WebGLRenderingContext.create(CanvasElement canvas,{bool debug : false, bool preserveDrawingBuffer:true}){
    WebGL.RenderingContext ctx;

    List<String> names = [
      "webgl",
      "experimental-webgl",
      "webkit-3d",
      "moz-webgl"
    ];
    var options = {
      'preserveDrawingBuffer': preserveDrawingBuffer,
    };

    for (int i = 0; i < names.length; ++i) {
      try {
        ctx = canvas.getContext(names[i], options); //Normal context
        if (debug) {
          ctx = new DebugRenderingContext(ctx);
        }
      } catch (e) {}
      if (ctx != null) {
        break;
      }
    }
    if (ctx == null) {
      window.alert("Could not initialise WebGL");
      return null;
    }

    return new WebGLRenderingContext._init(ctx);

  }

  WebGL.RenderingContext ctx;

  CanvasElement get canvas => ctx.canvas;


  // >>> Parameteres
  dynamic getParameter(ContextParameter parameter){
    dynamic result =  ctx.getParameter(parameter.index);
    return result;
  }

  ContextAttributs get contextAttributes => new ContextAttributs(ctx.getContextAttributes());

  //
  bool get isContextLost => ctx.isContextLost();

  ActiveTexture get activeTexture => ActiveTexture.instance;
  ActiveFrameBuffer get activeFrameBuffer => ActiveFrameBuffer.instance;

  // >>> single getParameter

  // > VENDOR
  String get vendor => ctx.getParameter(ContextParameter.VENDOR.index);
  // > RENDERER
  String get renderer => ctx.getParameter(ContextParameter.RENDERER.index);
  // > VERSION
  String get version => ctx.getParameter(ContextParameter.VERSION.index);
  // > SHADING_LANGUAGE_VERSION
  String get shadingLanguageVersion => ctx.getParameter(ContextParameter.SHADING_LANGUAGE_VERSION.index);

  num get drawingBufferWidth => ctx.drawingBufferWidth;
  num get drawingBufferHeight => ctx.drawingBufferHeight;

  // > MAX_VIEWPORT_DIMS
  WebGlTypedData.Int32List get maxViewportDimensions => ctx.getParameter(ContextParameter.MAX_VIEWPORT_DIMS.index);

  // > VIEWPORT
  Rectangle get viewport {
    WebGlTypedData.Int32List values = ctx.getParameter(ContextParameter.VIEWPORT.index);
    return new Rectangle(values[0], values[1], values[2], values[3]);
  }
  set viewport(Rectangle rect) {
    //int x, int y, num width, num height
    assert(rect.width >= 0 && rect.height >= 0);
    ctx.viewport(rect.left, rect.top, rect.width, rect.height);
  }


  // > ALIASED_LINE_WIDTH_RANGE [2]
  WebGlTypedData.Float32List get aliasedLineWidthRange => ctx.getParameter(ContextParameter.ALIASED_LINE_WIDTH_RANGE.index);

  // > ALIASED_POINT_SIZE_RANGE [2]
  WebGlTypedData.Float32List get aliasedPointSizeRange => ctx.getParameter(ContextParameter.ALIASED_POINT_SIZE_RANGE.index);

  // > RED_BITS
  int get redBits => ctx.getParameter(ContextParameter.RED_BITS.index);
  // > GREEN_BITS
  int get greenBits => ctx.getParameter(ContextParameter.GREEN_BITS.index);
  // > BLUE_BITS
  int get blueBits => ctx.getParameter(ContextParameter.BLUE_BITS.index);
  // > ALPHA_BITS
  int get alphaBits => ctx.getParameter(ContextParameter.ALPHA_BITS.index);
  // > DEPTH_BITS
  int get depthBits => ctx.getParameter(ContextParameter.DEPTH_BITS.index);
  // > STENCIL_BITS
  int get stencilBits => ctx.getParameter(ContextParameter.STENCIL_BITS.index);
  // > SUBPIXEL_BITS
  int get subPixelBits => ctx.getParameter(ContextParameter.SUBPIXEL_BITS.index);

  // > COLOR_CLEAR_VALUE [4]
  Vector4 get clearColor => new Vector4.fromFloat32List(ctx.getParameter(ContextParameter.COLOR_CLEAR_VALUE.index));
  set clearColor(Vector4 color) => ctx.clearColor(color.r, color.g, color.b, color.a);

  // > COLOR_WRITEMASK [4]
  List<bool> get colorMask => ctx.getParameter(ContextParameter.COLOR_WRITEMASK.index);
  set colorMask(List<bool> mask){
    assert(mask.length == 4);
    ctx.colorMask(mask[0], mask[1], mask[2], mask[3]);
  }

  // > COMPRESSED_TEXTURE_FORMATS [4]
  WebGlTypedData.Uint32List get compressTextureFormats => ctx.getParameter(ContextParameter.COMPRESSED_TEXTURE_FORMATS.index);

  // > CURRENT_PROGRAM
  WebGLProgram get currentProgram => new WebGLProgram.fromWebGL(ctx.getParameter(ContextParameter.CURRENT_PROGRAM.index));

  // > ARRAY_BUFFER_BINDING
  WebGLBuffer get arrayBufferBinding => new WebGLBuffer.fromWebGL(ctx.getParameter(ContextParameter.ARRAY_BUFFER_BINDING.index));
  // > ELEMENT_ARRAY_BUFFER_BINDING
  WebGLBuffer get elementArrayBufferBinding => new WebGLBuffer.fromWebGL(ctx.getParameter(ContextParameter.ELEMENT_ARRAY_BUFFER_BINDING.index));
  // > RENDERBUFFER_BINDING
  WebGLRenderBuffer get renderBufferBinding => new WebGLRenderBuffer.fromWebGL(ctx.getParameter(ContextParameter.RENDERBUFFER_BINDING.index));

  // > MAX_VERTEX_TEXTURE_IMAGE_UNITS
  int get maxVertexTextureImageUnits => ctx.getParameter(ContextParameter.MAX_VERTEX_TEXTURE_IMAGE_UNITS.index);
  // > MAX_VERTEX_ATTRIBS
  int get maxVertexAttributs => ctx.getParameter(ContextParameter.MAX_VERTEX_ATTRIBS.index);
  // > MAX_VERTEX_UNIFORM_VECTORS
  int get maxVertexUnifromVectors => ctx.getParameter(ContextParameter.MAX_VERTEX_UNIFORM_VECTORS.index);
  // > MAX_VARYING_VECTORS
  int get maxVaryingVectors => ctx.getParameter(ContextParameter.MAX_VARYING_VECTORS.index);
  // > MAX_FRAGMENT_UNIFORM_VECTORS
  int get maxFragmentUnifromVectors => ctx.getParameter(ContextParameter.MAX_FRAGMENT_UNIFORM_VECTORS.index);
  // > MAX_RENDERBUFFER_SIZE
  int get maxRenderBufferSize => ctx.getParameter(ContextParameter.MAX_RENDERBUFFER_SIZE.index);


  // > SAMPLES
  int get samples => ctx.getParameter(ContextParameter.SAMPLES.index);
  // > SAMPLE_BUFFERS
  int get sampleBuffers => ctx.getParameter(ContextParameter.SAMPLE_BUFFERS.index);


  // >> pixelStorei

  // > PACK_ALIGNMENT
  int get packAlignment => ctx.getParameter(ContextParameter.PACK_ALIGNMENT.index);
  // > UNPACK_ALIGNMENT
  int get unpackAlignment => ctx.getParameter(ContextParameter.UNPACK_ALIGNMENT.index);
  // > UNPACK_FLIP_Y_WEBGL
  bool get unpackFlipYWebGL => ctx.getParameter(ContextParameter.UNPACK_FLIP_Y_WEBGL.index);
  // > UNPACK_PREMULTIPLY_ALPHA_WEBGL
  bool get unpackPreMultiplyAlphaWebGL => ctx.getParameter(ContextParameter.UNPACK_PREMULTIPLY_ALPHA_WEBGL.index);
  // > UNPACK_COLORSPACE_CONVERSION_WEBGL
  PixelStorgeType get unpackColorSpaceConversionWebGL => PixelStorgeType.getByIndex(ctx.getParameter(ContextParameter.UNPACK_COLORSPACE_CONVERSION_WEBGL.index));

  void pixelStorei(PixelStorgeType storage, int value) => ctx.pixelStorei(storage.index, value);


  // >>

  // > IMPLEMENTATION_COLOR_READ_FORMAT // Todo : GLenum ?
  int get implementationColorReadFormat => ctx.getParameter(ContextParameter.IMPLEMENTATION_COLOR_READ_FORMAT.index);
  // > IMPLEMENTATION_COLOR_READ_TYPE // Todo : GLenum ?
  int get implementationColorReadType => ctx.getParameter(ContextParameter.IMPLEMENTATION_COLOR_READ_TYPE.index);

  // > LINE_WIDTH
  num get lineWidth => ctx.getParameter(ContextParameter.LINE_WIDTH.index);
  set lineWidth(num width) => ctx.lineWidth(width);


  //>>>


  //CullFace
  // > CULL_FACE //Todo : ? identique à get parameter ? BLEND
  bool get cullFace => isEnabled(EnableCapabilityType.CULL_FACE);
  set cullFace(bool enable) => _setEnabled(EnableCapabilityType.CULL_FACE, enable);

  // > CULL_FACE_MODE
  FacingType get cullFaceMode => FacingType.getByIndex(ctx.getParameter(ContextParameter.CULL_FACE_MODE.index));
  set cullFaceMode(FacingType mode) {
    ctx.cullFace(mode.index);
  }

  // > FRONT_FACE
  FrontFaceDirection get frontFace => FrontFaceDirection.getByIndex(ctx.getParameter(ContextParameter.FRONT_FACE.index));
  set frontFace(FrontFaceDirection mode) => ctx.frontFace(mode.index);

  //Depth
  // > DEPTH_TEST
  bool get depthTest => ctx.isEnabled(EnableCapabilityType.DEPTH_TEST.index);
  set depthTest(bool enable) => _setEnabled(EnableCapabilityType.DEPTH_TEST, enable);

  // > DEPTH_WRITEMASK
  bool get depthMask => ctx.getParameter(ContextParameter.DEPTH_WRITEMASK.index);
  set depthMask(bool enable) => ctx.depthMask(enable);

  // > DEPTH_FUNC
  ComparisonFunction get depthFunc => ComparisonFunction.getByIndex(ctx.getParameter(ContextParameter.DEPTH_FUNC.index));
  set depthFunc(ComparisonFunction depthComparisionFunction) => ctx.depthFunc(depthComparisionFunction.index);

  // > DEPTH_RANGE [2]
  WebGlTypedData.Float32List getDepthRange() => ctx.getParameter(ContextParameter.DEPTH_RANGE.index);
  void setDepthRange(num zNear, num zFar) => ctx.depthRange(zNear, zFar);

  // > DEPTH_CLEAR_VALUE
  num get clearDepth => ctx.getParameter(ContextParameter.DEPTH_CLEAR_VALUE.index);
  set clearDepth(num depthValue){
    assert(0.0 <= depthValue && depthValue <= 1.0);
    ctx.clearDepth(depthValue);
  }

  //Scissor

  // > SCISSOR_TEST
  bool get scissorTest => isEnabled(EnableCapabilityType.SCISSOR_TEST);
  set scissorTest(bool enabled) => _setEnabled(EnableCapabilityType.SCISSOR_TEST, enabled);


  // > SCISSOR_BOX
  Rectangle get scissor {
    WebGlTypedData.Int32List values = ctx.getParameter(ContextParameter.SCISSOR_BOX.index);
    return new Rectangle(values[0], values[1], values[2], values[3]);
  }
  set scissor(Rectangle rect) {
    //int x, int y, num width, num height
    assert(rect.width >= 0 && rect.height >= 0);
    ctx.scissor(rect.left, rect.top, rect.width, rect.height);
  }

  //Polygon offset
  // > POLYGON_OFFSET_FILL
  bool get polygonOffset => ctx.isEnabled(EnableCapabilityType.POLYGON_OFFSET_FILL.index);
  set polygonOffset(bool enabled) =>_setEnabled(EnableCapabilityType.POLYGON_OFFSET_FILL, enabled);

  // > POLYGON_OFFSET_FACTOR
  num get polygonOffsetFactor => ctx.getParameter(ContextParameter.POLYGON_OFFSET_FACTOR.index);
  // > POLYGON_OFFSET_UNITS
  num get polygonOffsetUnits => ctx.getParameter(ContextParameter.POLYGON_OFFSET_UNITS.index);

  void setPolygonOffest(num factor, num units){
    ctx.polygonOffset(factor, units);
  }

  //MultiSampleCoverage
  bool get sampleCovarage => isEnabled(EnableCapabilityType.SAMPLE_COVERAGE);
  set sampleCoverage(bool enabled) => _setEnabled(EnableCapabilityType.SAMPLE_COVERAGE, enabled);

  bool get sampleAlphaToCoverage => isEnabled(EnableCapabilityType.SAMPLE_ALPHA_TO_COVERAGE);
  set sampleAlphaToCoverage(bool enabled) => _setEnabled(EnableCapabilityType.SAMPLE_ALPHA_TO_COVERAGE, enabled);

  // > SAMPLE_COVERAGE_VALUE
  num get sampleCoverageValue => ctx.getParameter(ContextParameter.SAMPLE_COVERAGE_VALUE.index);
  // > SAMPLE_COVERAGE_INVERT
  bool get sampleCoverageInvert => ctx.getParameter(ContextParameter.SAMPLE_COVERAGE_INVERT.index);
  void setSampleCoverage(num value, bool invert) => ctx.sampleCoverage(value, invert);

  //Stencils
  void stencilFuncSeparate(FacingType faceType, ComparisonFunction comparisonFunction, int ref, int mask){
    ctx.stencilFuncSeparate(faceType.index, comparisonFunction.index, ref, mask);
  }
  void stencilMaskSeparate(FacingType faceType, int mask){
    ctx.stencilMaskSeparate(faceType.index, mask);
  }
  void stencilOp(StencilOpMode fail, StencilOpMode zFail, StencilOpMode zPass){
    ctx.stencilOp(fail.index, zFail.index, zPass.index);
  }
  void stencilOpSeparate(FacingType faceType, StencilOpMode fail, StencilOpMode zFail, StencilOpMode zPass){
    ctx.stencilOpSeparate(faceType.index, fail.index, zFail.index, zPass.index);
  }

  // > STENCIL_TEST //Todo : ? identique à get parameter ? STENCIL_TEST
  bool get stencilTest => isEnabled(EnableCapabilityType.STENCIL_TEST);
  set stencilTest (bool enabled) => _setEnabled(EnableCapabilityType.STENCIL_TEST, enabled);

  // > STENCIL_FUNC
  ComparisonFunction get stencilFunc => ComparisonFunction.getByIndex(ctx.getParameter(ContextParameter.STENCIL_FUNC.index));
  // > STENCIL_BACK_FUNC
  ComparisonFunction get stencilBackFunc => ComparisonFunction.getByIndex(ctx.getParameter(ContextParameter.STENCIL_BACK_FUNC.index));
  void setStencilFunc(ComparisonFunction comparisonFunction, int ref, int mask){
    ctx.stencilFunc(comparisonFunction.index, ref, mask);
  }

  // > STENCIL_VALUE_MASK
  int get stencilValueMask => ctx.getParameter(ContextParameter.STENCIL_VALUE_MASK.index);
  // > STENCIL_WRITEMASK
  int get stencilWriteMask => ctx.getParameter(ContextParameter.STENCIL_WRITEMASK.index);
  // > STENCIL_BACK_WRITEMASK
  int get stencilBackWriteMask => ctx.getParameter(ContextParameter.STENCIL_BACK_WRITEMASK.index);
  set stencilMaks(int value) => ctx.stencilMask(value);

  // > STENCIL_REF
  int get stencilRef => ctx.getParameter(ContextParameter.STENCIL_REF.index);
  // > STENCIL_BACK_REF
  int get stencilBackRef => ctx.getParameter(ContextParameter.STENCIL_BACK_REF.index);
  // > STENCIL_BACK_VALUE_MASK
  int get stencilBackValueMask => ctx.getParameter(ContextParameter.STENCIL_BACK_VALUE_MASK.index);

  // > STENCIL_CLEAR_VALUE
  int get clearStencil => ctx.getParameter(ContextParameter.STENCIL_CLEAR_VALUE.index);
  set clearStencil(int index) => ctx.clearStencil(index);

  // > STENCIL_FAIL
  StencilOpMode get stencilFail => StencilOpMode.getByIndex(ctx.getParameter(ContextParameter.STENCIL_FAIL.index));
  // > STENCIL_PASS_DEPTH_PASS
  StencilOpMode get stencilPassDepthPass => StencilOpMode.getByIndex(ctx.getParameter(ContextParameter.STENCIL_PASS_DEPTH_PASS.index));
  // > STENCIL_PASS_DEPTH_FAIL
  StencilOpMode get stencilPassDepthFail => StencilOpMode.getByIndex(ctx.getParameter(ContextParameter.STENCIL_PASS_DEPTH_FAIL.index));
  // > STENCIL_BACK_FAIL
  StencilOpMode get stencilBackFail => StencilOpMode.getByIndex(ctx.getParameter(ContextParameter.STENCIL_BACK_FAIL.index));
  // > STENCIL_BACK_PASS_DEPTH_PASS
  StencilOpMode get stencilBackPassDepthPass => StencilOpMode.getByIndex(ctx.getParameter(ContextParameter.STENCIL_BACK_PASS_DEPTH_PASS.index));
  // > STENCIL_BACK_PASS_DEPTH_FAIL
  StencilOpMode get stencilBackPassDepthFail => StencilOpMode.getByIndex(ctx.getParameter(ContextParameter.STENCIL_BACK_PASS_DEPTH_FAIL.index));

  //Blend
  //Todo : ? identique à get parameter ? BLEND
  bool get blend => isEnabled(EnableCapabilityType.BLEND);
  set blend (bool enabled) => _setEnabled(EnableCapabilityType.BLEND, enabled);

  void blendFunc(BlendFactorMode sourceFactor, BlendFactorMode destinationFactor){
    ctx.blendFunc(sourceFactor.index, destinationFactor.index);
  }
  void blendFuncSeparate(BlendFactorMode srcRGB, BlendFactorMode dstRGB, BlendFactorMode srcAlpha, BlendFactorMode dstAlpha){
    ctx.blendFuncSeparate(srcRGB.index, dstRGB.index, srcAlpha.index, dstAlpha.index);
  }
  void setBlendColor(num red, num green, num blue, num alpha){
    assert(0.0 <= red && red <= 1.0);
    assert(0.0 <= green && green <= 1.0);
    assert(0.0 <= blue && blue <= 1.0);
    assert(0.0 <= alpha && alpha <= 1.0);
    ctx.blendColor(red, green, blue, alpha);
  }
  // > BLEND_COLOR
  WebGlTypedData.Float32List get blendColor => ctx.getParameter(ContextParameter.BLEND_COLOR.index);
  set blendColor(WebGlTypedData.Float32List values){
    assert(values.length == 4);
    setBlendColor(values[0], values[1], values[2], values[3]);
  }
  // > BLEND_SRC_RGB, BLEND_DST_RGB, BLEND_SRC_ALPHA, BLEND_DST_ALPHA
  BlendFactorMode get blendSrcRGB => BlendFactorMode.getByIndex(ctx.getParameter(ContextParameter.BLEND_SRC_RGB.index));
  BlendFactorMode get blendSrcAlpha => BlendFactorMode.getByIndex(ctx.getParameter(ContextParameter.BLEND_SRC_ALPHA.index));
  BlendFactorMode get blendDstRGB => BlendFactorMode.getByIndex(ctx.getParameter(ContextParameter.BLEND_DST_RGB.index));
  BlendFactorMode get blendDstAlpha => BlendFactorMode.getByIndex(ctx.getParameter(ContextParameter.BLEND_DST_ALPHA.index));

  // > BLEND_EQUATION, BLEND_EQUATION_RGB, BLEND_EQUATION_ALPHA
  BlendFunctionMode get blendEquation => BlendFunctionMode.getByIndex(ctx.getParameter(ContextParameter.BLEND_EQUATION.index));
  BlendFunctionMode get blendEquationRGB => BlendFunctionMode.getByIndex(ctx.getParameter(ContextParameter.BLEND_EQUATION_RGB.index));
  BlendFunctionMode get blendEquationAlpha => BlendFunctionMode.getByIndex(ctx.getParameter(ContextParameter.BLEND_EQUATION_ALPHA .index));
  set blendEquation(BlendFunctionMode mode) => ctx.blendEquation(mode.index);

  void blendEquationSeparate(BlendFunctionMode modeRGB, BlendFunctionMode modeAlpha){
    ctx.blendEquationSeparate(modeRGB.index, modeAlpha.index);
  }

  //Dither
  // > DITHER
  bool get dither => isEnabled(EnableCapabilityType.DITHER);
  set dither (bool enabled) => _setEnabled(EnableCapabilityType.DITHER, enabled);


  /////

  //EnableCapabilityType enabling
  void enable(EnableCapabilityType cap) {
    ctx.enable(cap.index);
  }
  void disable(EnableCapabilityType cap) {
    ctx.disable(cap.index);
  }

  void _setEnabled(EnableCapabilityType enableCapType, bool enabled){
    if(enabled){
      enable(enableCapType);
    } else {
      disable(enableCapType);
    }
  }

  bool isEnabled(EnableCapabilityType cap) {
    return ctx.isEnabled(cap.index);
  }



  // Buffers
  void bindBuffer(BufferType bufferType, WebGLBuffer webglBuffer) {
    ctx.bindBuffer(bufferType.index, webglBuffer?.webGLBuffer);
  }

  void bufferData(BufferType bufferType,
      WebGlTypedData.TypedData typedData, BufferUsageType usageType) {
    ctx.bufferData(bufferType.index, typedData, usageType.index);
  }

  void bufferDataWithSize(BufferType bufferType, int size,
      WebGLBuffer webglBuffer, BufferUsageType usageType) {
    assert(size != null);
    ctx.bufferData(bufferType.index, size, usageType.index);
  }

  void bufferDataWithByteBuffer(BufferType bufferType,
      WebGlTypedData.ByteBuffer byteBuffer, BufferUsageType usageType) {
    ctx.bufferData(bufferType.index, byteBuffer, usageType.index);
  }

  //data type ?
  void bufferSubData(BufferType bufferType,int offset, {dynamic data}) {
    assert(data != null);
    ctx.bufferSubData(bufferType.index, offset, data);
  }

  //RenderBuffer
  void bindRenderBuffer(RenderBufferTarget target, WebGLRenderBuffer renderBuffer) {
    ctx.bindRenderbuffer(target.index, renderBuffer?.webGLRenderBuffer);
  }

  //Extensions
  List<String> get supportedExtensions => ctx.getSupportedExtensions();

  //Todo : get specific extension
  dynamic getExtension(String extensionName){
    return ctx.getExtension(extensionName);
  }

  // >> DRAW to the drawing buffer

  ///
  void clear(List<ClearBufferMask> masks) {
    //Todo : change with bitmask : RenderingContext.COLOR_BUFFER_BIT | RenderingContext.DEPTH_BUFFER_BIT
    int bitmask = 0;
    for(ClearBufferMask mask in masks) {
      bitmask |= mask.index;
    }
    ctx.clear(bitmask);
  }

  ///
  void drawArrays(DrawMode mode, int firstVertexIndex, int vertexCount) {
    assert(firstVertexIndex >= 0 && vertexCount >= 0);
    ctx.drawArrays(mode.index, firstVertexIndex, vertexCount);
  }

  ///[offset] is in bytes
  void drawElements(DrawMode mode, int count, BufferElementType type, int offset) {
    ctx.drawElements(mode.index, count, type.index, offset);
  }

  ///avoid this method.
  ///blocks execution until all previously called commands are finished.
  void finish(){
    ctx.finish();
  }

  ///empties different buffer commands, causing all commands to be
  ///executed as quickly as possible.
  void flush(){
    ctx.flush();
  }


  // >>
  void readPixels(int left, int top, int width, int height, ReadPixelDataFormat format, ReadPixelDataType type, WebGlTypedData.TypedData pixels) {
    assert(width >= 0);
    assert(height >= 0);
    ctx.readPixels(left, top, width, height, format.index, type.index, pixels);
  }

  //Errors
  ErrorCode getError(){
    return ErrorCode.getByIndex(ctx.getError());
  }

  void logRenderingContextInfos() {
    UtilsAssets.log("RenderingContext Infos", () {
      print('vendor : ${vendor}');
      print('renderer : ${renderer}');
      print('version : ${version}');
      print('shadingLanguageVersion : ${shadingLanguageVersion}');

      print('drawingBufferWidth : ${drawingBufferWidth}');
      print('drawingBufferHeight : ${drawingBufferHeight}');
      print('isContextLost : ${isContextLost}');
      print('viewportDimensions : ${maxViewportDimensions}');
      print('viewport : ${viewport}');

      print('${contextAttributes.logValues()}');

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
      print('cullFace : ${cullFace}');
      print('cullFaceMode : ${cullFaceMode}');
      print('frontFace : ${frontFace}');

      print('### Depth  #######################################################');
      print('depthTest : ${depthTest}');
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
      supportedExtensions.forEach((ext) => print('$ext'));

      print('###  currentProgram  ##############################################');
      print('currentProgram :${currentProgram}');
      print('${currentProgram.logProgramInfos()}');

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