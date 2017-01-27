import 'package:vector_math/vector_math.dart';
import '000.dart' as exp000;
import '001.dart' as exp001;
import '002.dart' as exp002;
import '003.dart' as exp003;
import 'dart:async';
import 'package:webgl/src/models.dart';
import 'package:webgl/src/scene.dart';
@MirrorsUsed(
    targets: const [
      SceneViewExperiment,
    ],
    override: '*')
import 'dart:mirrors';

class SceneViewExperiment extends Scene{

  SceneViewExperiment();

  @override
  Future setupScene() async {

    backgroundColor = new Vector4(0.2, 0.2, 0.2, 1.0);

    Model model = await exp003.experiment();
    materials.add(model.material);
    models.add(model);

    //Animation
//    num _lastTime = 0.0;
    updateFunction = (num time) {
      model.updateFunction(time);
//      _lastTime = time;
    };
  }
}
