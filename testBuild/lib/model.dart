import 'package:testBuild/introspection.dart';
@MirrorsUsed(
    targets: const [
      Model,
      Triangle,
      Cube,
      CustomModel
    ],
    override: '*')
import 'dart:mirrors';

abstract class Model extends IEditElement {
  String name;
  num size = 15.2;
}

class Triangle extends Model{
  int vertex = 3;
  String customName = "customNameTriangle";
}

class Cube extends Model{
  int vertex = 4;
  String customName = "customNameCube";
}

class CustomModel extends IEditElement{
  String name = 'theCustomModel';
  num size = 13.13;
}