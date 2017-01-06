import 'dart:async';
import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/context/webgl_parameters.dart';
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
import 'package:webgl/src/webgl_objects/webgl_context.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';
import 'package:webgl/src/webgl_objects/webgl_uniform_location.dart';

Future main() async {
  WebglTestParameters webgl01 =
      new WebglTestParameters(querySelector('#glCanvas'));

  await ShaderSource.loadShaders();
  webgl01.setup();
  webgl01.render();
}

List<WebglParameter> webglParameters = new List();

class WebglTestParameters {
  WebGLBuffer vertexBuffer;
  WebGLBuffer indicesBuffer;

  List<Model> models = new List();

  WebGLProgram shaderProgram;

  int vertexPositionAttribute;

  WebGLUniformLocation pMatrixUniform;
  WebGLUniformLocation mvMatrixUniform;

  WebglTestParameters(CanvasElement canvas) {
    initGL(canvas);
  }

  void initGL(CanvasElement canvas) {
    Context.init(canvas,enableExtensions:true,logInfos:false);
  }

  void setup() {
    setupCamera();
    setupMeshes();

    gl.clearColor = new Vector4(0.0, 0.0, 0.0, 1.0);
    gl.depthTest = true;
  }

  void setupCamera() {
    Context.mainCamera = new Camera(radians(45.0), 0.1, 100.0)
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(10.0, 10.0, 10.0)
      ..cameraController = new CameraController();
  }

  void setupMeshes() {
    QuadModel quad = new QuadModel()..transform.translate(2.0, 0.0, 0.0);
    models.add(quad);

    getInfos();
  }

  void render({num time: 0.0}) {
    gl.viewport = new Rectangle(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
    gl.clear(
        [ClearBufferMask.COLOR_BUFFER_BIT, ClearBufferMask.DEPTH_BUFFER_BIT]);

    for (Model model in models) {
      model.render();
    }
  }

  void getInfos() {
    Context.webglConstants.logConstants();
    Context.webglParameters.logValues();
  }
}



