import 'package:webgl/src/project/project.dart';

abstract class Animator{
  void init(Project project);
  void update({num currentTime: 0.0});
}