import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'dart:typed_data';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/geometry/meshes.dart';
import 'package:webgl/src/geometry/models.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_attribut_location.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_rendering_context.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_uniform_location.dart';

void main() {
  Webgl01 webgl01 = new Webgl01(querySelector('#glCanvas'));
  webgl01.render();
}

class Webgl01 {

  WebGLBuffer vertexBuffer;
  WebGLBuffer indicesBuffer;

  List<Model> models = new List();

  WebGLProgram shaderProgram;

  WebGLAttributLocation vertexPositionAttribute;

  WebGLUniformLocation pMatrixUniform;
  WebGLUniformLocation vMatrixUniform;
  WebGLUniformLocation mMatrixUniform;

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
      ..position = new Vector3(0.0,5.0,10.0);
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
        shaderProgram.getAttribLocation("aVertexPosition");
    vertexPositionAttribute.enabled = true;

    pMatrixUniform = shaderProgram.getUniformLocation("uProjectionMatrix");
    vMatrixUniform = shaderProgram.getUniformLocation("uViewMatrix");
    mMatrixUniform = shaderProgram.getUniformLocation("uModelMatrix");
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
        BufferType.ARRAY_BUFFER, new Float32List.fromList(vertices), BufferUsageType.STATIC_DRAW);
    gl.bindBuffer(BufferType.ARRAY_BUFFER, null);

    indicesBuffer = new WebGLBuffer();
    gl.bindBuffer(BufferType.ELEMENT_ARRAY_BUFFER, indicesBuffer);
    gl.bufferData(BufferType.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(indices),
        BufferUsageType.STATIC_DRAW);
    gl.bindBuffer(BufferType.ELEMENT_ARRAY_BUFFER, null);
  }

  /// Rendering part
  ///
  void render({num time : 0.0}) {
    gl.viewport = new Rectangle(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
    gl.clear([ClearBufferMask.COLOR_BUFFER_BIT,ClearBufferMask.DEPTH_BUFFER_BIT]);

    gl.bindBuffer(BufferType.ARRAY_BUFFER, vertexBuffer);
    gl.bindBuffer(BufferType.ELEMENT_ARRAY_BUFFER, indicesBuffer);

    vertexPositionAttribute.vertexAttribPointer(models[0].mesh.vertexDimensions, ShaderVariableType.FLOAT, false, 0, 0);

    _setMatrixUniforms();

    gl.drawElements(
        DrawMode.TRIANGLES, models[0].mesh.indices.length, BufferElementType.UNSIGNED_SHORT, 0);

    window.requestAnimationFrame((num time) {
      this.render(time: time);
    });
  }

  void _setMatrixUniforms() {
    mMatrixUniform.uniformMatrix4fv(models[0].transform, false);
    vMatrixUniform.uniformMatrix4fv(Context.mainCamera.lookAtMatrix, false);
    pMatrixUniform.uniformMatrix4fv(Context.mainCamera.perspectiveMatrix, false);
  }

}

/// 1 vertexBuffer par objet
/// modelViewMatrix = viewMatrix * modelMatrix
/// camera en Right Hand