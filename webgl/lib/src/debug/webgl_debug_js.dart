//Base js from  : https://www.khronos.org/webgl/wiki/Debugging
@JS()
library WebGLDebugUtils;

import 'dart:html';
import "package:js/js.dart";
import 'dart:web_gl';
import 'dart:typed_data';

//@anonymous
@JS()
class WebGLDebugUtils {
  external factory WebGLDebugUtils();
  external static RenderingContextWrapper makeDebugContext(RenderingContext name, [Function opt_onErrorFunc, Function opt_onFunc, Function opt_err_ctx]);
  external static String glFunctionArgsToString(String functionName, dynamic args);
  external static String glEnumToString(dynamic err);
  external static void init(dynamic ctx);
  external void getError();
}

//@anonymous
@JS()
class RenderingContextWrapper extends RenderingContext{
  external factory RenderingContextWrapper();
  external getError();
  external activeTexture(int texture);
  external attachShader(Program program, Shader shader) ;
  external bindAttribLocation(Program program, int index, String name) ;
  external bindBuffer(int target, Buffer buffer) ;
  external bindFramebuffer(int target, Framebuffer framebuffer) ;
  external bindRenderbuffer(int target, Renderbuffer renderbuffer) ;
  external bindTexture(int target, Texture texture) ;
  external blendColor(num red, num green, num blue, num alpha) ;
  external blendEquation(int mode) ;
  external blendEquationSeparate(int modeRGB, int modeAlpha) ;
  external blendFunc(int sfactor, int dfactor) ;
  external blendFuncSeparate(int srcRGB, int dstRGB, int srcAlpha, int dstAlpha) ;
  external bufferData(int target, dynamic data_OR_size, int usage) ;
  external bufferDataTyped(int target, TypedData data, int usage) ;
  external bufferSubData(int target, int offset, dynamic data) ;
  external bufferSubDataTyped(int target, int offset, TypedData data) ;
  external CanvasElement get canvas;
  external int checkFramebufferStatus(int target) ;
  external clear(int mask) ;
  external clearColor(num red, num green, num blue, num alpha) ;
  external clearDepth(num depth) ;
  external clearStencil(int s) ;
  external colorMask(bool red, bool green, bool blue, bool alpha) ;
  external compileShader(Shader shader) ;
  external compressedTexImage2D(int target, int level, int internalformat, int width, int height, int border, TypedData data) ;
  external compressedTexSubImage2D(int target, int level, int xoffset, int yoffset, int width, int height, int format, TypedData data) ;
  external copyTexImage2D(int target, int level, int internalformat, int x, int y, int width, int height, int border) ;
  external copyTexSubImage2D(int target, int level, int xoffset, int yoffset, int x, int y, int width, int height) ;
  external Buffer createBuffer() ;
  external Framebuffer createFramebuffer() ;
  external Program createProgram() ;
  external Renderbuffer createRenderbuffer() ;
  external Shader createShader(int type) ;
  external Texture createTexture() ;
  external cullFace(int mode) ;
  external deleteBuffer(Buffer buffer) ;
  external deleteFramebuffer(Framebuffer framebuffer) ;

  external deleteProgram(Program program) ;

  external deleteRenderbuffer(Renderbuffer renderbuffer) ;

  external deleteShader(Shader shader) ;

  external deleteTexture(Texture texture) ;

  external depthFunc(int func) ;

  external depthMask(bool flag) ;

  external depthRange(num zNear, num zFar) ;

  external detachShader(Program program, Shader shader) ;

  external disable(int cap) ;

  external disableVertexAttribArray(int index) ;

  external drawArrays(int mode, int first, int count) ;

  external drawElements(int mode, int count, int type, int offset) ;

  external int get drawingBufferHeight;

  external get drawingBufferWidth;

  external enable(int cap) ;

  external enableVertexAttribArray(int index) ;

  external finish() ;

  external flush() ;

  external framebufferRenderbuffer(int target, int attachment, int renderbuffertarget, Renderbuffer renderbuffer) ;

  external framebufferTexture2D(int target, int attachment, int textarget, Texture texture, int level) ;

  external frontFace(int mode) ;

  external generateMipmap(int target) ;

  external ActiveInfo getActiveAttrib(Program program, int index) ;

  external ActiveInfo getActiveUniform(Program program, int index) ;

  external List<Shader> getAttachedShaders(Program program) ;

  external int getAttribLocation(Program program, String name) ;

  external Object getBufferParameter(int target, int pname) ;

  external getContextAttributes() ;

  external Object getExtension(String name) ;

  external Object getFramebufferAttachmentParameter(int target, int attachment, int pname) ;

  external Object getParameter(int pname) ;

  external String getProgramInfoLog(Program program) ;

  external Object getProgramParameter(Program program, int pname) ;

  external Object getRenderbufferParameter(int target, int pname) ;

  external String getShaderInfoLog(Shader shader) ;

  external Object getShaderParameter(Shader shader, int pname) ;

  external ShaderPrecisionFormat getShaderPrecisionFormat(int shadertype, int precisiontype) ;

  external String getShaderSource(Shader shader) ;

  external List<String> getSupportedExtensions() ;

  external Object getTexParameter(int target, int pname) ;

  external Object getUniform(Program program, UniformLocation location) ;

  external UniformLocation getUniformLocation(Program program, String name) ;

  external Object getVertexAttrib(int index, int pname) ;

