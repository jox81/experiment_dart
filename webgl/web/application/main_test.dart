import 'dart:async';
import 'dart:html';
import 'dart:web_gl';
import 'package:vector_math/vector_math.dart';
import 'dart:typed_data';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/globals/context.dart';
import 'package:webgl/src/material.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/mesh.dart';
import 'package:webgl/src/object3d.dart';
import 'package:webgl/src/primitives.dart';
import 'package:webgl/src/utils_shader.dart';

Future main() async {

  Webgl01 webgl01 = new Webgl01(querySelector('#glCanvas'));

  await ShaderSource.loadShaders();

  webgl01.setup();
  webgl01.render();
}

class Webgl01 {

  Buffer vertexBuffer;
  Buffer indicesBuffer;

  List<Object3d> objects = new List();

  Program shaderProgram;

  int vertexPositionAttribute;

  UniformLocation pMatrixUniform;
  UniformLocation mvMatrixUniform;

  Webgl01(CanvasElement canvas){
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
    gl.enable(GL.DEPTH_TEST);
  }

  void setupCamera()  {
    mainCamera = new Camera(radians(45.0), 0.1, 100.0)
      ..aspectRatio = gl.drawingBufferWidth / gl.drawingBufferHeight
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(0.0,5.0,10.0)
      ..cameraController = new CameraController();
  }

  void setupMeshes() {
    Mesh mesh = new Mesh()
      ..vertices = [
        0.0, 0.0, 0.0,
        0.0, 0.0, 3.0,
        2.0, 0.0, 0.0,
      ]
      ..vertexDimensions = 3
      ..indices = [0, 1, 2]
      ..transform = (new Matrix4.identity()..setTranslation(new Vector3(0.0,0.0,0.0)))
      ..material = new MaterialBase();

    CutomObject cutomObject = new CutomObject(mesh);
    objects.add(cutomObject);
  }

  void render({num time : 0.0}) {
    gl.viewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
    gl.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);

    for(Object3d object3d in objects){
      object3d.render();
    }

    window.requestAnimationFrame((num time) {
      this.render(time: time);
    });
  }

}

/// 1 vertexBuffer par objet
/// mvMatrix = viewMatrix * modelMatrix
/// camera en Right Hand