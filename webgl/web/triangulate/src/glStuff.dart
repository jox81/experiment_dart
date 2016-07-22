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
  mvMatrix.translate([-1.0, -2.0, -12.0]);
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
  var shaderScript = document.getElementById(id);
  if (!shaderScript) {
    return null;
  }

  var str = "";
  var k = shaderScript.firstChild;
  while (k) {
    if (k.nodeType == 3) {
      str += k.textContent;
    }
    k = k.nextSibling;
  }

  var shader;
  if (shaderScript.type == "x-shader/x-fragment") {
    shader = gl.createShader(gl.FRAGMENT_SHADER);
  } else if (shaderScript.type == "x-shader/x-vertex") {
    shader = gl.createShader(gl.VERTEX_SHADER);
  } else {
    return null;
  }

  gl.shaderSource(shader, str);
  gl.compileShader(shader);

  if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
    window.alert(gl.getShaderInfoLog(shader));
    return null;
  }

  return shader;
}
var shaderProgram;

void initShaders() {
  var fragmentShader = getShader(gl, "shader-fs");
  var vertexShader = getShader(gl, "shader-vs");

  shaderProgram = gl.createProgram();
  gl.attachShader(shaderProgram, vertexShader);
  gl.attachShader(shaderProgram, fragmentShader);
  gl.linkProgram(shaderProgram);

  if (!gl.getProgramParameter(shaderProgram, RenderingContext.LINK_STATUS)) {
    window.alert("Could not initialise shaders");
  }

  gl.useProgram(shaderProgram);

  shaderProgram.vertexPositionAttribute = gl.getAttribLocation(shaderProgram, "aVertexPosition");
  gl.enableVertexAttribArray(shaderProgram.vertexPositionAttribute);

  shaderProgram.pMatrixUniform = gl.getUniformLocation(shaderProgram, "uPMatrix");
  shaderProgram.mvMatrixUniform = gl.getUniformLocation(shaderProgram, "uMVMatrix");
}

Matrix4 mvMatrix = new Matrix4.zero();
Matrix4 pMatrix = new Matrix4.zero();

List<int> indices = [];

void setMatrixUniforms() {
  gl.uniformMatrix4fv(shaderProgram.pMatrixUniform, false, pMatrix.storage);
  gl.uniformMatrix4fv(shaderProgram.mvMatrixUniform, false, mvMatrix.storage);
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
  var points = [];
  var possibleIndices = [];
  var possible3 = ~~(arrayVec3.length / 3) * 3; //~~(100 / 3) > 33
  var pointCount = 0;
  for (var i = 0; i < possible3; i += 3)
  {
    var point = new Vector3(arrayVec3[i + 0], arrayVec3[i + 1], arrayVec3[i + 2]);
    points.push(point);
    possibleIndices.push(pointCount);
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

    print("//////////////////////////begin pass : " + passCount);

    var vec3P1 = points[currentIndice];
    var vec3P2 = points[nextIndice];
    var vec3P3 = points[nextNextIndice];

    var angle = Geometric.toDegree(Geometric.getAngleBetween3Points(vec3P1, vec3P2, vec3P3));

    if(angle > 0 && angle < 180){
      //angle concave
      print("angle concave : " + angle);
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
          possibleIndices.splice(index, 1);
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
        possibleIndices.splice(index, 1);
      }
      currentIndice = currentIndice;
      nextIndice = possibleIndices[possibleIndices.indexOf(currentIndice) + 1];
      nextNextIndice = possibleIndices[possibleIndices.indexOf(currentIndice) + 2];

    } else{
      //angle convex
      print("angle convex : " + angle);
      //Slide next
      print("slide next");
      currentIndice = possibleIndices[possibleIndices.indexOf(nextIndice)];
      nextIndice = possibleIndices[possibleIndices.indexOf(currentIndice) + 1];
      nextNextIndice = possibleIndices[possibleIndices.indexOf(currentIndice) + 2];
    }

    passCount++;
    print("passCount : " + passCount);

    if(currentIndice && nextIndice && nextNextIndice == null) {
      nextNextIndice = possibleIndices[0];
    }
    if(currentIndice && nextIndice == null && nextNextIndice == null)
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

var polyVertexBuffer;
var polyIndicesBuffer;

void initBuffers() {
  List<num> vertices = [
    0.0,  0.0,  0.0,
    -2.0,  1.0,  0.0,
    -1.0,  2.0,  0.0,
    -3.0,  2.0,  0.0,
    -1.0,  3.0,  0.0,
    -2.0,  3.0,  0.0,
    -3.0,  3.0,  0.0,
    -4.0,  2.0,  0.0,
    -4.0,  4.0,  0.0,
    -5.0,  4.0,  0.0,
    -4.0,  5.0,  0.0,
    -3.0,  4.0,  0.0,
    -2.0,  4.0,  0.0,
    -1.0,  6.0,  0.0,
    1.0,  5.0,  0.0,
    2.0,  3.0,  0.0,
    2.0,  4.0,  0.0,
    3.0,  4.0,  0.0,
    3.0,  2.0,  0.0,
    1.0,  3.0,  0.0,
    0.0,  3.0,  0.0,
    1.0,  4.0,  0.0,
    -1.0,  5.0,  0.0,
    0.0,  2.0,  0.0,
    -1.0,  1.0,  0.0,
    1.0,  0.0,  0.0

  ];

  List<int> indices = triangulateShape(vertices);

  polyVertexBuffer = gl.createBuffer();
  gl.bindBuffer(GL.ARRAY_BUFFER, polyVertexBuffer);
  gl.bufferData(GL.ARRAY_BUFFER, new Float32List(vertices.length), GL.STATIC_DRAW);
  gl.bindBuffer(GL.ARRAY_BUFFER, null);
  polyVertexBuffer.itemSize = 3;
  polyVertexBuffer.numItems = vertices.length / polyVertexBuffer.itemSize;

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
  gl.vertexAttribPointer(shaderProgram.vertexPositionAttribute, polyVertexBuffer.itemSize, GL.FLOAT, false, 0, 0);
  setMatrixUniforms();
  gl.drawElements(GL.TRIANGLES, indices.length, GL.UNSIGNED_SHORT,0);
}
