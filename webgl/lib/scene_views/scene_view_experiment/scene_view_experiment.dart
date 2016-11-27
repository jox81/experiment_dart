import 'package:webgl/src/animation_property.dart';
import 'package:webgl/src/application.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/meshes.dart';
import '000.dart' as exp000;
import '001.dart' as exp001;
import '002.dart' as exp002;
import '003.dart' as exp003;
import 'dart:async';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/interface/IScene.dart';
import 'package:webgl/src/interaction.dart';

class SceneViewExperiment extends Scene implements IEditScene{

  /// implements ISceneViewBase
  Map<String, EditableProperty> get properties =>{};

  SceneViewExperiment();

  @override
  UpdateFunction updateFunction;

  @override
  UpdateUserInput updateUserInputFunction;

  @override
  setupUserInput() {

    updateUserInputFunction = (){
      interaction.update();
    };

    updateUserInputFunction();

  }

  @override
  Future setupScene() async {

    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

    Model model = await exp003.experiment();
    materials.add(model.material);
    models.add(model);

    //Animation
    num _lastTime = 0.0;
    updateFunction = (num time) {
      double animationStep = time - _lastTime;
      //... custom animation here
      model.mesh.updateFunction(time);
      _lastTime = time;
    };
  }
}
