import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'dart:typed_data';
import 'package:webgl/src/camera/camera.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/gltf/mesh.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_attribut_location.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'dart:web_gl' as WebGL;
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_uniform_location.dart';

void main() {
  Webgl01 webgl01 = new Webgl01(querySelector('#glCanvas') as CanvasElement);
  webgl01.render();
}

class Webgl01 {

  WebGLBuffer vertexBuffer;
  WebGLBuffer indicesBuffer;

  List<GLTFNode> nodes = new List();

  WebGLProgram shaderProgram;

  WebGLAttributLocation vertexPositionAttribute;

  WebGLUniformLocation pMatrixUniform;
  WebGLUniformLocation mvMatrixUniform;

  Webgl01(CanvasElement canvas){

    initGL(canvas);

    setupCamera();

    buildMeshData();
    initShaders();
    initBuffers();

    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.enable(EnableCapabilityType.DEPTH_TEST);
  }

  void initGL(CanvasElement canvas) {
    Context.init(canvas,enableExtensions:true,logInfos:false);
  }

  void setupCamera() {
    Context.mainCamera = new CameraPerspective(radians(45.0), 0.1, 100.0)
      ..targetPosition = new Vector3.zero()
      ..translation = new Vector3(0.0,5.0,10.0);
  }

  void buildMeshData() {
    GLTFMesh customObject = new GLTFMesh.custom(new Float32List.fromList([
        0.0, 0.0, 0.0,
        0.0, 0.0, 3.0,
        2.0, 0.0, 0.0,
      ]), new Int16List.fromList([0, 1, 2]), null, null);
    GLTFNode nodeCustom = new GLTFNode()
      ..mesh = customObject
      ..matrix = (new Matrix4.identity()..setTranslation(new Vector3(2.0,0.0,0.0)));
    nodes.add(nodeCustom);
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
    mvMatrixUniform = shaderProgram.getUniformLocation("uModelViewMatrix");
  }

  WebGLShader _getShader(WebGL.RenderingContext gl, String id) {
    ScriptElement shaderScript = document.getElementById(id) as ScriptElement;
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
    List<double> vertices = nodes[0].mesh.primitives[0].vertices;
    List<int> indices = nodes[0].mesh.primitives[0].indices;

    vertexBuffer = new WebGLBuffer();
    gl.bindBuffer(BufferType.ARRAY_BUFFER, vertexBuffer.webGLBuffer);
    gl.bufferData(
        BufferType.ARRAY_BUFFER, new Float32List.fromList(vertices), BufferUsageType.STATIC_DRAW);
    gl.bindBuffer(BufferType.ARRAY_BUFFER, null);

    indicesBuffer = new WebGLBuffer();
    gl.bindBuffer(BufferType.ELEMENT_ARRAY_BUFFER, indicesBuffer.webGLBuffer);
    gl.bufferData(BufferType.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(indices),
        BufferUsageType.STATIC_DRAW);
    gl.bindBuffer(BufferType.ELEMENT_ARRAY_BUFFER, null);
  }

  /// Rendering part
  ///
  void render({num time : 0.0}) {
    gl.viewport(0, 0, gl.drawingBufferWidth.toInt(), gl.drawingBufferHeight.toInt());
    gl.clear(ClearBufferMask.COLOR_BUFFER_BIT | ClearBufferMask.DEPTH_BUFFER_BIT);

    Context.modelMatrix = nodes[0].matrix;

    gl.bindBuffer(BufferType.ARRAY_BUFFER, vertexBuffer.webGLBuffer);
    gl.bindBuffer(BufferType.ELEMENT_ARRAY_BUFFER, indicesBuffer.webGLBuffer);


    vertexPositionAttribute.vertexAttribPointer(nodes[0].mesh.primitives[0].positionAccessor.components, ShaderVariableType.FLOAT, false, 0, 0);

    _setMatrixUniforms();

    gl.drawElements(
        DrawMode.TRIANGLES, nodes[0].mesh.primitives[0].positionAccessor.components, BufferElementType.UNSIGNED_SHORT, 0);

    window.requestAnimationFrame((num time) {
      this.render(time: time);
    });
  }

  void _setMatrixUniforms() {
    pMatrixUniform.uniformMatrix4fv(Context.mainCamera.projectionMatrix, false);
    mvMatrixUniform.uniformMatrix4fv((Context.mainCamera.viewMatrix * Context.modelMatrix) as Matrix4, false);
  }

}

/// 1 vertexBuffer par objet
/// modelViewMatrix = viewMatrix * modelMatrix
/// camera en Right Hand