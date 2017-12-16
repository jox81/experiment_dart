import 'dart:async';
import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/geometry/models.dart';
import 'package:webgl/src/material/shader_source.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_uniform_location.dart';

Future main() async {
  WebglTestParameters webglTestParameters =
      new WebglTestParameters(querySelector('#glCanvas') as CanvasElement);

  await ShaderSource.loadShaders();
  webglTestParameters.setup();
  webglTestParameters.render();
}

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

    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.enable(EnableCapabilityType.DEPTH_TEST);
  }

  void setupCamera() {
    Context.mainCamera = new CameraPerspective(radians(45.0), 0.1, 100.0)
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(10.0, 10.0, 10.0);
  }

  void setupMeshes() {
    QuadModel quad = new QuadModel()..transform.translate(2.0, 0.0, 0.0);
    models.add(quad);

    getInfos();
  }

  void render({num time: 0.0}) {
    gl.viewport(0, 0, gl.drawingBufferWidth.toInt(), gl.drawingBufferHeight.toInt());
    gl.clear(ClearBufferMask.COLOR_BUFFER_BIT | ClearBufferMask.DEPTH_BUFFER_BIT);

    for (Model model in models) {
      model.render();
    }
  }

  void getInfos() {
//    Context.webglConstants.logConstants();
//    Context.webglParameters.logValues();

    IntrospectionManager.instance.logTypeInfos(CubeModel,
      showBaseInfo: true,
      showLibrary: false,
      showType: false,
      showTypeVariable: false,
      showTypeDef: false,
      showFunctionType: true,
      showVariable: true,
      showParameter: false,
      showMethod: true
    );

    models[0].getPropertiesInfos();
  }
}



