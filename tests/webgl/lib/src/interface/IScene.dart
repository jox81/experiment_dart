import 'package:vector_math/vector_math.dart';
import 'dart:async';
import 'package:webgl/src/introspection.dart';

typedef void UpdateFunction(num time);
typedef void UpdateUserInput();

abstract class IUpdatable{

}
abstract class IUpdatableScene implements IUpdatable{
  Vector4 backgroundColor;

  IEditElement currentSelection;

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
