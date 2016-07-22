import 'dart:web_gl';
import 'material.dart';
import 'application.dart';
import 'dart:typed_data';
import 'mesh.dart';
import 'package:vector_math/vector_math.dart';
import 'texture.dart';
import 'dart:async';
import 'light.dart';

class MaterialBase extends Material{

  static const String _vsSource = """
    attribute vec3 aVertexPosition;

    uniform mat4 uMVMatrix;
    uniform mat4 uPMatrix;

    void main(void) {
        gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
    }
    """;

  static const String _fsSource = """
    precision mediump float;

    void main(void) {
        gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
    }
    """;

  UniformLocation _uPMatrix;
  UniformLocation _uMVMatrix;

  Buffer _vertexPositionBuffer;
  int _aVertexPosition;

  Buffer _vertexIndiceBuffer;

  MaterialBase():super(_vsSource, _fsSource){
    _initBuffers();
    _getShaderSettings();
  }

  void _initBuffers(){
    _vertexPositionBuffer = gl.createBuffer();
    _vertexIndiceBuffer = gl.createBuffer();
  }

  void _getShaderSettings() {
    _getShaderAttributSettings();
    _getShaderUniformSettings();
  }

  void _getShaderAttributSettings() {
    _aVertexPosition = gl.getAttribLocation(program, "aVertexPosition");

  }

  void _getShaderUniformSettings(){
    _uPMatrix = gl.getUniformLocation(program, "uPMatrix");
    _uMVMatrix = gl.getUniformLocation(program, "uMVMatrix");
  }

  @override
  render(Mesh mesh) {

    gl.useProgram(program);
    _setShaderSettings(mesh);

    if(mesh.indices.length > 0) {
      gl.drawElements(
      RenderingContext.TRIANGLES, mesh.indices.length, RenderingContext.UNSIGNED_SHORT,
      0);
    }else{
      gl.drawArrays(mesh.mode, 0, mesh.vertexCount);
    }

    gl.disableVertexAttribArray(_aVertexPosition);
  }

  _setShaderSettings(Mesh mesh){
    _setShaderAttributs(mesh);
    _setShaderUniforms(mesh);
  }

  _setShaderAttributs(Mesh mesh) {
    //vertices
    gl.bindBuffer(RenderingContext.ARRAY_BUFFER, _vertexPositionBuffer);
    gl.enableVertexAttribArray(_aVertexPosition);
    gl.vertexAttribPointer(_aVertexPosition, mesh.vertexDimensions, RenderingContext.FLOAT, false, 0, 0);
    gl.bufferData(RenderingContext.ARRAY_BUFFER, new Float32List.fromList(mesh.vertices), RenderingContext.STATIC_DRAW);

    //indices
    gl.bindBuffer(RenderingContext.ELEMENT_ARRAY_BUFFER, _vertexIndiceBuffer);
    gl.bufferData(RenderingContext.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(mesh.indices), RenderingContext.STATIC_DRAW);
  }

  _setShaderUniforms(Mesh mesh) {
    gl.uniformMatrix4fv(_uPMatrix, false, Application.instance.mainCamera.matrix.storage);
    gl.uniformMatrix4fv(_uMVMatrix, false, mvMatrix.storage);
  }
}

class MaterialBaseColor extends Material{

  static const String _vsSource = """
    attribute vec3 aVertexPosition;

    uniform mat4 uMVMatrix;
    uniform mat4 uPMatrix;

    void main(void) {
        gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
    }
    """;

  static const String _fsSource = """
    precision mediump float;

    uniform vec3 color;

    void main(void) {
        gl_FragColor = vec4(color, 1.0);
    }
    """;
  final Vector3 color;

  UniformLocation _uPMatrix;
  UniformLocation _uMVMatrix;
  UniformLocation _uColor;

  Buffer _vertexPositionBuffer;
  int _aVertexPosition;

