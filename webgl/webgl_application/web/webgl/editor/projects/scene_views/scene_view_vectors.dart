import 'package:vector_math/vector_math.dart';
import 'package:webgl/engine.dart';
import 'package:webgl/src/gltf/mesh/mesh.dart';
import 'package:webgl/src/gltf/node.dart';
import 'package:webgl/src/gltf/project/project.dart';
import 'package:webgl/materials.dart';
import 'package:webgl/src/gltf/scene.dart';
import 'package:webgl/src/webgl_objects/context.dart';
import 'package:webgl/src/camera/types/perspective_camera.dart';

import 'material_library.dart';

Future<GLTFProject> projectSceneViewVector() async {

  GLTFProject project = new GLTFProject.create();
  GLTFScene scene = new GLTFScene()
    ..backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);
  project.scene = scene;

  Engine.mainCamera = new
  CameraPerspective(radians(37.0), 0.1, 1000.0)
    ..targetPosition = new Vector3.zero()
    ..translation = new Vector3(10.0, 10.0, 10.0);
//    ..showGizmo = true;// Todo (jpu) :

  //> materials

  MaterialLibrary materialLibrary = new MaterialLibrary();
  await materialLibrary.loadRessources();

  MaterialBaseColor matVectorA = new MaterialBaseColor(new Vector4(1.0,1.0,0.0,1.0));
  MaterialBaseColor matVectorB = new MaterialBaseColor(new Vector4(0.0,1.0,1.0,1.0));
  MaterialBaseColor matVectorResult = new MaterialBaseColor(new Vector4(1.0,0.0,0.0,1.0));

  GLTFMesh meshAxis = new GLTFMesh.axis()
    ..primitives[0].material = materialLibrary.materialBaseVertexColor;
  project.meshes.add(meshAxis);
  GLTFNode nodeAxis = new GLTFNode()
    ..mesh = meshAxis
    ..name = 'axis'
    ..translation = new Vector3(0.0, 0.0, 0.0);
  scene.addNode(nodeAxis);
  project.addNode(nodeAxis);

  GLTFMesh meshGrid = new GLTFMesh.grid()
    ..primitives[0].material = materialLibrary.materialBaseVertexColor;
  project.meshes.add(meshGrid);
  GLTFNode nodeGrid = new GLTFNode()
    ..mesh = meshGrid
    ..name = 'grid'
    ..translation = new Vector3(0.0, 0.0, 0.0);
  scene.addNode(nodeGrid);
  project.addNode(nodeGrid);

  /// basic vector operation result
  void test01() {
    Vector3 vectorA = new Vector3(3.0,0.0,-3.0);
    Vector3 vectorB = new Vector3(-2.0,0.0,-2.0);
    Vector3 vectorResult = vectorA + vectorB;

    GLTFMesh meshVectorA = new GLTFMesh.vector(vectorA)
      ..primitives[0].material = matVectorA;
    project.meshes.add(meshVectorA);
    GLTFNode nodeVectorA = new GLTFNode()
      ..mesh = meshVectorA
      ..name = 'vector';
    scene.addNode(nodeVectorA);
    project.addNode(nodeVectorA);

    GLTFMesh meshVectorB = new GLTFMesh.vector(vectorB)
      ..primitives[0].material = matVectorB;
    project.meshes.add(meshVectorB);
    GLTFNode nodeVectorB = new GLTFNode()
      ..mesh = meshVectorB
      ..name = 'vector';
    scene.addNode(nodeVectorB);
    project.addNode(nodeVectorB);

    GLTFMesh meshVectorR = new GLTFMesh.vector(vectorResult)
      ..primitives[0].material = matVectorResult;
    project.meshes.add(meshVectorR);
    GLTFNode nodeVectorR = new GLTFNode()
      ..mesh = meshVectorR
      ..name = 'vector';
    scene.addNode(nodeVectorR);
    project.addNode(nodeVectorR);
  }

  /// matrix transform
  void test02() {

    Matrix4 matrixTest = new Matrix4.identity()..rotateZ(radians(45.0));
    Vector3 vectorA = new Vector3(3.0,0.0,0.0);
    Vector3 vectorResult = matrixTest * vectorA;

    GLTFMesh meshVectorA = new GLTFMesh.vector(vectorA)
      ..primitives[0].material = matVectorA;
    project.meshes.add(meshVectorA);
    GLTFNode nodeVectorA = new GLTFNode()
      ..mesh = meshVectorA
      ..name = 'vector';
    scene.addNode(nodeVectorA);
    project.addNode(nodeVectorA);

    GLTFMesh meshVectorR = new GLTFMesh.vector(vectorResult)
      ..primitives[0].material = matVectorResult;
    project.meshes.add(meshVectorR);
    GLTFNode nodeVectorR = new GLTFNode()
      ..mesh = meshVectorR
      ..name = 'vector';
    scene.addNode(nodeVectorR);
    project.addNode(nodeVectorR);
  }

  /// camera
  void test03() {
    Matrix4 uModelViewMatrix = Engine.mainCamera.viewMatrix.multiplied(new Matrix4.identity());
    Matrix4 uProjectionMatrix = Engine.mainCamera.projectionMatrix;
    Vector3 vectorA = new Vector3(3.0,0.0,0.0);
    Vector3 vectorResult = uProjectionMatrix * uModelViewMatrix * vectorA;

    GLTFMesh meshVectorA = new GLTFMesh.vector(vectorA)
      ..primitives[0].material = matVectorA;
    project.meshes.add(meshVectorA);
    GLTFNode nodeVectorA = new GLTFNode()
      ..mesh = meshVectorA
      ..name = 'vector';
    scene.addNode(nodeVectorA);
    project.addNode(nodeVectorA);

    GLTFMesh meshVectorR = new GLTFMesh.vector(vectorResult)
      ..primitives[0].material = matVectorResult;
    project.meshes.add(meshVectorR);
    GLTFNode nodeVectorR = new GLTFNode()
      ..mesh = meshVectorR
      ..name = 'vector';
    scene.addNode(nodeVectorR);
    project.addNode(nodeVectorR);

  }

  /// rotate Vector3
  void testRotateVector() {
    Vector3 vectorA = new Vector3(-3.0,2.0,3.0);//camera.targetPosition
    Vector3 vectorB = new Vector3(3.0,2.0,3.0);//camera.translation

    num xAngleRot = -45;

    Vector3 targetForm0 = vectorB - vectorA;
    Matrix4 identity = new Matrix4.identity()..rotateY(radians(xAngleRot.toDouble()));
    targetForm0.applyMatrix4(identity);
    targetForm0 += vectorA;
    Vector3 vectorResult = targetForm0;


    GLTFMesh meshVectorA = new GLTFMesh.vector(vectorA)
      ..primitives[0].material = matVectorA;
    project.meshes.add(meshVectorA);
    GLTFNode nodeVectorA = new GLTFNode()
      ..mesh = meshVectorA
      ..name = 'vector';
    scene.addNode(nodeVectorA);
    project.addNode(nodeVectorA);

    GLTFMesh meshVectorB = new GLTFMesh.vector(vectorB)
      ..primitives[0].material = matVectorB;
    project.meshes.add(meshVectorB);
    GLTFNode nodeVectorB = new GLTFNode()
      ..mesh = meshVectorB
      ..name = 'vector';
    scene.addNode(nodeVectorB);
    project.addNode(nodeVectorB);

    GLTFMesh meshVectorR = new GLTFMesh.vector(vectorResult)
      ..primitives[0].material = matVectorResult;
    project.meshes.add(meshVectorR);
    GLTFNode nodeVectorR = new GLTFNode()
      ..mesh = meshVectorR
      ..name = 'vector';
    scene.addNode(nodeVectorR);
    project.addNode(nodeVectorR);
  }

  //Projection view Matrix test
  void testViewProjectionMatrix() {

    Vector3 cameraPosition = new Vector3(0.0,2.0,2.0);
    Vector3 cameraTargetPosition = new Vector3(0.0,0.0,1.0);

    (Engine.mainCamera as CameraPerspective)
      ..yfov = radians(150.0)
      ..targetPosition = cameraTargetPosition
      ..translation = cameraPosition;

    GLTFMesh meshAxisTest = new GLTFMesh.axis()
      ..primitives[0].material = materialLibrary.materialBaseVertexColor;
    project.meshes.add(meshAxisTest);
    GLTFNode nodeAxisTest = new GLTFNode()
      ..mesh = meshAxisTest
      ..name = 'axisTest'
      ..translation = new Vector3(0.0, 0.0, 0.0)
      ..matrix.rotateY(radians(0.0));
    scene.addNode(nodeAxisTest);
    project.addNode(nodeAxisTest);

    GLTFMesh meshGridTest = new GLTFMesh.grid()
      ..primitives[0].material = materialLibrary.materialBaseVertexColor;
    project.meshes.add(meshGridTest);
    GLTFNode nodeGridTest = new GLTFNode()
      ..mesh = meshGridTest
      ..name = 'grid'
      ..translation = new Vector3(0.0, 0.0, 0.0);
    scene.addNode(nodeGridTest);
    project.addNode(nodeGridTest);

//    PointMesh pointTest = new PointMesh()
//    ..translation = new Vector3(1.0,0.0,1.0);
//    meshes.add(pointTest);

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

    Matrix4 finalMatrix = new Matrix4.inverted(Engine.mainCamera.viewMatrix).multiplied(new Matrix4.identity());
    nodeGridTest.matrix = (finalMatrix * nodeGridTest.matrix) as Matrix4;
    nodeAxisTest.matrix = (finalMatrix * nodeAxisTest.matrix) as Matrix4;

  }

  //Projection view Matrix test
  void testViewProjectionMatrix2() {
    Vector3 cameraPosition = new Vector3(0.0,1.0,3.0);
    Vector3 cameraTargetPosition = new Vector3(0.0,0.0,0.0);

    CameraPerspective cameraTest = new
    CameraPerspective(radians(37.0), 0.1, 1000.0)
      ..targetPosition = new Vector3.zero()
      ..translation = new Vector3(10.0, 10.0, 10.0);
    cameraTest
      ..yfov = radians(45.0)
      ..targetPosition = cameraTargetPosition
      ..translation = cameraPosition;

    GLTFMesh meshAxisTest = new GLTFMesh.axis()
      ..primitives[0].material = materialLibrary.materialBaseVertexColor;
    project.meshes.add(meshAxisTest);
    GLTFNode nodeAxisTest = new GLTFNode()
      ..mesh = meshAxisTest
      ..name = 'axisTest'
      ..translation = new Vector3(0.0, 0.0, 0.0)
      ..matrix.rotateY(radians(0.0));
    scene.addNode(nodeAxisTest);
    project.addNode(nodeAxisTest);

    // à tester :

    nodeAxisTest.matrix = cameraTest.matrix;

  }

  // Todo (jpu) :
