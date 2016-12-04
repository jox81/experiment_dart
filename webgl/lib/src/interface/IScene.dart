import 'dart:mirrors';
import 'package:webgl/src/animation_property.dart';
import 'package:vector_math/vector_math.dart';
import 'dart:async';

typedef void UpdateFunction(num time);
typedef void UpdateUserInput();

abstract class IUpdatable{

}
abstract class IUpdatableScene implements IUpdatable{
  Vector4 get backgroundColor;

  updateUserInput();
  update(time);
  render();
}

abstract class IUpdatableSceneFunction{
  UpdateUserInput updateUserInputFunction;
  UpdateFunction updateFunction;
}

abstract class ISetupScene{
  setupUserInput();
  Future setupScene();
}
