import 'dart:async';
import 'dart:html';
import 'dart:web_gl';
import 'package:vector_math/vector_math.dart';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/globals/context.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/shaders.dart';
import 'package:webgl/src/utils.dart';

Texture textureCrate;
Map susanJson;

Future main() async {

  Webgl01 webgl01 = new Webgl01(querySelector('#glCanvas'));

  await ShaderSource.loadShaders();
  susanJson = await Utils.loadJSONResource('../objects/susan/susan.json');
  webgl01.setup();
  webgl01.render();
}

class Webgl01 {

  Buffer vertexBuffer;
  Buffer indicesBuffer;

  List<Model> models = new List();

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
//      ..mesh.vertices = [
//        0.0, 0.0, 0.0,
//        0.0, 0.0, 3.0,
//        2.0, 0.0, 0.0,
//      ]
//      ..mesh.vertexDimensions = 3
//      ..mesh.indices = [0, 1, 2]
//      ..transform = (new Matrix4.identity()..setTranslation(new Vector3(0.0,0.0,0.0)))
//      ..material = new MaterialBase();
//    models.add(customObject);

//    PointModel pointModel = new PointModel();
//    models.add(pointModel);

    PointModel pointModel2 = new PointModel()
      ..transform = (new Matrix4.identity()..setTranslation(new Vector3(1.0,0.0,0.0)))
      ..material = new MaterialPoint(pointSize:7.0 ,color: new Vector4(1.0, 0.0, 0.0,1.0))
      ..visible = true;
    models.add(pointModel2);

//    LineModel line = new LineModel(new Vector3.all(0.0), new Vector3(5.0,5.0,-3.0));
//    models.add(line);

//    MultiLineModel multiLineModel = new MultiLineModel([
//      new Vector3.all(0.0),
//      new Vector3(1.0,0.0,0.0),
//      new Vector3(1.0,0.0,-1.0),
//      new Vector3(1.0,1.0,-1.0),
//      new Vector3(-2.0,1.0,-1.0),
//    ]);
//    models.add(multiLineModel);

//    TriangleModel triangleModel = new TriangleModel()
//      ..name = 'triangle'
//      ..transform.translate(0.0, 0.0, 4.0);
//    models.add(triangleModel);

//    QuadModel quad = new QuadModel()
//      ..transform.translate(2.0, 0.0, 0.0);
//    models.add(quad);

//    PyramidModel pyramid = new PyramidModel();
//    models.add(pyramid);

//    CubeModel cube = new CubeModel();
//    models.add(cube);

//    SphereModel sphere = new SphereModel();
//    models.add(sphere);

//    AxisModel axisModel = new AxisModel();
//    models.add(axisModel);

//    AxisPointsModel axisPointsModel = new AxisPointsModel();
//    models.add(axisPointsModel);

//    JsonObject jsonModel = new JsonObject(susanJson)
//      ..transform.rotateX(radians(-90.0));
//    models.add(jsonModel);

//    FrustrumGizmo frustrumGizmo = new FrustrumGizmo(
//        new Camera(radians(45.0), 1.0, 5.0)
//          ..aspectRatio = Context.viewAspectRatio
//          ..position = new Vector3(2.0, 2.0, 2.0)
//          ..targetPosition = new Vector3(0.0, 0.0, 0.0)
//    )
//    ..visible = true;
//    models.add(frustrumGizmo);

    Camera camera2 = new Camera(radians(37.0), 1.0, 5.0)
      ..aspectRatio = Context.viewAspectRatio
      ..targetPosition = new Vector3(0.0, 0.0, 0.0)
      ..position = new Vector3(2.0, 3.0, -5.0)
      ..showGizmo = true;
    models.add(camera2);


  }

  void render({num time : 0.0}) {
    gl.viewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
    gl.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);

    for(Model model in models){
      model.render();
    }

    window.requestAnimationFrame((num time) {
      this.render(time: time);
    });
  }

}