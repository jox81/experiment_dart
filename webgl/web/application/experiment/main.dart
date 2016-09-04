import 'dart:html';
import 'package:webgl/src/application.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/mesh.dart';
import '000.dart' as exp000;
import '001.dart' as exp001;
import '002.dart' as exp002;
import '003.dart' as exp003;
import 'dart:async';
import 'package:webgl/src/scene.dart';

main() async {
  CanvasElement canvas = querySelector('#glCanvas');
  Application application = new Application(canvas);

  SceneView sceneView = new SceneView(application.viewAspectRatio);
  await sceneView.setupScene();

  application.render(sceneView);
}

class SceneView extends Scene {

  num viewAspectRatio;

  SceneView(this.viewAspectRatio):super();

  Future setupScene() async {
    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

    Mesh mesh = await exp003.experiment();
    materials.add(mesh.material);
    meshes.add(mesh);

    //Animation
    num _lastTime = 0.0;
    updateFunction = (num time) {
      double animationStep = time - _lastTime;
      //... custom animation here
      mesh.updateFunction(time);
      _lastTime = time;
    };
  }
}
