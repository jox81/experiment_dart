import 'dart:async';
import 'dart:html';
import 'dart:mirrors';
import 'dart:web_gl';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/shaders.dart';
import 'package:webgl/src/texture_utils.dart';
import 'package:webgl/src/utils.dart';
import 'package:webgl/src/webgl_debug_js.dart';

Texture textureCrate;
Map susanJson;

Future main() async {

  WebglTestParameters webgl01 = new WebglTestParameters(querySelector('#glCanvas'));

  await ShaderSource.loadShaders();
  susanJson = await Utils.loadJSONResource('../objects/susan/susan.json');
  webgl01.setup();
  webgl01.render();
}

class WebglTestParameters {

  Buffer vertexBuffer;
  Buffer indicesBuffer;

  List<Model> models = new List();

  Program shaderProgram;

  int vertexPositionAttribute;

  UniformLocation pMatrixUniform;
  UniformLocation mvMatrixUniform;

  WebglTestParameters(CanvasElement canvas){
    initGL(canvas);
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

  void setup(){
    setupCamera();
    setupMeshes();

    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.enable(RenderingContext.DEPTH_TEST);


    var p = gl.getParameter(RenderingContext.CULL_FACE_MODE);
    var s = WebGLDebugUtils.glEnumToString(p);
    print(s);
  }

  void setupCamera()  {
    Context.mainCamera = new Camera(radians(45.0), 0.1, 100.0)
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(10.0,10.0,10.0)
      ..cameraController = new CameraController();
  }

  void setupMeshes() {
    QuadModel quad = new QuadModel()
      ..transform.translate(2.0, 0.0, 0.0);
    models.add(quad);

    getInfos();
  }

  void render({num time : 0.0}) {
    gl.viewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
    gl.clear(RenderingContext.COLOR_BUFFER_BIT | RenderingContext.DEPTH_BUFFER_BIT);

    for(Model model in models){
      model.render();
    }
  }

  void getInfos(){

    InstanceMirror instance_mirror = reflect(gl);
    var class_mirror = instance_mirror.type;
  }
}