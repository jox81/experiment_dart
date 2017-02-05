import 'dart:async';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/controllers/camera_controllers.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
@MirrorsUsed(
    targets: const [
      SceneViewVectors,
    ],
    override: '*')
import 'dart:mirrors';

class SceneViewVectors extends Scene{

  SceneViewVectors();

  Camera cameraTest;

  MaterialBaseColor matVectorA;
  MaterialBaseColor matVectorB;
  MaterialBaseColor matVectorResult;

  AxisModel axis;
  GridModel grid;

  @override
  Future setupScene() async {

    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

    //Cameras
    Camera camera = new Camera(radians(37.0), 0.1, 1000.0)
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(3.0, 10.0, 10.0);
    Context.mainCamera = camera;

    matVectorA = new MaterialBaseColor(new Vector4(1.0,1.0,0.0,1.0));
    matVectorB = new MaterialBaseColor(new Vector4(0.0,0.0,1.0,1.0));
    matVectorResult = new MaterialBaseColor(new Vector4(1.0,0.0,0.0,1.0));

    cameraTest = new Camera(radians(45.0), 0.2, 5.0)
      ..targetPosition = new Vector3(1.0, 0.0, 0.0)
      ..position = new Vector3(3.0, 3.0, 3.0)
      ..showGizmo = true;
    cameras.add(cameraTest);

    axis = new AxisModel();
    models.add(axis);
    grid = new GridModel();
    models.add(grid);

//    test01();
//    test02();
//    test03();
    testViewProjectionMatrix();
//    testDisplayNormals();
  }

  /// basic add vector result
  void test01() {
    VectorModel vectorModelA = new VectorModel(new Vector3(3.0,0.0,-3.0))
    ..material = matVectorA;
    models.add(vectorModelA);

    VectorModel vectorModelB = new VectorModel(new Vector3(-2.0,0.0,-2.0))
      ..material = matVectorB;
    models.add(vectorModelB);

    VectorModel vectorModelR = new VectorModel(vectorModelA.vec + vectorModelB.vec)
      ..material = matVectorResult;
    models.add(vectorModelR);
  }

  /// matrix transform
  void test02() {

    Matrix4 matrixTest = new Matrix4.identity()..rotateZ(radians(45.0));

    VectorModel vectorModelA = new VectorModel(new Vector3(3.0,0.0,0.0))
      ..material = matVectorA;
    models.add(vectorModelA);

    VectorModel vectorModelR = new VectorModel(matrixTest * vectorModelA.vec)
      ..material = matVectorResult;
    models.add(vectorModelR);
  }

  /// camera
  void test03() {

    Matrix4 uModelViewMatrix = Context.modelViewMatrix;
    Matrix4 uProjectionMatrix = Context.mainCamera.viewProjecionMatrix;

    VectorModel vectorModelA = new VectorModel(new Vector3(3.0,0.0,0.0))
      ..material = matVectorA;
    models.add(vectorModelA);

    VectorModel vectorModelR = new VectorModel(uProjectionMatrix * uModelViewMatrix * vectorModelA.vec)
      ..material = matVectorResult;
    models.add(vectorModelR);
  }

  //Projection view Matrix test
  void testViewProjectionMatrix() {

    Vector3 cameraPosition = new Vector3(0.0,2.0,2.0);
    Vector3 cameraTargetPosition = new Vector3(0.0,0.0,1.0);

    cameraTest
      ..fov = radians(150.0)
      ..targetPosition = cameraTargetPosition
      ..position = cameraPosition;

    AxisModel axisTest = new AxisModel()
    ..position = new Vector3(0.0,0.0,0.0)
    ..transform.rotateY(radians(0.0));
    models.add(axisTest);

    GridModel gridTest = new GridModel();
    models.add(gridTest);

    PointModel pointTest = new PointModel()
    ..position = new Vector3(1.0,0.0,1.0);
    models.add(pointTest);

//    Vector3 vertexPosition = new Vector3(1.0, 0.0, 1.0);
//
//    Matrix4 modelMatrix = axis.transform;
//
//    Matrix4 viewMatrix = cameraTest.lookAtMatrix;
//    Matrix4 projectionMatrix = cameraTest.perspectiveMatrix;

//    Matrix4 finalMatrix = projectionMatrix * viewMatrix * new Matrix4.identity();
//    pointTest.transform = finalMatrix * axisTest.transform * pointTest.transform;
//    gridTest.transform = finalMatrix * gridTest.transform;
//    axisTest.transform = finalMatrix * axisTest.transform;

    Matrix4 finalMatrix = new Matrix4.inverted(cameraTest.lookAtMatrix) * new Matrix4.identity();
    gridTest.transform = finalMatrix * gridTest.transform;
    axisTest.transform = finalMatrix * axisTest.transform;

  }

  //Nomral tests
  void testDisplayNormals() {

//    QuadModel model = new QuadModel();
    CubeModel model = new CubeModel();
//    SphereModel model = new SphereModel(radius: 2.0, segmentV: 12, segmentH: 12);

    models.add(model);
    buildNormals(model);
  }

  //Todo : optimiser en ne rendant qu'un seul MultiLineModel
  void buildNormals(Model model) {
    List<Vector3> normalPoints = new List();

    for(int i = 0; i < model.mesh.vertexNormalsCount; i++){

      //the normal
      num nX = model.mesh.vertexNormals[i * model.mesh.vertexNormalsDimensions + 0];
      num nY = model.mesh.vertexNormals[i * model.mesh.vertexNormalsDimensions + 1];
      num nZ = model.mesh.vertexNormals[i * model.mesh.vertexNormalsDimensions + 2];
      Vector3 normal = new Vector3(nX, nY, nZ);

      //position of the normal
      num pX = model.mesh.vertices[i * model.mesh.vertexDimensions + 0];
      num pY = model.mesh.vertices[i * model.mesh.vertexDimensions + 1];
      num pZ = model.mesh.vertices[i * model.mesh.vertexDimensions + 2];
      Vector3 vertex = new Vector3(pX, pY, pZ);

      normalPoints.add(vertex);
      normalPoints.add(vertex + normal);
    }

    MultiLineModel normals = new MultiLineModel(normalPoints)
      ..mesh.mode = DrawMode.LINES
      ..material = matVectorA;
    models.add(normals);
  }

}