  Buffer _vertexIndiceBuffer;

  MaterialBaseColor(this.color ):super(_vsSource, _fsSource){
    _initBuffers();
    _getShaderSettings();
  }

  void _initBuffers(){
    _vertexPositionBuffer = gl.createBuffer();
    _vertexIndiceBuffer = gl.createBuffer();
  }

  void _getShaderSettings() {
    _getShaderAttributSettings();
    _getShaderUniformSettings();
  }

  void _getShaderAttributSettings() {
    _aVertexPosition = gl.getAttribLocation(program, "aVertexPosition");

  }

  void _getShaderUniformSettings(){
    _uPMatrix = gl.getUniformLocation(program, "uPMatrix");
    _uMVMatrix = gl.getUniformLocation(program, "uMVMatrix");
    _uColor = gl.getUniformLocation(program, "color");
  }

  @override
  render(Mesh mesh) {

    gl.useProgram(program);
    _setShaderSettings(mesh);

    if(mesh.indices.length > 0) {
      gl.drawElements(
          RenderingContext.TRIANGLES, mesh.indices.length, RenderingContext.UNSIGNED_SHORT,
          0);
    }else{
      gl.drawArrays(mesh.mode, 0, mesh.vertexCount);
    }

    gl.disableVertexAttribArray(_aVertexPosition);
  }

  _setShaderSettings(Mesh mesh){
    _setShaderAttributs(mesh);
    _setShaderUniforms(mesh);
  }

  _setShaderAttributs(Mesh mesh) {
    //vertices
    gl.bindBuffer(RenderingContext.ARRAY_BUFFER, _vertexPositionBuffer);
    gl.enableVertexAttribArray(_aVertexPosition);
    gl.vertexAttribPointer(_aVertexPosition, mesh.vertexDimensions, RenderingContext.FLOAT, false, 0, 0);
    gl.bufferData(RenderingContext.ARRAY_BUFFER, new Float32List.fromList(mesh.vertices), RenderingContext.STATIC_DRAW);

    //indices
    gl.bindBuffer(RenderingContext.ELEMENT_ARRAY_BUFFER, _vertexIndiceBuffer);
    gl.bufferData(RenderingContext.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(mesh.indices), RenderingContext.STATIC_DRAW);
  }

  _setShaderUniforms(Mesh mesh) {
    gl.uniformMatrix4fv(_uPMatrix, false, Application.instance.mainCamera.matrix.storage);
    gl.uniformMatrix4fv(_uMVMatrix, false, mvMatrix.storage);
    gl.uniform3fv(_uColor, color.storage);
  }
}

class MaterialBaseVertexColor extends Material{

  static const String _vsSource = """
    attribute vec3 aVertexPosition;
    attribute vec4 aVertexColor;

    uniform mat4 uMVMatrix;
    uniform mat4 uPMatrix;

    varying vec4 vColor;

    void main(void) {
      gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
      vColor = aVertexColor;
    }
    """;

  static const String _fsSource = """
    precision mediump float;

    varying vec4 vColor;

    void main(void) {
      gl_FragColor = vColor;
    }
    """;

  UniformLocation _uPMatrix;
  UniformLocation _uMVMatrix;

  Buffer _vertexPositionBuffer;
  int _aVertexPosition;

  Buffer _vertexColorBuffer;
  int _attribVertexColor;

  Buffer _vertexIndiceBuffer;

  MaterialBaseVertexColor():super(_vsSource, _fsSource){
    _initBuffers();
    _getShaderSettings();
  }

  void _initBuffers(){
    _vertexPositionBuffer = gl.createBuffer();
    _vertexColorBuffer = gl.createBuffer();
    _vertexIndiceBuffer = gl.createBuffer();
  }

  void _getShaderSettings() {
    _getShaderAttributSettings();
    _getShaderUniformSettings();
  }

