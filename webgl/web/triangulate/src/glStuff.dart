import 'mesh.dart';
import 'dart:html';
import 'dart:web_gl';
import 'package:vector_math/vector_math.dart';
import 'geometric.dart';
import 'dart:typed_data';
import 'package:gl_enums/gl_enums.dart' as GL;

RenderingContext gl;

List<Mesh> meshes = new List();

void setupCamera() {
  pMatrix = makePerspectiveMatrix(45.0, gl.drawingBufferWidth / gl.drawingBufferHeight, 0.1, 100.0);
  mvMatrix.setIdentity();
  mvMatrix.translate(-1.0, -2.0, -12.0);
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

getShader(gl, id) {
  ScriptElement shaderScript = document.getElementById(id);
  if (shaderScript == null) {
    return null;
  }

  String source = "";
  Node k = shaderScript.firstChild;
  while (k != null) {
    if (k.nodeType == Node.TEXT_NODE) {
      source += k.text;
    }
    k = k.nextNode;
  }

  Shader shader;
  if (shaderScript.type == "x-shader/x-fragment") {
    shader = gl.createShader(GL.FRAGMENT_SHADER);
  } else if (shaderScript.type == "x-shader/x-vertex") {
    shader = gl.createShader(GL.VERTEX_SHADER);
  } else {
    return null;
  }

  gl.shaderSource(shader, source);
  gl.compileShader(shader);

  if (!gl.getShaderParameter(shader, GL.COMPILE_STATUS)) {
    window.alert(gl.getShaderInfoLog(shader));
    return null;
  }

  return shader;
}
Program shaderProgram;
int vertexPositionAttribute;

void initShaders() {
  Shader fragmentShader = getShader(gl, "shader-fs");
  Shader vertexShader = getShader(gl, "shader-vs");

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

}

Matrix4 mvMatrix = new Matrix4.zero();
Matrix4 pMatrix = new Matrix4.zero();

List<int> indices = [];
UniformLocation pMatrixUniform;
UniformLocation mvMatrixUniform;

void setMatrixUniforms() {
  pMatrixUniform = gl.getUniformLocation(shaderProgram, "uPMatrix");
  gl.uniformMatrix4fv(pMatrixUniform, false, pMatrix.storage);

  mvMatrixUniform = gl.getUniformLocation(shaderProgram, "uMVMatrix");
  gl.uniformMatrix4fv(mvMatrixUniform, false, mvMatrix.storage);
}

//Get first vertex
List<int> triangulateShape(arrayVec3){

  /*
  firstPoint = indice 0
  currentPoint = firstPoint
  Get next two edges
      concav ?
      V-> triangle temp
          pointInside ?
          F -> Close triangle
          V -> currentPoint + 1
      F-> slide index
  */

  //Create point array
  List points = [];
  List possibleIndices = [];
  var possible3 = (arrayVec3.length ~/ 3) * 3; //~~(100 / 3) > 33
  var pointCount = 0;
  for (var i = 0; i < possible3; i += 3)
  {
    var point = new Vector3(arrayVec3[i + 0], arrayVec3[i + 1], arrayVec3[i + 2]);
    points.add(point);
    possibleIndices.add(pointCount);
    pointCount++;
  }

  var startIndex = 0;
  var triangleCount = 0;
  var passCount = 0;
  var bEnd = false;
  var currentIndice = possibleIndices[possibleIndices.indexOf(startIndex)];
  var nextIndice = possibleIndices[possibleIndices.indexOf(startIndex) + 1] ;
  var nextNextIndice = possibleIndices[possibleIndices.indexOf(startIndex) + 2] ;
  var doneIndice = [];

  while(!bEnd){

    print("//////////////////////////begin pass : $passCount");

    var vec3P1 = points[currentIndice];
    var vec3P2 = points[nextIndice];
    var vec3P3 = points[nextNextIndice];

    var angle = Geometric.toDegree(Geometric.getAngleBetween3Points(vec3P1, vec3P2, vec3P3));

    if(angle > 0 && angle < 180){
      //angle concave
      print("angle concave : $angle");
      var bInside = false;
      for(var i = 0; i < points.length; i++){
        bInside = bInside || Geometric.isPointInsideTriangle(points[i], vec3P1, vec3P2, vec3P3);
        if(bInside) break;
      }

      if(!bInside){
        //create triangle
        print("create triangle");
        indices.add(currentIndice);
        indices.add(nextIndice);
        indices.add(nextNextIndice);
        triangleCount++;

        //remove done corner
        var index = possibleIndices.indexOf(nextIndice);
        if (index > -1) {
          possibleIndices.removeAt(index);
        }

        currentIndice = currentIndice;
        nextIndice = possibleIndices[possibleIndices.indexOf(currentIndice) + 1];
        nextNextIndice = possibleIndices[possibleIndices.indexOf(currentIndice) + 2];
      }else{
        //Point inside
        print("point inside triangle");
        //Slide next
        print("slide next");
        currentIndice = possibleIndices[possibleIndices.indexOf(nextIndice)];
        nextIndice = possibleIndices[possibleIndices.indexOf(currentIndice) + 1];
        nextNextIndice = possibleIndices[possibleIndices.indexOf(currentIndice) + 2];
      }
    } else if(angle == 0){
      //remove done corner
      var index = possibleIndices.indexOf(nextIndice);
      if (index > -1) {
        possibleIndices.removeAt(index);
      }
      currentIndice = currentIndice;
      if(possibleIndices.indexOf(currentIndice) + 2 < possibleIndices.length) {
        nextIndice = possibleIndices[possibleIndices.indexOf(currentIndice) + 1];
        nextNextIndice = possibleIndices[possibleIndices.indexOf(currentIndice) + 2];
      }


    } else{
      //angle convex
      print("angle convex : $angle");
      //Slide next
      print("slide next");
      currentIndice = possibleIndices[possibleIndices.indexOf(nextIndice)];
      nextIndice = possibleIndices[possibleIndices.indexOf(currentIndice) + 1];
      if(possibleIndices.indexOf(currentIndice) + 2 < possibleIndices.length) {
        nextNextIndice =
        possibleIndices[possibleIndices.indexOf(currentIndice) + 2];
      }
    }

    passCount++;
    print("passCount : $passCount");

    if(currentIndice != null && nextIndice != null && nextNextIndice == null) {
      nextNextIndice = possibleIndices[0];
    }
    if(currentIndice != null && nextIndice == null && nextNextIndice == null)
    {
      nextIndice = possibleIndices[0];
      nextNextIndice = possibleIndices[1];
    }
    if(currentIndice == null && nextIndice == null && nextNextIndice == null)
    {
      currentIndice = possibleIndices[0];
      nextIndice = possibleIndices[1];
      nextNextIndice = possibleIndices[2];
    }

    if(possibleIndices.length <= 3) bEnd = true;
    if(passCount == 35) bEnd = true;
  }

  return indices;
}

Buffer polyVertexBuffer;
Buffer polyIndicesBuffer;

int itemSize, numItems;

void initBuffers() {
  List<num> vertices = meshes[0].vertices;
  List<int> indices = meshes[0].indices;

  polyVertexBuffer = gl.createBuffer();
  gl.bindBuffer(GL.ARRAY_BUFFER, polyVertexBuffer);
  gl.bufferData(GL.ARRAY_BUFFER, new Float32List(vertices.length), GL.STATIC_DRAW);
  gl.bindBuffer(GL.ARRAY_BUFFER, null);
  itemSize = 3;
  numItems = vertices.length ~/ itemSize;

  polyIndicesBuffer = gl.createBuffer();
  gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, polyIndicesBuffer);
  gl.bufferData(GL.ELEMENT_ARRAY_BUFFER, new Uint16List(indices.length), GL.STATIC_DRAW);
  gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
}

void drawScene() {
  gl.clearColor(0.0, 0.0, 0.0, 1.0);
  gl.enable(GL.DEPTH_TEST);

  gl.viewport(0, 0,  gl.drawingBufferWidth, gl.drawingBufferHeight);
  gl.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);

  setupCamera();

  //Todo : Setup for multiple objects
  gl.bindBuffer(GL.ARRAY_BUFFER, polyVertexBuffer);
  gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, polyIndicesBuffer);
  gl.vertexAttribPointer(vertexPositionAttribute, itemSize, GL.FLOAT, false, 0, 0);
  setMatrixUniforms();
  gl.drawElements(GL.TRIANGLES, indices.length, GL.UNSIGNED_SHORT,0);
}
