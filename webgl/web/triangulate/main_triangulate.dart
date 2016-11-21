import 'package:vector_math/vector_math.dart';
import 'src/glStuff.dart';
import 'src/mesh.dart';

void main() {

  buildMeshData();
  initGL();
  initShaders();
  setupCamera();

  initBuffers();
  drawScene();
}

void buildMeshData() {

//  List<num> vertices = [
//    0.0,  0.0,  0.0,
//    -2.0,  1.0,  0.0,
//    -1.0,  2.0,  0.0,
//    -3.0,  2.0,  0.0,
//    -1.0,  3.0,  0.0,
//    -2.0,  3.0,  0.0,
//    -3.0,  3.0,  0.0,
//    -4.0,  2.0,  0.0,
//    -4.0,  4.0,  0.0,
//    -5.0,  4.0,  0.0,
//    -4.0,  5.0,  0.0,
//    -3.0,  4.0,  0.0,
//    -2.0,  4.0,  0.0,
//    -1.0,  6.0,  0.0,
//    1.0,  5.0,  0.0,
//    2.0,  3.0,  0.0,
//    2.0,  4.0,  0.0,
//    3.0,  4.0,  0.0,
//    3.0,  2.0,  0.0,
//    1.0,  3.0,  0.0,
//    0.0,  3.0,  0.0,
//    1.0,  4.0,  0.0,
//    -1.0,  5.0,  0.0,
//    0.0,  2.0,  0.0,
//    -1.0,  1.0,  0.0,
//    1.0,  0.0,  0.0
//
//  ];
//
//  List<int> indices = triangulateShape(vertices);

  Mesh mesh = new Mesh();
  mesh.vertices = [
    0.0,  0.0,  0.0,
    0.0,  2.0,  0.0,
    2.0,  2.0,  0.0,
    2.0,  0.0,  0.0
    ];
//  mesh.triangulateMesh();
  mesh.indices = [
    0,1,2,
    0,2,3
  ];
  mesh.color = Colors.red;

  meshes.add(mesh);

  Mesh mesh2 = new Mesh();
  mesh2.vertices = [
    4.0,  0.0,  0.0,
    4.0,  2.0,  0.0,
    6.0,  2.0,  0.0,
    6.0,  0.0,  0.0
  ];
  mesh2.triangulateMesh();
  meshes.add(mesh2);

  Mesh mesh3 = new Mesh();
  mesh3.vertices = [
    3.0,  6.0,  0.0,
    4.0,  7.0,  0.0,
    5.0,  6.0,  0.0
  ];
  mesh3.triangulateMesh();
  meshes.add(mesh3);

  Mesh simpleTriangle = new Mesh();
  simpleTriangle.vertices = [
    -0.5,0.5,0.0,
    -0.5,-0.5,0.0,
    0.5,-0.5,0.0,
  ];
  simpleTriangle.indices = [0,1,2];
  meshes.add(simpleTriangle);
}
