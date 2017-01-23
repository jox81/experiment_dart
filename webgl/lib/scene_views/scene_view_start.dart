import 'dart:async';
import 'package:webgl/src/scene.dart';
import 'package:webgl/src/models.dart';
@MirrorsUsed(
    targets: const [
      SceneViewStart,
    ],
    override: '*')
import 'dart:mirrors';

///Just an empty scene
class SceneViewStart extends Scene{

  SceneViewStart();

  @override
  Future setupScene() {

    //create Pyramide
    PyramidModel pyramid = new PyramidModel()
      ..transform.translate(3.0, 1.0, 0.0);
    models.add(pyramid);

    return new Future.value();
  }
}