  void _getShaderAttributSettings() {
    _aVertexPosition = gl.getAttribLocation(program, "aVertexPosition");


    _attribVertexColor = gl.getAttribLocation(program, "aVertexColor");

  }

  void _getShaderUniformSettings() {
    _uPMatrix = gl.getUniformLocation(program, "uPMatrix");
    _uMVMatrix = gl.getUniformLocation(program, "uMVMatrix");
  }

  @override
  render(Mesh mesh) {

    gl.useProgram(program);
    _setShaderSettings(mesh);

    if(mesh.indices.length > 0) {
      gl.drawElements(
          RenderingContext.TRIANGLES, mesh.indices.length, RenderingContext.UNSIGNED_SHORT,
          0);
    }else{
      gl.drawArrays(mesh.mode, 0, mesh.vertexCount);
    }
  }

  _setShaderSettings(Mesh mesh){
    _setShaderAttributs(mesh);
    _setShaderUniforms(mesh);
  }

  _setShaderAttributs(Mesh mesh) {
    //vertices
    gl.bindBuffer(RenderingContext.ARRAY_BUFFER, _vertexPositionBuffer);
    gl.enableVertexAttribArray(_aVertexPosition);
    gl.vertexAttribPointer(_aVertexPosition, mesh.vertexDimensions, RenderingContext.FLOAT, false, 0, 0);
    gl.bufferData(RenderingContext.ARRAY_BUFFER, new Float32List.fromList(mesh.vertices), RenderingContext.STATIC_DRAW);

    //colors
    gl.bindBuffer(RenderingContext.ARRAY_BUFFER, _vertexColorBuffer);
    gl.enableVertexAttribArray(_attribVertexColor);
    gl.vertexAttribPointer(_attribVertexColor, mesh.colorDimensions, RenderingContext.FLOAT, false, 0, 0);
    gl.bufferData(RenderingContext.ARRAY_BUFFER, new Float32List.fromList(mesh.colors), RenderingContext.STATIC_DRAW);

    //indices
    gl.bindBuffer(RenderingContext.ELEMENT_ARRAY_BUFFER, _vertexIndiceBuffer);
    gl.bufferData(RenderingContext.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(mesh.indices), RenderingContext.STATIC_DRAW);
  }

  _setShaderUniforms(Mesh mesh) {
    gl.uniformMatrix4fv(_uPMatrix, false, Application.instance.mainCamera.matrix.storage);
    gl.uniformMatrix4fv(_uMVMatrix, false, mvMatrix.storage);
  }
}

class MaterialBaseTexture extends Material{

  static const String _vsSource = """
    attribute vec3 aVertexPosition;
    attribute vec2 aTextureCoord;

    uniform mat4 uMVMatrix;
    uniform mat4 uPMatrix;

    varying vec2 vTextureCoord;

    void main(void) {
      gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
      vTextureCoord = aTextureCoord;
    }
    """;

  static const String _fsSource = """
    precision mediump float;

    varying vec2 vTextureCoord;

    uniform sampler2D uSampler;

    void main(void) {
      gl_FragColor = texture2D(uSampler, vec2(vTextureCoord.s, vTextureCoord.t));
    }
    """;

  UniformLocation _uPMatrix;
  UniformLocation _uMVMatrix;

  Buffer _vertexPositionBuffer;
  int _aVertexPosition;

  Buffer _vertexIndiceBuffer;

  Buffer _vertexTextureCoordBuffer;
  int _aTextureCoord;
  UniformLocation _uSampler;

  //External parameters
  TextureMap textureMap;

  MaterialBaseTexture():super(_vsSource, _fsSource){
    _initBuffers();
    _getShaderSettings();
  }

  void _initBuffers(){
    _vertexPositionBuffer = gl.createBuffer();
    _vertexIndiceBuffer = gl.createBuffer();
    _vertexTextureCoordBuffer = gl.createBuffer();
  }

