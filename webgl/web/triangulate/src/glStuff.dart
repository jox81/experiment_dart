import 'mesh.dart';
import 'dart:html';
import 'dart:web_gl';
import 'package:vector_math/vector_math.dart';
import 'dart:typed_data';
import 'package:gl_enums/gl_enums.dart' as GL;

RenderingContext gl;

List<Mesh> meshes = new List();

Program shaderProgram;

Matrix4 mvMatrix = new Matrix4.identity();
Matrix4 pMatrix = new Matrix4.identity();

int vertexPositionAttribute;

UniformLocation pMatrixUniform;
UniformLocation mvMatrixUniform;

Buffer vertexBuffer;
Buffer indicesBuffer;

int itemSize;
int numItems;

void buildMeshData() {
  Mesh simpleTriangle = new Mesh();
  simpleTriangle.vertices = [
    -1000.0,0.0,10.0,
    0.0,1000.0,10.0,
    1000.0,0.0,10.0,
  ];
  simpleTriangle.indices = [0,1,2];
  meshes.add(simpleTriangle);
}

void initGL() {

  CanvasElement canvas = document.getElementById("glCanvas");

  var names = ["webgl", "experimental-webgl", "webkit-3d", "moz-webgl"];
  for (var i = 0; i<names.length; ++i) {
    try {
      gl = canvas.getContext(names[i]);
    } catch (e) { }
    if (gl != null) {
      break;
    }
  }
  if (gl == null) {
    window.alert("Could not initialise WebGL");
    return null;
  }
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

  vertexPositionAttribute = gl.getAttribLocation(shaderProgram, "aVertexPosition");
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

void setupCamera() {
//  pMatrix = makePerspectiveMatrix(45.0, gl.drawingBufferWidth / gl.drawingBufferHeight, 0.1, 100.0);

}

void initBuffers() {
  List<num> vertices = meshes[0].vertices;
  List<int> indices = meshes[0].indices;

  vertexBuffer = gl.createBuffer();
  gl.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
  gl.bufferData(GL.ARRAY_BUFFER, new Float32List(vertices.length), GL.STATIC_DRAW);
  gl.bindBuffer(GL.ARRAY_BUFFER, null);
  itemSize = 3;
  numItems = vertices.length ~/ itemSize;

  indicesBuffer = gl.createBuffer();
  gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indicesBuffer);
  gl.bufferData(GL.ELEMENT_ARRAY_BUFFER, new Uint16List(indices.length), GL.STATIC_DRAW);
  gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);

}

void drawScene() {
  gl.clearColor(0.0, 0.0, 0.0, 1.0);
//  gl.enable(GL.DEPTH_TEST);

  gl.disable(RenderingContext.CULL_FACE);
  gl.disable(RenderingContext.DEPTH_TEST);
  gl.colorMask(true, true, true, true);
  gl.enable(RenderingContext.BLEND);

  gl.viewport(0, 0,  gl.drawingBufferWidth, gl.drawingBufferHeight);
  gl.clear(GL.COLOR_BUFFER_BIT);

  setupCamera();

  mvMatrix.setIdentity();

  gl.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
  gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indicesBuffer);


  gl.vertexAttribPointer(vertexPositionAttribute, itemSize, GL.FLOAT, false, 0, 0);



  gl.uniformMatrix4fv(pMatrixUniform, false, pMatrix.storage);
  gl.uniformMatrix4fv(mvMatrixUniform, false, mvMatrix.storage);

  gl.drawElements(GL.TRIANGLES, meshes[0].indices.length, GL.UNSIGNED_SHORT,0);
}

