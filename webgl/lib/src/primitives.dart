import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/mesh.dart';
import 'dart:async';
import 'package:webgl/src/materials.dart';
import 'package:gl_enums/gl_enums.dart' as GL;
import 'package:webgl/src/scene.dart';

Future<Mesh> createAxis(Scene scene) async {

  //Material
  MaterialPoint materialPoint = await MaterialPoint.create(5.0);
  scene.materials.add(materialPoint);

  Mesh mesh = new Mesh()
    ..mode = GL.LINES
    ..vertices = [
      0.0,0.0,0.0,
      1.0,0.0,0.0,
      0.0,0.0,0.0,
      0.0,1.0,0.0,
      0.0,0.0,0.0,
      0.0,0.0,1.0,
    ]
    ..colors = [
      1.0,0.0,0.0,1.0,
      1.0,0.0,0.0,1.0,
      0.0,1.0,0.0,1.0,
      0.0,1.0,0.0,1.0,
      0.0,0.0,1.0,1.0,
      0.0,0.0,1.0,1.0,
    ]
    ..material = materialPoint;

  scene.meshes.add(mesh);

  return mesh;
}

//Points
Future<Mesh> createAxisPoints(MaterialPoint materialPoint) async {

  Mesh mesh = new Mesh()
    ..mode = GL.POINTS
    ..vertices = [
      0.0, 0.0, 0.0,
      1.0, 0.0, 0.0,
      0.0, 1.0, 0.0,
      0.0, 0.0, 1.0,
    ]
    ..colors = [
      1.0, 1.0, 0.0, 1.0,
      1.0, 0.0, 0.0, 1.0,
      0.0, 1.0, 0.0, 1.0,
      0.0, 0.0, 1.0, 1.0,
    ]
    ..material = materialPoint;

  return mesh;
}

Future<Mesh> createPoint(MaterialPoint materialPoint) async {

  Mesh mesh = new Mesh()
    ..mode = GL.POINTS
    ..vertices = [
      0.0, 0.0, 0.0,
    ]
    ..colors = [
      1.0, 1.0, 0.0, 1.0,
    ]
    ..material = materialPoint;

  return mesh;
}


