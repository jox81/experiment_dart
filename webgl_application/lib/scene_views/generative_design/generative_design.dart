import 'dart:async';
import 'package:webgl_application/scene_views/generative_design/P_1_0_01.dart';
import 'package:webgl/src/scene.dart';

class ServiceScene {
 static  Future<List<Scene>> getGenerativeDesignScenes() async => [
  new P_1_0_01(),
 ];
}
