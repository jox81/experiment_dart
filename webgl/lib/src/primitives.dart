import 'package:webgl/src/mesh.dart';
import 'dart:async';
import 'package:webgl/src/materials.dart';
import 'package:webgl/src/application.dart';
import 'package:gl_enums/gl_enums.dart' as GL;

Future<Mesh> createAxis() async {

  //Material
  MaterialPoint materialPoint = await MaterialPoint.create(5.0);
  Application.instance.materials.add(materialPoint);

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

  Application.instance.meshes.add(mesh);

  return mesh;
}