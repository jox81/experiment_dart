import 'dart:async';
import 'dart:html';
import 'dart:web_gl';
import 'package:vector_math/vector_math.dart';
import 'dart:typed_data';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/mesh.dart';

void main() {
  Webgl01 webgl01 = new Webgl01(querySelector('#glCanvas'));
  webgl01.render();
}

class Webgl01 {

  RenderingContext gl;

  Buffer vertexBuffer;
  Buffer indicesBuffer;

  List<Mesh> meshes = new List();

  Camera camera;

  Matrix4 _mvMatrix;

  Program shaderProgram;

  int vertexPositionAttribute;

  UniformLocation pMatrixUniform;
  UniformLocation mvMatrixUniform;

  Webgl01(CanvasElement canvas){

    initGL(canvas);

    setupCamera();

    buildMeshData();
    initShaders();
    initBuffers();


    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.enable(GL.DEPTH_TEST);
  }

  void initGL(CanvasElement canvas) {

    var names = ["webgl", "experimental-webgl", "webkit-3d", "moz-webgl"];
    for (var i = 0; i < names.length; ++i) {
      try {
        gl = canvas.getContext(names[i]);
      } catch (e) {}
      if (gl != null) {
        break;
      }
    }
    if (gl == null) {
      window.alert("Could not initialise WebGL");
      return null;
    }
  }

  Future setupCamera() async {
    camera = new Camera(radians(45.0), 0.1, 100.0)
      ..aspectRatio = gl.drawingBufferWidth / gl.drawingBufferHeight
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(0.0,5.0,10.0)
      ..cameraController = new CameraController(gl.canvas);
  }

  void buildMeshData() {
    Mesh mesh = new Mesh()
      ..vertices = [
        0.0, 0.0, 0.0,
        0.0, 0.0, 3.0,
        2.0, 0.0, 0.0,
      ]
      ..vertexDimensions = 3
      ..indices = [0, 1, 2]
      ..transform = (new Matrix4.identity()..setTranslation(new Vector3(0.0,0.0,0.0)));
    meshes.add(mesh);
  }

  void initShaders() {
    Shader fragmentShader = _getShader(gl, "shader-fs");
    Shader vertexShader = _getShader(gl, "shader-vs");

    shaderProgram = gl.createProgram();
    gl.attachShader(shaderProgram, vertexShader);
    gl.attachShader(shaderProgram, fragmentShader);
    gl.linkProgram(shaderProgram);

    if (!gl.getProgramParameter(shaderProgram, RenderingContext.LINK_STATUS)) {
      window.alert("Could not initialise shaders");
    }

    gl.useProgram(shaderProgram);

    vertexPositionAttribute =
        gl.getAttribLocation(shaderProgram, "aVertexPosition");
    gl.enableVertexAttribArray(vertexPositionAttribute);

    pMatrixUniform = gl.getUniformLocation(shaderProgram, "uPMatrix");
    mvMatrixUniform = gl.getUniformLocation(shaderProgram, "uMVMatrix");
  }

  _getShader(gl, id) {
    ScriptElement shaderScript = document.getElementById(id);
    if (shaderScript == null) {
      return null;
    }

    String shaderSource = shaderScript.text;

    Shader shader;
    if (shaderScript.type == "x-shader/x-fragment") {
      shader = gl.createShader(GL.FRAGMENT_SHADER);
    } else if (shaderScript.type == "x-shader/x-vertex") {
      shader = gl.createShader(GL.VERTEX_SHADER);
    } else {
      return null;
    }

    gl.shaderSource(shader, shaderSource);
    gl.compileShader(shader);

    if (!gl.getShaderParameter(shader, GL.COMPILE_STATUS)) {
      window.alert(gl._getShaderInfoLog(shader));
      return null;
    }

    return shader;
  }

  void initBuffers() {
    List<num> vertices = meshes[0].vertices;
    List<int> indices = meshes[0].indices;

    vertexBuffer = gl.createBuffer();
    gl.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
    gl.bufferData(
        GL.ARRAY_BUFFER, new Float32List.fromList(vertices), GL.STATIC_DRAW);
    gl.bindBuffer(GL.ARRAY_BUFFER, null);

    indicesBuffer = gl.createBuffer();
    gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indicesBuffer);
    gl.bufferData(GL.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(indices),
        GL.STATIC_DRAW);
    gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
  }

  /// Rendering part
  ///
  void _setMatrixUniforms() {
    gl.uniformMatrix4fv(pMatrixUniform, false, camera.perspectiveMatrix.storage);
    gl.uniformMatrix4fv(mvMatrixUniform, false, _mvMatrix.storage);
  }

  void render({num time : 0.0}) {
    gl.viewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
    gl.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);

    _mvMatrix = camera.lookAtMatrix * meshes[0].transform;

    gl.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
    gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indicesBuffer);

    gl.vertexAttribPointer(
        vertexPositionAttribute, meshes[0].vertexDimensions, GL.FLOAT, false, 0, 0);

    _setMatrixUniforms();

    gl.drawElements(
        GL.TRIANGLES, meshes[0].indices.length, GL.UNSIGNED_SHORT, 0);

    window.requestAnimationFrame((num time) {
      this.render(time: time);
    });
  }

}

/// 1 vertexBuffer par objet
/// mvMatrix = viewMatrix * modelMatrix
/// camera en Right Hand