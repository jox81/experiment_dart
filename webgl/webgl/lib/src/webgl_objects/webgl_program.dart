import 'dart:html';
import 'dart:web_gl' as WebGL;
import 'package:webgl/src/utils/utils_text.dart';
import 'package:webgl/src/webgl_objects/context.dart';
import 'package:webgl/src/utils/utils_debug.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_active_info.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_attribut_location.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/program/program_info.dart';
import 'package:webgl/src/webgl_objects/webgl_object.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_uniform_location.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
import 'dart:typed_data';

class WebGLProgram extends WebGLObject{

  final WebGL.Program webGLProgram;

  Map<String, WebGLUniformLocation> uniformLocations = new Map();
  Map<String, int> attributLocations = new Map();

  Map<String, WebGLBuffer> buffers = new Map();

  WebGLProgram() : this.webGLProgram = gl.createProgram();
  WebGLProgram.fromWebGL(this.webGLProgram);

  @override
  void delete() => gl.deleteProgram(webGLProgram);

  List<WebGLShader> get attachedShaders{
    return gl.getAttachedShaders(webGLProgram).map((s)=> new WebGLShader.fromWebGL(s)).toList();
  }

  void attachShader(WebGLShader shader){
    gl.attachShader(webGLProgram, shader.webGLShader);
  }

  void detachShader(WebGLShader shader){
    gl.detachShader(webGLProgram, shader.webGLShader);
  }

  void use(){
    gl.useProgram(webGLProgram);
  }

  ////

  bool get isProgram => gl.isProgram(webGLProgram);
  String get infoLog => gl.getProgramInfoLog(webGLProgram);

  void link(){
    gl.linkProgram(webGLProgram);

    if (!linkStatus) {
      print(infoLog);
      window.alert("Could not initialise shaders");
    }
  }

  void validate(){
    gl.validateProgram(webGLProgram);

    if (!validateStatus) {
      print(infoLog);
      window.alert("Could not compile program");
    }
  }

  //Attributs

  ///Returns a new WebGLActiveInfo object describing the size, type and name of
  ///the vertex attribute at the passed index of the passed program object.
  WebGLActiveInfo getActiveAttribInfo(int activeAttributIndex){
    return new WebGLActiveInfo.fromWebGL(gl.getActiveAttrib(webGLProgram, activeAttributIndex));
  }

  ///Return a new WebGLUniformLocation that represents the location of a
  ///specific vertex attribut variable within a program object.
  WebGLAttributLocation getAttribLocation(String variableName){
    return new WebGLAttributLocation(gl.getAttribLocation(webGLProgram, variableName));
  }

  ///associate a generic vertex attribute index with a named attribute variable
  //??
  void bindAttribLocation(WebGLAttributLocation attributLocation, String variableName){
    gl.bindAttribLocation(webGLProgram, attributLocation.location, variableName);
  }

  //Uniforms

  ///Returns a new WebGLActiveInfo object describing the size, type and name of
  ///the uniform at the passed index of the passed program object
  WebGLActiveInfo getActiveUniform(int activeUniformIndex){
    return new WebGLActiveInfo.fromWebGL(gl.getActiveUniform(webGLProgram, activeUniformIndex));
  }

  ///Return a new WebGLUniformLocation that represents the location of a
  ///specific uniform variable within a program object.
  WebGLUniformLocation getUniformLocation(String variableName){
    return new WebGLUniformLocation(this,variableName);
  }

  ///Return the uniform value at the passed location in the passed program.
  ///The type returned is dependent on the uniform type
  dynamic getUniformValue(WebGLUniformLocation location){
    return gl.getUniform(webGLProgram, location.webGLUniformLocation);
  }

  //Custom
  ProgramInfo getProgramInfo(){
    ProgramInfo result = new ProgramInfo();

    // Loop through active attributes
    for (var i = 0; i < activeAttributsCount; i++) {
      WebGLActiveInfo attribute = getActiveAttribInfo(i);
      result.attributes.add(attribute);
      result.attributeCount += attribute.size;//??
    }

    // Loop through active uniforms
    for (var i = 0; i < activeUnifromsCount; i++) {
      WebGLActiveInfo uniform = getActiveUniform(i);
      result.uniforms.add(uniform);
      result.uniformCount += uniform.size;//??
    }

    return result;
  }

  void initBindBuffer(String attributName, int usage, TypedData verticesInfos) {
    WebGLBuffer buffer = _initBuffer(buffers[attributName], usage, verticesInfos);
    buffers[attributName] ??= buffer;
  }