  void _getShaderSettings() {
    _getShaderAttributSettings();
    _getShaderUniformSettings();
  }

  void _getShaderAttributSettings() {
    _aVertexPosition = gl.getAttribLocation(program, "aVertexPosition");


    //Texture
    _aTextureCoord = gl.getAttribLocation(program, "aTextureCoord");

  }

  void _getShaderUniformSettings() {
    _uPMatrix = gl.getUniformLocation(program, "uPMatrix");
    _uMVMatrix = gl.getUniformLocation(program, "uMVMatrix");

    _uSampler = gl.getUniformLocation(program, "uSampler");
  }

  @override
  render(Mesh mesh) {

    gl.useProgram(program);
    _setShaderSettings(mesh);

    if(mesh.indices.length > 0) {
      gl.drawElements(
      RenderingContext.TRIANGLES, mesh.indices.length, RenderingContext.UNSIGNED_SHORT,
      0);
    }else{
      gl.drawArrays(mesh.mode, 0, mesh.vertexCount);
    }

    gl.disableVertexAttribArray(_aVertexPosition);
    gl.disableVertexAttribArray(_aTextureCoord);
  }

  _setShaderSettings(Mesh mesh){
    _setShaderAttributs(mesh);
    _setShaderUniforms(mesh);
  }

  _setShaderAttributs(Mesh mesh) {
    //vertices
    gl.bindBuffer(RenderingContext.ARRAY_BUFFER, _vertexPositionBuffer);
    gl.enableVertexAttribArray(_aVertexPosition);
    gl.bufferData(RenderingContext.ARRAY_BUFFER, new Float32List.fromList(mesh.vertices), RenderingContext.STATIC_DRAW);
    gl.vertexAttribPointer(_aVertexPosition, mesh.vertexDimensions, RenderingContext.FLOAT, false, 0, 0);

    //indices
    gl.bindBuffer(RenderingContext.ELEMENT_ARRAY_BUFFER, _vertexIndiceBuffer);
    gl.bufferData(RenderingContext.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(mesh.indices), RenderingContext.STATIC_DRAW);

    //Texture
    gl.bindBuffer(RenderingContext.ARRAY_BUFFER, _vertexTextureCoordBuffer);
    gl.enableVertexAttribArray(_aTextureCoord);
    gl.bufferData(RenderingContext.ARRAY_BUFFER, new Float32List.fromList(mesh.textureCoords), RenderingContext.STATIC_DRAW);
    gl.vertexAttribPointer(_aTextureCoord, mesh.textureCoordsDimensions, RenderingContext.FLOAT, false, 0, 0);
    gl.activeTexture(RenderingContext.TEXTURE0);
    gl.bindTexture(RenderingContext.TEXTURE_2D, textureMap.texture);
  }

  _setShaderUniforms(Mesh mesh) {
    gl.uniform1i(_uSampler, 0);

    gl.uniformMatrix4fv(_uPMatrix, false, Application.instance.mainCamera.matrix.storage);
    gl.uniformMatrix4fv(_uMVMatrix, false, mvMatrix.storage);
  }

  Future addTexture(String fileName) {
    Completer completer = new Completer();
    TextureMap.initTexture(fileName, (textureMapResult){
      textureMap = textureMapResult;
      completer.complete();
    });

    return completer.future;
  }
}

class MaterialBaseTextureNormal extends Material{

  static const String _vsSource = """
    attribute vec3 aVertexPosition;
    attribute vec2 aTextureCoord;
    attribute vec3 aVertexNormal;

    uniform mat4 uMVMatrix;
    uniform mat4 uPMatrix;
    uniform mat3 uNMatrix;

    uniform vec3 uAmbientColor;

    uniform vec3 uLightingDirection;
    uniform vec3 uDirectionalColor;

    uniform bool uUseLighting;

    varying vec2 vTextureCoord;
    varying vec3 vLightWeighting;

    void main(void) {
      gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
      vTextureCoord = aTextureCoord;
      if(!uUseLighting)
      {
         vLightWeighting = vec3(1.0, 1.0, 1.0);
      } else
      {
         vec3 transformedNormal = uNMatrix * aVertexNormal;
         float directionalLightWeighting = max(dot(transformedNormal, uLightingDirection), 0.0);
         vLightWeighting = uAmbientColor + uDirectionalColor*directionalLightWeighting;
      }
    }
    """;

