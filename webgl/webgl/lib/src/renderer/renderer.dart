import 'package:webgl/src/project/project.dart';

abstract class Renderer{
  void render({num currentTime: 0.0});
  void init(Project project);
}