  external int getVertexAttribOffset(int index, int pname) ;

  external hint(int target, int mode) ;

  external bool isBuffer(Buffer buffer) ;

  external bool isContextLost() ;

  external bool isEnabled(int cap) ;

  external bool isFramebuffer(Framebuffer framebuffer) ;

  external bool isProgram(Program program) ;

  external bool isRenderbuffer(Renderbuffer renderbuffer) ;

  external bool isShader(Shader shader) ;

  external bool isTexture(Texture texture) ;

  external lineWidth(num width) ;

  external linkProgram(Program program) ;

  external pixelStorei(int pname, int param) ;

  external polygonOffset(num factor, num units) ;

  external readPixels(int x, int y, int width, int height, int format, int type, TypedData pixels) ;

  external renderbufferStorage(int target, int internalformat, int width, int height) ;

  external sampleCoverage(num value, bool invert) ;

  external scissor(int x, int y, int width, int height) ;

  external shaderSource(Shader shader, String string) ;

  external stencilFunc(int func, int ref, int mask) ;

  external stencilFuncSeparate(int face, int func, int ref, int mask) ;

  external stencilMask(int mask) ;

  external stencilMaskSeparate(int face, int mask) ;

  external stencilOp(int fail, int zfail, int zpass) ;

  external stencilOpSeparate(int face, int fail, int zfail, int zpass) ;

  external texImage2D(int target, int level, int internalformat, int format_OR_width, int height_OR_type, dynamic border_OR_canvas_OR_image_OR_pixels_OR_video, [int format, int type, TypedData pixels]) ;

  external texImage2DTyped(int targetTexture, int levelOfDetail, int internalFormat, int width, int height, int border, int format, int type, TypedData data) ;

  external texImage2DUntyped(int targetTexture, int levelOfDetail, int internalFormat, int format, int type, dynamic data) ;

  external texParameterf(int target, int pname, num param) ;

  external texParameteri(int target, int pname, int param) ;

  external texSubImage2D(int target, int level, int xoffset, int yoffset, int format_OR_width, int height_OR_type, dynamic canvas_OR_format_OR_image_OR_pixels_OR_video, [int type, TypedData pixels]) ;

  external texSubImage2DTyped(int targetTexture, int levelOfDetail, int xOffset, int yOffset, int width, int height, int border, int format, int type, TypedData data) ;

  external texSubImage2DUntyped(int targetTexture, int levelOfDetail, int xOffset, int yOffset, int format, int type, dynamic data) ;

  external uniform1f(UniformLocation location, num x) ;

  external uniform1fv(UniformLocation location, dynamic v);

  external uniform1i(UniformLocation location, int x) ;

  external uniform1iv(UniformLocation location, dynamic v) ;

  external uniform2f(UniformLocation location, num x, num y) ;

  external uniform2fv(UniformLocation location, dynamic v) ;

  external uniform2i(UniformLocation location, int x, int y) ;

  external uniform2iv(UniformLocation location, dynamic v) ;

  external uniform3f(UniformLocation location, num x, num y, num z) ;

  external uniform3fv(UniformLocation location, dynamic v) ;

  external uniform3i(UniformLocation location, int x, int y, int z) ;

  external uniform3iv(UniformLocation location, dynamic v) ;

  external uniform4f(UniformLocation location, num x, num y, num z, num w) ;

  external uniform4fv(UniformLocation location, dynamic v) ;

  external uniform4i(UniformLocation location, int x, int y, int z, int w) ;

  external uniform4iv(UniformLocation location, dynamic v) ;

  external uniformMatrix2fv(UniformLocation location, bool transpose, dynamic array) ;

  external uniformMatrix3fv(UniformLocation location, bool transpose, dynamic array) ;

  external uniformMatrix4fv(UniformLocation location, bool transpose, dynamic array) ;

  external useProgram(Program program) ;

  external validateProgram(Program program) ;

  external vertexAttrib1f(int indx, num x) ;

  external vertexAttrib1fv(int indx, dynamic values) ;

  external vertexAttrib2f(int indx, num x, num y) ;

  external vertexAttrib2fv(int indx, dynamic values) ;

  external vertexAttrib3f(int indx, num x, num y, num z) ;

  external vertexAttrib3fv(int indx, dynamic values) ;

  external vertexAttrib4f(int indx, num x, num y, num z, num w) ;

  external vertexAttrib4fv(int indx, dynamic values) ;

  external vertexAttribPointer(int indx, int size, int type, bool normalized, int stride, int offset) ;

  external viewport(int x, int y, int width, int height) ;
}

///
/// Custom Kronos debug functions
///

void throwOnGLError(dynamic err, String funcName, dynamic args) {
  throw WebGLDebugUtils.glEnumToString(err) + " was caused by call to: " + funcName;
}

void logAndValidate(String functionName, List<dynamic> args) {



  logGLCall(functionName, args);
  validateNoneOfTheArgsAreUndefined (functionName, args);
}

void logGLCall(String functionName, dynamic args) {
  print("gl.$functionName (" +
      WebGLDebugUtils.glFunctionArgsToString(functionName, args) + ")");
}

void validateNoneOfTheArgsAreUndefined(String functionName, List<dynamic> args) {
  for (var i = 0; i < args.length; i++) {
    if (args[i] == null) {
      print("undefined passed to gl." + functionName + "(" +
          WebGLDebugUtils.glFunctionArgsToString(functionName, args) + ")");
    }
  }
}