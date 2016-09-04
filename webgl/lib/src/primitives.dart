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