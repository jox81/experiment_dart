import 'dart:html';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/geometry/meshes.dart';
import 'package:webgl/src/geometry/models.dart';
import 'dart:async';
import 'package:webgl/src/material/materials.dart';
import 'package:webgl/src/time/time.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_texture.dart';

Future<Model> experiment() async {

  ImageElement image = await TextureUtils.loadImage("./images/crate.gif");

  WebGLTexture texture = await TextureUtils.createTexture2DFromImage(image)
    ..textureWrapS = TextureWrapType.REPEAT
    ..textureWrapT = TextureWrapType.REPEAT;

  //Material
  MaterialBaseTexture materialCustom = new MaterialBaseTexture()
  ..texture = texture;

  Mesh mesh = new Mesh()
  ..mode = DrawMode.TRIANGLES
  ..vertices = [-0.5, -0.5, 0.5, 0.5, -0.5, 0.5, -0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, -0.5, 0.5, 0.5, 0.5, -0.5, 0.5, -0.5, -0.5, -0.5, 0.5, 0.5, 0.5, 0.5, 0.5, -0.5, 0.5, -0.5, 0.5, 0.5, -0.5, 0.5, -0.5, 0.5, -0.5, -0.5, 0.5, 0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, 0.5, -0.5, 0.5, 0.5, -0.5, -0.5, -0.5, -0.5, 0.5, -0.5, -0.5, -0.5, -0.5, -0.5, 0.5, -0.5, 0.5, -0.5, -0.5, 0.5, 0.5, -0.5]
  ..indices = [0, 1, 2, 3, 2, 1, 4, 5, 6, 7, 6, 5, 8, 9, 10, 11, 10, 9, 12, 13, 14, 15, 14, 13, 16, 17, 18, 19, 18, 17, 20, 21, 22, 23, 22, 21]
  ..textureCoords = [6.0, 0.0, 5.0, 0.0, 6.0, 0.9999998807907104, 5.0, 0.9999998807907104, 4.0, 0.0, 5.0, 0.0, 4.0, 1.0, 5.0, 1.0, 2.0, 0.0, 1.0, 0.0, 2.0, 1.0, 1.0, 1.0, 3.0, 0.0, 4.0, 0.0, 3.0, 1.0, 4.0, 1.0, 3.0, 0.0, 2.0, 0.0, 3.0, 1.0, 2.0, 1.0, 0.0, 0.0, 0.0, 0.9999998807907104, 1.0, 0.0, 1.0, 0.9999998807907104];
  CustomObject customObject = new CustomObject()
    ..mesh = mesh
    ..material = materialCustom;

  customObject.updateFunction = (){
  };

  return customObject;
}





