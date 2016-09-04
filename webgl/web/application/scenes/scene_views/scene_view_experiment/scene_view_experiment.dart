import 'package:webgl/src/application.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/mesh.dart';
import '000.dart' as exp000;
import '001.dart' as exp001;
import '002.dart' as exp002;
import '003.dart' as exp003;
import 'dart:async';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/interface/IScene.dart';
import 'package:webgl/src/interaction.dart';

class SceneViewExperiment extends Scene {

  num viewAspectRatio;

  SceneViewExperiment(this.viewAspectRatio):super();

  @override
  UpdateFunction updateFunction;

  @override
  UpdateUserInput updateUserInputFunction;

  setupUserInput() {

    Interaction interaction = new Interaction(scene);

    //UserInput
    updateUserInputFunction = (){
      interaction.update();
    };

    updateUserInputFunction();

  }

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