  static const String _fsSource = """
    precision mediump float;

    varying vec2 vTextureCoord;
    varying vec3 vLightWeighting;

    uniform sampler2D uSampler;

    void main(void) {
      vec4 textureColor = texture2D(uSampler, vec2(vTextureCoord.s, vTextureCoord.t));
      gl_FragColor = vec4(textureColor.rgb * vLightWeighting, textureColor.a);
    }
    """;

  UniformLocation _uPMatrix;
  UniformLocation _uMVMatrix;

  //Vertices Position
  Buffer _vertexPositionBuffer;
  int _aVertexPosition;

  //Indices
  Buffer _vertexIndiceBuffer;

  //TextureCoords
  Buffer _vertexTextureCoordBuffer;
  int _aTextureCoord;
  UniformLocation _uSampler;

  //Normals
  UniformLocation _uNMatrix;
  Buffer _vertexNormalBuffer;
  int _aVertexNormal;

  //Lightings
  UniformLocation _uUseLighting;
  UniformLocation _uLightDirection;
  UniformLocation _uAmbientColor;
  UniformLocation _uDirectionalColor;

  //External Parameters
  TextureMap textureMap;
  Vector3 ambientColor;
  DirectionalLight directionalLight;
  bool useLighting;

  MaterialBaseTextureNormal():super(_vsSource, _fsSource){
    _initBuffers();
    _getShaderSettings();
  }

  void _initBuffers(){
    _vertexPositionBuffer = gl.createBuffer();
    _vertexIndiceBuffer = gl.createBuffer();
    _vertexTextureCoordBuffer = gl.createBuffer();
    _vertexNormalBuffer = gl.createBuffer();
  }

  void _getShaderSettings() {
    _getShaderAttributSettings();
    _getShaderUniformSettings();
  }

  void _getShaderUniformSettings(){
    //ModelViewProjection
    _uPMatrix = gl.getUniformLocation(program, "uPMatrix");
    _uMVMatrix = gl.getUniformLocation(program, "uMVMatrix");

    //Texture
    _uSampler = gl.getUniformLocation(program, "uSampler");

    //Normals
    _uNMatrix = gl.getUniformLocation(program, "uNMatrix");

    //Lighting
    _uUseLighting = gl.getUniformLocation(program, "uUseLighting");
    _uAmbientColor = gl.getUniformLocation(program, "uAmbientColor");
    _uLightDirection = gl.getUniformLocation(program, "uLightingDirection");
    _uDirectionalColor = gl.getUniformLocation(program, "uDirectionalColor");
  }

  void _getShaderAttributSettings(){
    _aVertexPosition = gl.getAttribLocation(program, "aVertexPosition");


    //Texture
    _aTextureCoord = gl.getAttribLocation(program, "aTextureCoord");


    //Normals
    _aVertexNormal = gl.getAttribLocation(program, "aVertexNormal");

  }

  @override
  render(Mesh mesh) {

    gl.useProgram(program);
    _setShaderSettings(mesh);

    if(mesh.indices.length > 0) {
      gl.drawElements(
      RenderingContext.TRIANGLES, mesh.indices.length, RenderingContext.UNSIGNED_SHORT,
      0);
    }else{
      gl.drawArrays(mesh.mode, 0, mesh.vertexCount);
    }

    gl.disableVertexAttribArray(_aTextureCoord);
    gl.disableVertexAttribArray(_aTextureCoord);
    gl.disableVertexAttribArray(_aVertexNormal);
  }

