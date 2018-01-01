import 'dart:async';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/camera.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/geometry/mesh.dart';
import 'package:webgl/src/material/materials.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
@MirrorsUsed(
    targets: const [
      SceneViewVectors,
    ],
    override: '*')
import 'dart:mirrors';

class SceneViewVectors extends SceneJox{

  SceneViewVectors();

  CameraPerspective cameraTest;

  MaterialBaseColor matVectorA;
  MaterialBaseColor matVectorB;
  MaterialBaseColor matVectorResult;

  AxisMesh axis;
  GridMesh grid;

  @override
  Future setupScene() async {

    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

    //Cameras
    CameraPerspective camera = new CameraPerspective(radians(37.0), 0.1, 1000.0)
      ..targetPosition = new Vector3.zero()
      ..translation = new Vector3(3.0, 10.0, 10.0);
    Context.mainCamera = camera;

    matVectorA = new MaterialBaseColor(new Vector4(1.0,1.0,0.0,1.0));
    matVectorB = new MaterialBaseColor(new Vector4(0.0,0.0,1.0,1.0));
    matVectorResult = new MaterialBaseColor(new Vector4(1.0,0.0,0.0,1.0));

    cameraTest = new CameraPerspective(radians(45.0), 0.2, 5.0)
      ..targetPosition = new Vector3(1.0, 0.0, 0.0)
      ..translation = new Vector3(3.0, 3.0, 3.0)
      ..showGizmo = true;
    cameras.add(cameraTest);

    axis = new AxisMesh();
    meshes.add(axis);
    grid = new GridMesh();
    meshes.add(grid);

//    test01();
//    test02();
    test03();
//    testViewProjectionMatrix();
//    testViewProjectionMatrix2();
//    testDisplayNormals();
  }

  /// basic add vector result
  void test01() {
    VectorMesh vectorMeshA = new VectorMesh(new Vector3(3.0,0.0,-3.0))
    ..material = matVectorA;
    meshes.add(vectorMeshA);

    VectorMesh vectorMeshB = new VectorMesh(new Vector3(-2.0,0.0,-2.0))
      ..material = matVectorB;
    meshes.add(vectorMeshB);

    VectorMesh vectorMeshR = new VectorMesh(vectorMeshA.vec + vectorMeshB.vec)
      ..material = matVectorResult;
    meshes.add(vectorMeshR);
  }

  /// matrix transform
  void test02() {

    Matrix4 matrixTest = new Matrix4.identity()..rotateZ(radians(45.0));

    VectorMesh vectorMeshA = new VectorMesh(new Vector3(3.0,0.0,0.0))
      ..material = matVectorA;
    meshes.add(vectorMeshA);

    VectorMesh vectorMeshR = new VectorMesh((matrixTest * vectorMeshA.vec) as Vector3)
      ..material = matVectorResult;
    meshes.add(vectorMeshR);
  }

  /// camera
  void test03() {

    Matrix4 uModelViewMatrix = Context.mainCamera.viewMatrix.multiplied(Context.modelMatrix);
    Matrix4 uProjectionMatrix = Context.mainCamera.projectionMatrix;

    VectorMesh vectorMeshA = new VectorMesh(new Vector3(3.0,0.0,0.0))
      ..material = matVectorA;
    meshes.add(vectorMeshA);

    VectorMesh vectorMeshR = new VectorMesh((uProjectionMatrix * uModelViewMatrix * vectorMeshA.vec) as Vector3)
      ..material = matVectorResult;
    meshes.add(vectorMeshR);
  }

  //Projection view Matrix test
  void testViewProjectionMatrix() {

    Vector3 cameraPosition = new Vector3(0.0,2.0,2.0);
    Vector3 cameraTargetPosition = new Vector3(0.0,0.0,1.0);

    cameraTest
      ..yfov = radians(150.0)
      ..targetPosition = cameraTargetPosition
      ..translation = cameraPosition;

    AxisMesh axisTest = new AxisMesh()
    ..translation = new Vector3(0.0,0.0,0.0)
    ..matrix.rotateY(radians(0.0));
    meshes.add(axisTest);

    GridMesh gridTest = new GridMesh();
    meshes.add(gridTest);

    PointMesh pointTest = new PointMesh()
    ..translation = new Vector3(1.0,0.0,1.0);
    meshes.add(pointTest);

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

    Matrix4 finalMatrix = new Matrix4.inverted(cameraTest.viewMatrix).multiplied(new Matrix4.identity());
    gridTest.matrix = (finalMatrix * gridTest.matrix) as Matrix4;
    axisTest.matrix = (finalMatrix * axisTest.matrix) as Matrix4;

  }

  //Projection view Matrix test
  void testViewProjectionMatrix2() {
    Vector3 cameraPosition = new Vector3(0.0,1.0,3.0);
    Vector3 cameraTargetPosition = new Vector3(0.0,0.0,0.0);

    cameraTest
      ..yfov = radians(45.0)
      ..targetPosition = cameraTargetPosition
      ..translation = cameraPosition;

    AxisMesh axisTest = new AxisMesh()
      ..translation = new Vector3(0.0,0.0,0.0)
      ..matrix.rotateY(radians(0.0));
    meshes.add(axisTest);

    // à tester :

    axisTest.matrix = cameraTest.matrix;

  }

  //Nomral tests
  void testDisplayNormals() {

//    QuadMesh model = new QuadMesh();
    CubeMesh model = new CubeMesh();
//    SphereMesh model = new SphereMesh(radius: 2.0, segmentV: 12, segmentH: 12);

    meshes.add(model);
    buildNormals(model);
  }

  //Todo : optimiser en ne rendant qu'un seul MultiLineMesh
  void buildNormals(Mesh model) {
    List<Vector3> normalPoints = new List();

    for(int i = 0; i < model.primitive.vertexNormalsCount; i++){

      //the normal
      double nX = model.primitive.vertexNormals[i * model.primitive.vertexNormalsDimensions + 0];
      double nY = model.primitive.vertexNormals[i * model.primitive.vertexNormalsDimensions + 1];
      double nZ = model.primitive.vertexNormals[i * model.primitive.vertexNormalsDimensions + 2];
      Vector3 normal = new Vector3(nX, nY, nZ);

      //position of the normal
      double pX = model.primitive.vertices[i * model.primitive.vertexDimensions + 0];
      double pY = model.primitive.vertices[i * model.primitive.vertexDimensions + 1];
      double pZ = model.primitive.vertices[i * model.primitive.vertexDimensions + 2];
      Vector3 vertex = new Vector3(pX, pY, pZ);

      normalPoints.add(vertex);
      normalPoints.add(vertex + normal);
    }

    MultiLineMesh normals = new MultiLineMesh(normalPoints)
      ..primitive.mode = DrawMode.LINES
      ..material = matVectorA;
    meshes.add(normals);
  }

}
