import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/context.dart';
import 'package:webgl/src/camera.dart';
import 'dart:async';
import 'package:webgl/src/scene.dart';
@MirrorsUsed(
    targets: const [
      SceneViewTestJsonLights,
    ],
    override: '*')
import 'dart:mirrors';

class SceneViewTestJsonLights extends Scene{

  CameraPerspective camera;

  SceneViewTestJsonLights();

  @override
  Future setupScene() async {
    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

    //Cameras
    // field of view is 45°, width-to-height ratio, hide things closer than 0.1 or further than 100
    camera = new CameraPerspective(radians(45.0), 5.0, 1000.0)
      ..targetPosition = new Vector3.zero()
      ..position = new Vector3(5.0, 7.5, 10.0)
      ..showGizmo = true;
    cameras.add(camera);
    Context.mainCamera = camera;

  }
}