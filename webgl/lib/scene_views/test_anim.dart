import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/interface/IComponent.dart';
import 'package:webgl/src/geometry/object3d.dart';
import 'package:webgl/src/time/time.dart';

class TestAnim extends IComponent{
  TestAnim();

  @override
  update() {
    object3d.transform.rotateZ((radians(60.0) * Time.deltaTime) / 1000.0);
  }
}

