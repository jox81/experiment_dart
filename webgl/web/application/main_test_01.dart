import 'dart:async';
import 'dart:collection';
import 'dart:html';
import 'dart:web_gl';
import 'package:vector_math/vector_math.dart';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/globals/context.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/mesh.dart';
import 'package:webgl/src/primitives.dart';
import 'package:webgl/src/shaders.dart';

Texture textureCrate;

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
    Context.mainCamera = new Camera(radians(45.0), 0.1, 100.0)
      ..aspectRatio = gl.drawingBufferWidth / gl.drawingBufferHeight
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(10.0,10.0,10.0)
      ..cameraController = new CameraController();
  }

  void setupMeshes() {

//    CustomObject customObject = new CustomObject()
//      ..mesh = new Mesh()
//      ..mesh.vertices = [
//        0.0, 0.0, 0.0,
//        0.0, 0.0, 3.0,
//        2.0, 0.0, 0.0,
//      ]
//      ..mesh.vertexDimensions = 3
//      ..mesh.indices = [0, 1, 2]
//      ..transform = (new Matrix4.identity()..setTranslation(new Vector3(0.0,0.0,0.0)))
//      ..material = new MaterialBase();
//    objects.add(customObject);

//
//    PointModel pointModel = new PointModel()
//    ..material = new MaterialPoint(5.0 ,color:
//      new Vector4(1.0, 1.0, 0.0,1.0));
//    objects.add(pointModel);
//
//    PointModel pointModel2 = new PointModel()
//      ..transform = (new Matrix4.identity()..setTranslation(new Vector3(1.0,0.0,0.0)))
//      ..material = new MaterialPoint(7.0 ,color: new Vector4(1.0, 0.0, 0.0,1.0));
//    objects.add(pointModel2);

//    LineModel line = new LineModel(new Vector3.all(0.0), new Vector3(5.0,5.0,-3.0))
//    ..material = new MaterialBaseColor(new Vector3(0.0, 1.0, 1.0));
//    objects.add(line);

//    MultiLineModel multiLineModel = new MultiLineModel([
//      new Vector3.all(0.0),
//      new Vector3(1.0,0.0,0.0),
//      new Vector3(1.0,0.0,-1.0),
//      new Vector3(1.0,1.0,-1.0),
//      new Vector3(-2.0,1.0,-1.0),
//    ])
//    ..material = new MaterialBaseColor(
//        new Vector3(1.0, 0.0, 1.0));
//    objects.add(multiLineModel);

//    TriangleModel triangleModel = new TriangleModel()
//      ..name = 'triangle'
//      ..transform.translate(0.0, 0.0, 4.0)
//      ..material = new MaterialBase();
//    objects.add(triangleModel);

//    QuadModel quad = new QuadModel()
//      ..transform.translate(2.0, 0.0, 0.0)
//      ..material = new MaterialBaseVertexColor()
//      ..mesh.colors = new List()
//      ..mesh.colors.addAll([1.0, 0.0, 0.0, 1.0])
//      ..mesh.colors.addAll([1.0, 1.0, 0.0, 1.0])
//      ..mesh.colors.addAll([1.0, 0.0, 1.0, 1.0])
//      ..mesh.colors.addAll([0.0, 1.0, 1.0, 1.0]);
//    objects.add(quad);

//    PyramidModel pyramid = new PyramidModel()
//      ..material = new MaterialBaseVertexColor();
//    objects.add(pyramid);

//    CubeModel cube = new CubeModel()
//      ..material = new MaterialBase();
//    objects.add(cube);

//    SphereModel sphere = new SphereModel()
//      ..material = new MaterialBase();
//    objects.add(sphere);

//    AxisModel axisModel = new AxisModel()
//      ..material = new MaterialPoint(5.0);
//    objects.add(axisModel);

//    AxisPointsModel axisPointsModel = new AxisPointsModel()
//      ..material = new MaterialPoint(5.0);
//    objects.add(axisPointsModel);

  //Todo : CompoundObject

//    FrustrumGizmo frustrumGizmo = new FrustrumGizmo(
//        new Camera(radians(37.0), 1.0, 5.0)
//          ..aspectRatio = Context.viewAspectRatio
//          ..position = new Vector3(0.0, 0.0, 0.0)
//          ..targetPosition = new Vector3(0.0, 0.0, 5.0)
//    );
//    objects.addAll(frustrumGizmo.gizmoMeshes);

  //no
    Camera camera2 = new Camera(radians(37.0), 1.0, 5.0)
      ..aspectRatio = Context.viewAspectRatio
      ..targetPosition = new Vector3(0.0, 0.0, 0.0)
      ..position = new Vector3(2.0, 3.0, -5.0)
      ..showGizmo = true;
    objects.add(camera2);
    objects.addAll(camera2.gizmo.gizmoMeshes);
  }

  void render({num time : 0.0}) {
    gl.viewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
    gl.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);

    for(Object3d model in objects){
      model.render();
    }

    window.requestAnimationFrame((num time) {
      this.render(time: time);
    });
  }

}

/// 1 vertexBuffer par objet
/// mvMatrix = viewMatrix * modelMatrix
/// camera en Right Hand