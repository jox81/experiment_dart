import 'dart:html';
import 'dart:web_gl';
import 'package:vector_math/vector_math.dart';
import 'dart:typed_data';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/meshes.dart';
import 'package:webgl/src/models.dart';

void main() {
  Webgl01 webgl01 = new Webgl01(querySelector('#glCanvas'));
  webgl01.render();
}

class Webgl01 {

  Buffer vertexBuffer;
  Buffer indicesBuffer;

  List<Model> models = new List();

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
    gl.enable(RenderingContext.DEPTH_TEST);
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

  setupCamera() {
    Context.mainCamera = new Camera(radians(45.0), 0.1, 100.0)
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(0.0,5.0,10.0)
      ..cameraController = new CameraController();
  }

  void buildMeshData() {
    CustomObject customObject = new CustomObject()
      ..mesh = new Mesh()
      ..mesh.vertices = [
        0.0, 0.0, 0.0,
        0.0, 0.0, 3.0,
        2.0, 0.0, 0.0,
      ]
      ..mesh.vertexDimensions = 3
      ..mesh.indices = [0, 1, 2]
      ..transform = (new Matrix4.identity()..setTranslation(new Vector3(2.0,0.0,0.0)));
    models.add(customObject);
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
      shader = gl.createShader(RenderingContext.FRAGMENT_SHADER);
    } else if (shaderScript.type == "x-shader/x-vertex") {
      shader = gl.createShader(RenderingContext.VERTEX_SHADER);
    } else {
      return null;
    }

    gl.shaderSource(shader, shaderSource);
    gl.compileShader(shader);

    if (!gl.getShaderParameter(shader, RenderingContext.COMPILE_STATUS)) {
      window.alert(gl._getShaderInfoLog(shader));
      return null;
    }

    return shader;
  }

  void initBuffers() {
    List<num> vertices = models[0].mesh.vertices;
    List<int> indices = models[0].mesh.indices;

    vertexBuffer = gl.createBuffer();
    gl.bindBuffer(RenderingContext.ARRAY_BUFFER, vertexBuffer);
    gl.bufferData(
        RenderingContext.ARRAY_BUFFER, new Float32List.fromList(vertices), RenderingContext.STATIC_DRAW);
    gl.bindBuffer(RenderingContext.ARRAY_BUFFER, null);

    indicesBuffer = gl.createBuffer();
    gl.bindBuffer(RenderingContext.ELEMENT_ARRAY_BUFFER, indicesBuffer);
    gl.bufferData(RenderingContext.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(indices),
        RenderingContext.STATIC_DRAW);
    gl.bindBuffer(RenderingContext.ELEMENT_ARRAY_BUFFER, null);
  }

  /// Rendering part
  ///
  void _setMatrixUniforms() {
    gl.uniformMatrix4fv(pMatrixUniform, false, Context.mainCamera.perspectiveMatrix.storage);
    gl.uniformMatrix4fv(mvMatrixUniform, false, Context.mvMatrix.storage);
  }

  void render({num time : 0.0}) {
    gl.viewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
    gl.clear(RenderingContext.COLOR_BUFFER_BIT | RenderingContext.DEPTH_BUFFER_BIT);

    Context.mvMatrix = Context.mainCamera.lookAtMatrix * models[0].transform;

    gl.bindBuffer(RenderingContext.ARRAY_BUFFER, vertexBuffer);
    gl.bindBuffer(RenderingContext.ELEMENT_ARRAY_BUFFER, indicesBuffer);

    gl.vertexAttribPointer(
        vertexPositionAttribute, models[0].mesh.vertexDimensions, RenderingContext.FLOAT, false, 0, 0);

    _setMatrixUniforms();

    gl.drawElements(
        RenderingContext.TRIANGLES, models[0].mesh.indices.length, RenderingContext.UNSIGNED_SHORT, 0);

    window.requestAnimationFrame((num time) {
      this.render(time: time);
    });
  }

}

/// 1 vertexBuffer par objet
/// mvMatrix = viewMatrix * modelMatrix
/// camera en Right Hand