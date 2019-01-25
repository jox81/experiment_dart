import 'dart:html';
import 'dart:typed_data';
import "package:test/test.dart";
import 'package:webgl/src/context.dart';
import 'package:webgl/src/utils/utils_assets.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum_wrapped.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'dart:web_gl' as webgl;

@TestOn("browser")

void main() {

  assetManager.useWebPath = true;

  CanvasElement canvas;

  setUp(() async {

    canvas = new Element.html('<canvas/>') as CanvasElement;
    canvas.width = 10;
    canvas.height = 10;

    Context.init(canvas,enableExtensions:true,logInfos:false);
  });

  tearDown(() async {
    gl = null;
    canvas = null;
  });

  group("WebGLProgram CTOR", () {
    // >> base

    test("WebGLUniformLocation CTOR base", () {
      WebGLProgram program = new WebGLProgram();
      expect(program, isNotNull);
    });

    // >> fromWebGL

    test("WebGLUniformLocation CTOR fromWebGL", () {
      webgl.Program webGLProgram = gl.createProgram();
      WebGLProgram program = new WebGLProgram.fromWebGL(webGLProgram);
      expect(program, isNotNull);
    });

    // >> pure webgl tests

    test("create program", () {
      webgl.Program program;
      expect(gl.isProgram(program), false);
      program = gl.createProgram();
      expect(program, isNotNull);
      expect(gl.isProgram(program), true);
      gl.deleteProgram(program);
      /// Effectively, progam is not released to a null element, but is no more recognized as a valid program
      expect(program, isNotNull);
      expect(gl.isProgram(program), false);
    });
//      expect(gl.getProgramInfoLog(program), "");
  });
  group("getProgramParameter", () {
    test("DELETE_STATUS", () {
      webgl.Program program;
      bool result;

      /// if no program exist, result is null
      result = gl.getProgramParameter(program, webgl.WebGL.DELETE_STATUS) as bool;
      expect(result, null);

      program = gl.createProgram();

      result = gl.getProgramParameter(program, webgl.WebGL.DELETE_STATUS) as bool;
      expect(result, false);

      gl.deleteProgram(program);

      /// when deleted, program doesn't exist anymore, result is null
      result = gl.getProgramParameter(program, webgl.WebGL.DELETE_STATUS) as bool;
      expect(result, null);
    });
  });

  group("webgl shaders", () {

    test("createShader / deleteShader", () {
      webgl.Shader vertexShader = gl.createShader(webgl.WebGL.VERTEX_SHADER);
      expect(gl.isShader(vertexShader), true);

      gl.deleteShader(vertexShader);
      expect(gl.isShader(vertexShader), false);

      webgl.Shader fragmentShader = gl.createShader(webgl.WebGL.FRAGMENT_SHADER);
      expect(gl.isShader(fragmentShader), true);

      gl.deleteShader(fragmentShader);
      expect(gl.isShader(fragmentShader), false);
    });

  });

  group("webgl shaders", () {
    test("getShaderParameter", () {

      //> vertex shader
      //language=glsl
      String vertexShaderSource = '''
        attribute vec3 aVertexPosition;
        attribute vec2 aTextureCoord;
        
        uniform mat4 uModelViewMatrix;
        uniform mat4 uProjectionMatrix;
        
        uniform mat4 uTextureMatrix;
        
        varying vec2 vTextureCoord;
        
        void main(void) {
          gl_Position = uProjectionMatrix * uModelViewMatrix * vec4(aVertexPosition, 1.0);
          vTextureCoord = (uTextureMatrix * vec4(aTextureCoord, 0, 1)).xy;
        }
      ''';

      //> fragment shader
      //language=glsl
      String fragmentShaderSource = '''
        precision mediump float;
  
        uniform sampler2D uSampler;
        uniform float test;
        
        varying vec2 vTextureCoord;
        
        void main(void) {
          gl_FragColor = texture2D(uSampler, vTextureCoord * test);
        }
      ''';

      webgl.Program program = getProgram(vertexShaderSource, fragmentShaderSource);



      //> uniforms

      int activeUniformCount = gl.getProgramParameter( program, webgl.WebGL.ACTIVE_UNIFORMS) as int;
      expect(activeUniformCount, 5); // This is count of the combination of uniforms in vs + fs

      for (int i = 0; i < activeUniformCount; ++i) {
        webgl.ActiveInfo uniformActiveInfos = gl.getActiveUniform(program, i);
        print('uniformActiveInfos : $i');
        print('uniformActiveInfos.name = ${uniformActiveInfos.name}');
        print('uniformActiveInfos.size = ${uniformActiveInfos.size}');
        print('uniformActiveInfos.type = ${uniformActiveInfos.type}');
        webgl.UniformLocation uniformLocationSampler = gl.getUniformLocation(program, uniformActiveInfos.name);
        var uniformValue = gl.getUniform(program, uniformLocationSampler);
        print('uniformValue : $uniformValue');
        print('');
      }

      /// Preuve qu'on ne peut pas assigner une valeur à un program qui n'est pas connecté
      webgl.UniformLocation uniformLocationTest = gl.getUniformLocation(program, 'test');
      gl.uniform1f(uniformLocationTest, 2.3);
      num uniformValue = gl.getUniform(program, uniformLocationTest) as num;
      print('uniformValue : $uniformValue');
      expect(uniformValue, 0.0);

      ///Maintenant, on connecte le program et on assigne une valeur
      gl.useProgram(program);

      gl.uniform1f(uniformLocationTest, 2.3);
      uniformValue = gl.getUniform(program, uniformLocationTest) as num;
      print('uniformValue : $uniformValue');
      expect(num.parse(uniformValue.toStringAsPrecision(2)), 2.3);

      /// on connecte un autre program
      webgl.Program program2 = getProgram(vertexShaderSource, fragmentShaderSource);
      webgl.UniformLocation uniformLocationTest2 = gl.getUniformLocation(program2, 'test');
      gl.useProgram(program2);
      gl.uniform1f(uniformLocationTest2, 6.1);
      num uniformValueTest2 = gl.getUniform(program2, uniformLocationTest2) as num;
      expect(num.parse(uniformValueTest2.toStringAsPrecision(2)), 6.1);

      /// preuve que l'uniformLocation est toujours attribué un premier program et donc,
      /// on essaye de nouveau d'assigner une valeur, comme le program n'est pas connecté, sa valeur ne change pas
      /// donc, preuve que le premier program déconnecté a toujours la bonne valeur assignée
      gl.uniform1f(uniformLocationTest, 5.7);
      uniformValue = gl.getUniform(program, uniformLocationTest) as num;
      expect(num.parse(uniformValue.toStringAsPrecision(2)) == 5.7, false);
      expect(num.parse(uniformValue.toStringAsPrecision(2)), 2.3);
      print('uniformValue : $uniformValue');
      print('gl.getError : ${ErrorCode.getByIndex(gl.getError())}');

      /// On peut en conclure aussi qu'un uniformLocation reste connecté au program correspondant
      num locationValueA = gl.getUniform(program, uniformLocationTest) as num;
      print('locationValueA : $locationValueA');
      expect(num.parse(locationValueA.toStringAsPrecision(2)), 2.3);
      print('gl.getError : ${ErrorCode.getByIndex(gl.getError())}');

      num locationValueB = gl.getUniform(program2, uniformLocationTest) as num;
      print('locationValueB : $locationValueB');
      expect(locationValueB, isNull, reason: "l'uniform ne correspond pas on bon program");
      print('gl.getError : ${ErrorCode.getByIndex(gl.getError())}');

      num locationValueC = gl.getUniform(program, uniformLocationTest2) as num;
      print('locationValueC : $locationValueC');
      expect(locationValueC, isNull, reason: "l'uniform ne correspond pas on bon program");
      print('gl.getError : ${ErrorCode.getByIndex(gl.getError())}');

      num locationValueD = gl.getUniform(program2, uniformLocationTest2) as num;
      print('locationValueD : $locationValueD');
      expect(num.parse(locationValueD.toStringAsPrecision(2)), 6.1);
      print('gl.getError : ${ErrorCode.getByIndex(gl.getError())}');


      //> attributs


      //infos sur les vertexAttrib du vertex shader
      int activeAttributsCount = gl.getProgramParameter( program, webgl.WebGL.ACTIVE_ATTRIBUTES) as int;
      expect(activeAttributsCount, 2); // count of attributs in the program

      for (int i = 0; i < activeAttributsCount; ++i) {
        webgl.ActiveInfo attributActiveInfos = gl.getActiveAttrib(program, i);
        print('attributActiveInfos : $i');
        print('attributActiveInfos.name = ${attributActiveInfos.name}');
        print('attributActiveInfos.size = ${attributActiveInfos.size}');
        print('attributActiveInfos.type = ${attributActiveInfos.type}');
        int attributLocation = gl.getAttribLocation(program, attributActiveInfos.name);
        var vertexAttribValue = gl.getVertexAttrib(attributLocation, webgl.WebGL.ARRAY_BUFFER);
        print('vertexAttribValue : $vertexAttribValue');
        print('');
      }

      // Todo (jpu) :tester les vertexAttribPointer si ils restent stockés dans le shader, le programa, le buffer ?

      Float32List vertices =  new Float32List.fromList([
        0.0, 1.0, 0.6,
        0.2, 0.3, 0.7
      ]);

      webgl.Buffer buffer = gl.createBuffer();
      gl.bindBuffer(webgl.WebGL.ARRAY_BUFFER, buffer);
      gl.vertexAttribPointer(0, 3, webgl.WebGL.FLOAT, false, 3 * 4, 0);
      gl.enableVertexAttribArray(0);
      gl.bufferData(webgl.WebGL.ARRAY_BUFFER, vertices, webgl.WebGL.STATIC_DRAW);

      int attributLocation = gl.getAttribLocation(program, 'aVertexPosition');
      print('VERTEX_ATTRIB_ARRAY_BUFFER_BINDING : ${gl.getVertexAttrib(attributLocation, webgl.WebGL.VERTEX_ATTRIB_ARRAY_BUFFER_BINDING)}');
      print('VERTEX_ATTRIB_ARRAY_ENABLED : ${gl.getVertexAttrib(attributLocation, webgl.WebGL.VERTEX_ATTRIB_ARRAY_ENABLED)}');
      print('VERTEX_ATTRIB_ARRAY_SIZE : ${gl.getVertexAttrib(attributLocation, webgl.WebGL.VERTEX_ATTRIB_ARRAY_SIZE)}');
      print('VERTEX_ATTRIB_ARRAY_STRIDE : ${gl.getVertexAttrib(attributLocation, webgl.WebGL.VERTEX_ATTRIB_ARRAY_STRIDE)}');
      print('VERTEX_ATTRIB_ARRAY_TYPE : ${gl.getVertexAttrib(attributLocation, webgl.WebGL.VERTEX_ATTRIB_ARRAY_TYPE)}');
      print('VERTEX_ATTRIB_ARRAY_NORMALIZED : ${gl.getVertexAttrib(attributLocation, webgl.WebGL.VERTEX_ATTRIB_ARRAY_NORMALIZED)}');
      print('CURRENT_VERTEX_ATTRIB : ${gl.getVertexAttrib(attributLocation, webgl.WebGL.CURRENT_VERTEX_ATTRIB)}');
      print('VERTEX_ATTRIB_ARRAY_POINTER : ${gl.getVertexAttribOffset(attributLocation, webgl.WebGL.VERTEX_ATTRIB_ARRAY_POINTER)}');

      // on connecte un autre buffer
      webgl.Buffer buffer2 = gl.createBuffer();
      gl.bindBuffer(webgl.WebGL.ARRAY_BUFFER, buffer2);

      // on teste les infos sur le premier buffer et on constate que les infos sont aussi gardées dans la mémoire du program
      print('');
      attributLocation = gl.getAttribLocation(program, 'aVertexPosition');
      print('VERTEX_ATTRIB_ARRAY_BUFFER_BINDING : ${gl.getVertexAttrib(attributLocation, webgl.WebGL.VERTEX_ATTRIB_ARRAY_BUFFER_BINDING)}');
      print('VERTEX_ATTRIB_ARRAY_ENABLED : ${gl.getVertexAttrib(attributLocation, webgl.WebGL.VERTEX_ATTRIB_ARRAY_ENABLED)}');
      print('VERTEX_ATTRIB_ARRAY_SIZE : ${gl.getVertexAttrib(attributLocation, webgl.WebGL.VERTEX_ATTRIB_ARRAY_SIZE)}');
      print('VERTEX_ATTRIB_ARRAY_STRIDE : ${gl.getVertexAttrib(attributLocation, webgl.WebGL.VERTEX_ATTRIB_ARRAY_STRIDE)}');
      print('VERTEX_ATTRIB_ARRAY_TYPE : ${gl.getVertexAttrib(attributLocation, webgl.WebGL.VERTEX_ATTRIB_ARRAY_TYPE)}');
      print('VERTEX_ATTRIB_ARRAY_NORMALIZED : ${gl.getVertexAttrib(attributLocation, webgl.WebGL.VERTEX_ATTRIB_ARRAY_NORMALIZED)}');
      print('CURRENT_VERTEX_ATTRIB : ${gl.getVertexAttrib(attributLocation, webgl.WebGL.CURRENT_VERTEX_ATTRIB)}');
      print('VERTEX_ATTRIB_ARRAY_POINTER : ${gl.getVertexAttribOffset(attributLocation, webgl.WebGL.VERTEX_ATTRIB_ARRAY_POINTER)}');

      gl.deleteProgram(program);

    });

  });

}

