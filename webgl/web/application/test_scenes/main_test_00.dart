import 'dart:html';
import 'dart:web_gl';
import 'package:vector_math/vector_math.dart';
import 'dart:typed_data';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/meshes.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
import 'package:webgl/src/webgl_objects/webgl_context.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';

void main() {
  Webgl01 webgl01 = new Webgl01(querySelector('#glCanvas'));
  webgl01.render();
}

class Webgl01 {

  WebGLBuffer vertexBuffer;
  WebGLBuffer indicesBuffer;

  List<Model> models = new List();

  WebGLProgram shaderProgram;

  int vertexPositionAttribute;

  UniformLocation pMatrixUniform;
  UniformLocation mvMatrixUniform;

  Webgl01(CanvasElement canvas){

    initGL(canvas);

    setupCamera();

    buildMeshData();
    initShaders();
    initBuffers();


    gl.clearColor = new Vector4(0.0, 0.0, 0.0, 1.0);
    gl.depthTest = true;
  }

  void initGL(CanvasElement canvas) {
    Context.init(canvas,enableExtensions:true,logInfos:false);
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
    WebGLShader fragmentShader = _getShader(gl, "shader-fs");
    WebGLShader vertexShader = _getShader(gl, "shader-vs");

    shaderProgram = new WebGLProgram();
    shaderProgram.attachShader(vertexShader);
    shaderProgram.attachShader(fragmentShader);
    shaderProgram.link();

    if (!shaderProgram.linkStatus) {
      window.alert("Could not initialise shaders");
    }

    shaderProgram.use();

    vertexPositionAttribute =
        gl.ctx.getAttribLocation(shaderProgram.webGLProgram, "aVertexPosition");
    gl.ctx.enableVertexAttribArray(vertexPositionAttribute);

    pMatrixUniform = gl.ctx.getUniformLocation(shaderProgram.webGLProgram, "uPMatrix");
    mvMatrixUniform = gl.ctx.getUniformLocation(shaderProgram.webGLProgram, "uMVMatrix");
  }

  _getShader(WebGLRenderingContext gl, id) {
    ScriptElement shaderScript = document.getElementById(id);
    if (shaderScript == null) {
      return null;
    }

    String shaderSource = shaderScript.text;

    WebGLShader shader;
    if (shaderScript.type == "x-shader/x-fragment") {
      shader = new WebGLShader(ShaderType.FRAGMENT_SHADER);
    } else if (shaderScript.type == "x-shader/x-vertex") {
      shader = new WebGLShader(ShaderType.VERTEX_SHADER);
    } else {
      return null;
    }

    shader.source = shaderSource;
    shader.compile();

    if (!shader.compileStatus) {
      window.alert(shader.infoLog);
      return null;
    }

    return shader;
  }

  void initBuffers() {
    List<num> vertices = models[0].mesh.vertices;
    List<int> indices = models[0].mesh.indices;

    vertexBuffer = new WebGLBuffer();
    gl.bindBuffer(BufferType.ARRAY_BUFFER, vertexBuffer);
    gl.bufferData(
        BufferType.ARRAY_BUFFER, new Float32List.fromList(vertices), UsageType.STATIC_DRAW);
    gl.bindBuffer(BufferType.ARRAY_BUFFER, null);

    indicesBuffer = new WebGLBuffer();
    gl.bindBuffer(BufferType.ELEMENT_ARRAY_BUFFER, indicesBuffer);
    gl.bufferData(BufferType.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(indices),
        UsageType.STATIC_DRAW);
    gl.bindBuffer(BufferType.ELEMENT_ARRAY_BUFFER, null);
  }

  /// Rendering part
  ///
  void _setMatrixUniforms() {
    gl.ctx.uniformMatrix4fv(pMatrixUniform, false, Context.mainCamera.perspectiveMatrix.storage);
    gl.ctx.uniformMatrix4fv(mvMatrixUniform, false, Context.mvMatrix.storage);
  }

  void render({num time : 0.0}) {
    gl.setViewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
    gl.clear([ClearBufferMask.COLOR_BUFFER_BIT,ClearBufferMask.DEPTH_BUFFER_BIT]);

    Context.mvMatrix = Context.mainCamera.lookAtMatrix * models[0].transform;

    gl.bindBuffer(BufferType.ARRAY_BUFFER, vertexBuffer);
    gl.bindBuffer(BufferType.ELEMENT_ARRAY_BUFFER, indicesBuffer);

    gl.ctx.vertexAttribPointer(
        vertexPositionAttribute, models[0].mesh.vertexDimensions, RenderingContext.FLOAT, false, 0, 0);

    _setMatrixUniforms();

    gl.ctx.drawElements(
        RenderingContext.TRIANGLES, models[0].mesh.indices.length, RenderingContext.UNSIGNED_SHORT, 0);

    window.requestAnimationFrame((num time) {
      this.render(time: time);
    });
  }

}

/// 1 vertexBuffer par objet
/// mvMatrix = viewMatrix * modelMatrix
/// camera en Right Hand