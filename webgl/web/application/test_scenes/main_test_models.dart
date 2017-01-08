import 'dart:async';
import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/texture_utils.dart';
import 'package:webgl/src/utils.dart';
import 'package:webgl/src/webgl_objects/webgl_buffer.dart';
import 'package:webgl/src/webgl_objects/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'package:webgl/src/webgl_objects/webgl_shader.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';
import 'package:webgl/src/webgl_objects/webgl_uniform_location.dart';

WebGLTexture textureCrate;
Map susanJson;

Future main() async {

  await ShaderSource.loadShaders();
  susanJson = await Utils.loadJSONResource('../objects/susan/susan.json');

  Webgl01 webgl01 = new Webgl01(querySelector('#glCanvas'));
  webgl01.setup();
  webgl01.render();
}

class Webgl01 {

  WebGLBuffer vertexBuffer;
  WebGLBuffer indicesBuffer;

  List<Model> models = new List();

  WebGLProgram shaderProgram;

  int vertexPositionAttribute;

  WebGLUniformLocation pMatrixUniform;
  WebGLUniformLocation mvMatrixUniform;

  Webgl01(CanvasElement canvas){
    initGL(canvas);
  }

  void initGL(CanvasElement canvas) {
    Context.init(canvas,enableExtensions:true,logInfos:false);
  }

  void setup(){
    setupCamera();
    setupMeshes();

    gl.clearColor = new Vector4(0.0, 0.0, 0.0, 1.0);
    gl.depthTest = true;
  }

  void setupCamera()  {
    Context.mainCamera = new Camera(radians(45.0), 0.1, 100.0)
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

//    PointModel pointModel2 = new PointModel()
//      ..transform = (new Matrix4.identity()..setTranslation(new Vector3(1.0,0.0,0.0)))
//      ..material = new MaterialPoint(pointSize:7.0 ,color: new Vector4(1.0, 0.0, 0.0,1.0))
//      ..visible = true;
//    models.add(pointModel2);

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
//      ..transform.translate(0.0, 0.0, 0.0);
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

    AxisModel axisModel = new AxisModel();
    models.add(axisModel);

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
      ..targetPosition = new Vector3(0.0, 0.0, 0.0)
      ..position = new Vector3(5.0, 5.0, -5.0)
      ..showGizmo = true;
    models.add(camera2);

//    models.addAll(Utils.unProjectMultiScreenPoints(camera2));

//    gl.canvas.onMouseUp.listen((MouseEvent e) {
//      Vector3 outRayNear = new Vector3.zero();
//      Utils.unProjectScreenPoint(camera2, outRayNear, e.offset.x, e.offset.y);
//      models.add(new PointModel()
//        ..transform = (new Matrix4.identity()..setTranslation(outRayNear))
//        ..material = new MaterialPoint(pointSize:6.0 ,color: new Vector4(1.0, 0.0, 0.0,1.0))
//        ..visible = true);
//    });

//    gl.canvas.onMouseUp.listen((MouseEvent e) {
//      Vector3 outRayNear = new Vector3.zero();
//      Vector3 outRayFar = new Vector3.zero();
//      Utils.pickRayFromScreenPoint(camera2, outRayNear, outRayFar, e.offset.x, e.offset.y);
//      models.add(new PointModel()
//        ..transform = (new Matrix4.identity()..setTranslation(outRayNear))
//        ..material = new MaterialPoint(pointSize:6.0 ,color: new Vector4(1.0, 0.0, 0.0,1.0))
//        ..visible = true);
//      models.add(new PointModel()
//        ..transform = (new Matrix4.identity()..setTranslation(outRayFar))
//        ..material = new MaterialPoint(pointSize:6.0 ,color: new Vector4(1.0, 0.0, 0.0,1.0))
//        ..visible = true);
//    });

//    Sphere sphere = new Sphere.centerRadius(new Vector3.zero(), .5);
//
//    gl.canvas.onMouseUp.listen((MouseEvent e) {
//
//      Vector3 outRayNear = new Vector3.zero();
//      Utils.unProjectScreenPoint(camera2, outRayNear, e.offset.x, e.offset.y);
//
//      models.add(new PointModel()
//        ..transform = (new Matrix4.identity()..setTranslation(outRayNear))
//        ..material = new MaterialPoint(pointSize:5.0 ,color: new Vector4(1.0, 0.0, 0.0,1.0))
//        ..visible = true);
//
//      Vector3 direction = outRayNear - camera2.position;
//      Ray ray = new Ray.originDirection(outRayNear, direction);
//
//      num distance = ray.intersectsWithSphere(sphere);
//      print(distance);
//
//      if(distance != null) {
//        models.add(new PointModel()
//          ..transform = (new Matrix4.identity()
//            ..setTranslation(ray.at(distance)))
//          ..material = new MaterialPoint(
//              pointSize: 5.0, color: new Vector4(1.0, 0.0, 0.0, 1.0))
//          ..visible = true);
//      }
//    });

    TriangleModel triangleModel = new TriangleModel()
      ..name = 'triangle'
      ..position = new Vector3(1.0, 0.0, 0.0);
    models.add(triangleModel);

    TriangleModel triangleModel2 = new TriangleModel()
      ..name = 'triangle2'
      ..position = new Vector3(-3.0, 0.0, 0.0);
    models.add(triangleModel2);

    List<Model> modelsHit = [triangleModel, triangleModel2];

    models.addAll(Utils.drawModelVertices(modelsHit[0]));

    gl.canvas.onMouseUp.listen((MouseEvent e) {
      Ray ray = Utils.findRay(Context.mainCamera, e.offset.x, e.offset.y);

      models.addAll(Utils.findModelHitPoint(modelsHit[1],ray));
      print(Utils.findModelHit(modelsHit, ray)?.name);
    });

  }

  void render({num time : 0.0}) {
    gl.viewport = new Rectangle(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
    gl.clear([ClearBufferMask.COLOR_BUFFER_BIT, ClearBufferMask.DEPTH_BUFFER_BIT]);

    for(Model model in models){
      model.render();
    }

    TextureUtils.readPixels();
//    window.requestAnimationFrame((num time) {
//      this.render(time: time);
//    });
  }

}