webgl.Program getProgram(String vertexShaderSource, String fragmentShaderSource){

  expect(vertexShaderSource, isNotNull);
  expect(fragmentShaderSource, isNotNull);

  //> vertex shader

  webgl.Shader vertexShader = gl.createShader(webgl.WebGL.VERTEX_SHADER);

  expect(gl.getShaderParameter(vertexShader, webgl.WebGL.SHADER_TYPE) as int, webgl.WebGL.VERTEX_SHADER);

  gl.shaderSource(vertexShader, vertexShaderSource);
  gl.compileShader(vertexShader);

  String errorVertexShader = gl.getShaderInfoLog(vertexShader);
  print('errorVertexShader : $errorVertexShader');
  expect(errorVertexShader.length, 0);

  expect(gl.getShaderParameter(vertexShader, webgl.WebGL.COMPILE_STATUS) as bool, true);

  //> fragment shader

  webgl.Shader fragmentShader = gl.createShader(webgl.WebGL.FRAGMENT_SHADER);

  expect(gl.getShaderParameter(fragmentShader, webgl.WebGL.SHADER_TYPE) as int, webgl.WebGL.FRAGMENT_SHADER);

  gl.shaderSource(fragmentShader, fragmentShaderSource);
  gl.compileShader(fragmentShader);

  String errorFragmentShader = gl.getShaderInfoLog(fragmentShader);
  print('errorFragmentShader : $errorFragmentShader');
  expect(errorFragmentShader.length, 0);

  gl.getShaderInfoLog(fragmentShader);

  expect(gl.getShaderParameter(fragmentShader, webgl.WebGL.COMPILE_STATUS) as bool, true);

  //> program

  webgl.Program program = gl.createProgram();

  gl.attachShader(program, vertexShader);
  gl.attachShader(program, fragmentShader);

  gl.linkProgram(program);
  gl.validateProgram(program);

  print(gl.getProgramInfoLog(program));

  expect(gl.getProgramParameter( program, webgl.WebGL.LINK_STATUS) as bool, true);
  expect(gl.getProgramParameter( program, webgl.WebGL.VALIDATE_STATUS) as bool, true);

  expect(gl.getProgramParameter( program, webgl.WebGL.ATTACHED_SHADERS) as int, 2);

  return program;
}