  /// BufferType bufferType
  /// Todo (jpu) : is it possible to use only one of the bufferViews
  WebGLBuffer _initBuffer(WebGLBuffer buffer,
      int bufferType, TypedData data) {
    if (buffer == null) {
      buffer = new WebGLBuffer();
      buffer.bindBuffer(bufferType);
      gl.bufferData(bufferType, data, BufferUsageType.STATIC_DRAW);
    } else {
      buffer.bindBuffer(bufferType);
    }

    return buffer;
  }

  /// [componentCount] => ex : 3 (x, y, z)
  /// ShaderVariableType componentType
  /// int stride :
  ///   how many bytes to move to the next vertex
  ///   0 = use the correct stride for type and numComponents
  void setAttribut(String attributName, int components, int componentType, bool normalized, int stride) {

    String shaderAttributName;
    if (attributName == 'TEXCOORD_0') {
      shaderAttributName = 'a_UV';
    } else if (attributName == "COLOR_0") {
      shaderAttributName = 'a_Color';
    } else {
      shaderAttributName = 'a_${UtilsText.capitalize(attributName)}';
    }

    //>
    attributLocations[attributName] ??=
        gl.getAttribLocation(webGLProgram, shaderAttributName);
    int attributLocation = attributLocations[attributName];

    //if exist
    if (attributLocation >= 0) {

      // start at the beginning of the buffer that contains the sent data in the initBuffer.
      // Do not take the accesors offset. Actually, one buffer is created by attribut so start at 0
      int offset = 0;

      //debug.logCurrentFunction(
      //'gl.vertexAttribPointer($attributLocation, $components, $componentType, $normalized, $stride, $offset);');
      //debug.logCurrentFunction('$accessor');

      //>
      gl.vertexAttribPointer(attributLocation, components, componentType,
          normalized, stride, offset);
      gl.enableVertexAttribArray(
          attributLocation); // turn on getting data out of a buffer for this attribute
    }
  }

  // >>> Parameteres
  //dynamic getParameter(ProgramParameterGlEnum parameter){
  //  return gl.getProgramParameter(webGLProgram, parameter);
  //}
  // >>> single getParameter

  // > DELETE_STATUS
  bool get deleteStatus => gl.getProgramParameter(webGLProgram, ProgramParameterGlEnum.DELETE_STATUS) as bool;
  // > LINK_STATUS
  bool get linkStatus => gl.getProgramParameter(webGLProgram, ProgramParameterGlEnum.LINK_STATUS) as bool;
  // > VALIDATE_STATUS
  bool get validateStatus => gl.getProgramParameter(webGLProgram, ProgramParameterGlEnum.VALIDATE_STATUS) as bool;
  // > ATTACHED_SHADERS
  int get attachedShadersCount => gl.getProgramParameter(webGLProgram, ProgramParameterGlEnum.ATTACHED_SHADERS) as int;
  // > ACTIVE_ATTRIBUTES
  int get activeAttributsCount => gl.getProgramParameter(webGLProgram, ProgramParameterGlEnum.ACTIVE_ATTRIBUTES) as int;
  // > ACTIVE_UNIFORMS
  int get activeUnifromsCount => gl.getProgramParameter(webGLProgram, ProgramParameterGlEnum.ACTIVE_UNIFORMS) as int;

  void logProgramInfos() {
    Debug.log("Program Infos", () {
      print('isProgram : ${isProgram}');
      print('linkStatus : ${linkStatus}');
      print('validateStatus : ${validateStatus}');
      print('deleteStatus : ${deleteStatus}');
      print('attachedShadersCount : ${attachedShadersCount}');

      print('##################################################################');
      print('activeAttributsCount : ${activeAttributsCount}');
      for (var i = 0; i < activeAttributsCount; i++) {
        print('-$i-');
        WebGLActiveInfo attribute = getActiveAttribInfo(i);
        print('${attribute}');
        WebGLAttributLocation attribLocation = getAttribLocation(attribute.name);
        attribLocation.logVertexAttributInfos();
      }

      print('##################################################################');
      print('activeUnifromsCount : ${activeUnifromsCount}');
      for (var i = 0; i < activeUnifromsCount; i++) {
        print('-$i-');
        WebGLActiveInfo activeInfo = getActiveUniform(i);
        print('${activeInfo}');
        WebGLUniformLocation uniformLocation = getUniformLocation(activeInfo.name);
//        print('getUniformLocation : ${uniformLocation}'); //Inutile car il n'y a aucune infos_todo associées
        print('getUniformValue : ${getUniformValue(uniformLocation)}');
      }

    });
  }

  static void logProgramFromWebGL(WebGL.Program webGLProgram){
    WebGLProgram _p = new WebGLProgram.fromWebGL(webGLProgram);
    _p.logProgramInfos();
    _p.delete();
  }
}