  _setShaderSettings(Mesh mesh){
    _setShaderAttributs(mesh);
    _setShaderUniforms(mesh);
  }

  _setShaderAttributs(Mesh mesh) {
    //vertices
    gl.bindBuffer(RenderingContext.ARRAY_BUFFER, _vertexPositionBuffer);
    gl.enableVertexAttribArray(_aVertexPosition);
    gl.bufferData(RenderingContext.ARRAY_BUFFER, new Float32List.fromList(mesh.vertices), RenderingContext.STATIC_DRAW);
    gl.vertexAttribPointer(_aVertexPosition, mesh.vertexDimensions, RenderingContext.FLOAT, false, 0, 0);

    //indices
    gl.bindBuffer(RenderingContext.ELEMENT_ARRAY_BUFFER, _vertexIndiceBuffer);
    gl.bufferData(RenderingContext.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(mesh.indices), RenderingContext.STATIC_DRAW);

    //Texture
    gl.bindBuffer(RenderingContext.ARRAY_BUFFER, _vertexTextureCoordBuffer);
    gl.enableVertexAttribArray(_aTextureCoord);
    gl.bufferData(RenderingContext.ARRAY_BUFFER, new Float32List.fromList(mesh.textureCoords), RenderingContext.STATIC_DRAW);
    gl.vertexAttribPointer(_aTextureCoord, mesh.textureCoordsDimensions, RenderingContext.FLOAT, false, 0, 0);

    gl.activeTexture(RenderingContext.TEXTURE0);
    gl.bindTexture(RenderingContext.TEXTURE_2D, textureMap.texture);

    //Normals
    gl.bindBuffer(RenderingContext.ARRAY_BUFFER, _vertexNormalBuffer);
    gl.enableVertexAttribArray(_aVertexNormal);
    gl.bufferData(RenderingContext.ARRAY_BUFFER, new Float32List.fromList(mesh.vertexNormals), RenderingContext.STATIC_DRAW);
    gl.vertexAttribPointer(_aVertexNormal, mesh.vertexNormalsDimensions, RenderingContext.FLOAT, false, 0, 0);
  }

  _setShaderUniforms(Mesh mesh) {
    gl.uniformMatrix4fv(_uPMatrix, false, Application.instance.mainCamera.matrix.storage);
    gl.uniformMatrix4fv(_uMVMatrix, false, mvMatrix.storage);

    Matrix4 mvInverse = new Matrix4.identity();
    mvInverse.copyInverse(mvMatrix);
    Matrix3 normalMatrix = mvInverse.getRotation();

    normalMatrix.transpose();
    gl.uniformMatrix3fv(_uNMatrix, false, normalMatrix.storage);

    //Light

    // draw lighting?
    gl.uniform1i(_uUseLighting, useLighting ? 1 : 0); // must be int, not bool

    if (useLighting) {
      gl.uniform3f(
          _uAmbientColor,
          ambientColor.r,
          ambientColor.g,
          ambientColor.b
      );

      Vector3 adjustedLD = new Vector3.zero();
      directionalLight.direction.normalizeInto(adjustedLD);
      adjustedLD.scale(-1.0);

      //Float32List f32LD = new Float32List(3);
      //adjustedLD.copyIntoArray(f32LD);
      //_gl.uniform3fv(_uLightDirection, f32LD);

      gl.uniform3f(_uLightDirection, adjustedLD.x, adjustedLD.y, adjustedLD.z);

      gl.uniform3f(
          _uDirectionalColor, directionalLight.color.r, directionalLight.color.g, directionalLight.color.b
      );
    }
  }

  Future addTexture(String fileName) {
    Completer completer = new Completer();
    TextureMap.initTexture(fileName, (textureMapResult){
      textureMap = textureMapResult;
      completer.complete();
    });

    return completer.future;
  }
}
