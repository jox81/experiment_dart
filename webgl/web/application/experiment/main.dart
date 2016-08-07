import 'dart:html';
import 'package:webgl/src/application.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/mesh.dart';
import '000.dart' as exp000;
import '001.dart' as exp001;
import '002.dart' as exp002;
import '003.dart' as exp003;

Application application;

main() {
  CanvasElement canvas = querySelector('#glCanvas');

  //Application
  application = new Application(canvas);
  application.setupScene(setupScene);
  application.renderAnimation();
}

setupScene() async {
  application.backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

  Mesh mesh = await exp003.experiment(Application.gl);
  application.materials.add(mesh.material);
  application.meshes.add(mesh);

  //Animation
  num _lastTime = 0.0;
  application.updateScene((num time) {
    // rotate
    double animationStep = time - _lastTime;
    //... custom animation here
    mesh.animation(time);
    _lastTime = time;
  });
}
