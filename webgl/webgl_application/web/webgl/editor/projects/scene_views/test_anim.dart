import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/interface/IComponent.dart';
import 'package:webgl/src/time/time.dart';

class TestAnim extends IComponent{
  TestAnim();

  @override
  update() {
    node.matrix.rotateZ((radians(60.0) * Time.deltaTime) / 1000.0);
  }
}