//  //Nomral tests
//  void testDisplayNormals() {
//
////    QuadMesh model = new QuadMesh();
//    CubeMesh model = new CubeMesh();
////    SphereMesh model = new SphereMesh(radius: 2.0, segmentV: 12, segmentH: 12);
//
//    meshes.add(model);
//    buildNormals(model);
//  }
//
//  //Todo : optimiser en ne rendant qu'un seul MultiLineMesh
//  void buildNormals(Mesh model) {
//    List<Vector3> normalPoints = new List();
//
//    for(int i = 0; i < model.primitive.vertexNormalsCount; i++){
//
//      //the normal
//      double nX = model.primitive.vertexNormals[i * model.primitive.vertexNormalsDimensions + 0];
//      double nY = model.primitive.vertexNormals[i * model.primitive.vertexNormalsDimensions + 1];
//      double nZ = model.primitive.vertexNormals[i * model.primitive.vertexNormalsDimensions + 2];
//      Vector3 normal = new Vector3(nX, nY, nZ);
//
//      //position of the normal
//      double pX = model.primitive.vertices[i * model.primitive.vertexDimensions + 0];
//      double pY = model.primitive.vertices[i * model.primitive.vertexDimensions + 1];
//      double pZ = model.primitive.vertices[i * model.primitive.vertexDimensions + 2];
//      Vector3 vertex = new Vector3(pX, pY, pZ);
//
//      normalPoints.add(vertex);
//      normalPoints.add(vertex + normal);
//    }
//
//    MultiLineMesh normals = new MultiLineMesh(normalPoints)
//      ..primitive.mode = DrawMode.LINES
//      ..material = matVectorA;
//    meshes.add(normals);
//  }

//  test01();
//  test02();
//  test03();
  testRotateVector();
//  testViewProjectionMatrix();
//  testViewProjectionMatrix2();
//  testDisplayNormals();// Todo (jpu) :

  return project;
}