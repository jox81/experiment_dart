import 'package:vector_math/vector_math.dart';
import 'dart:async';
import 'package:webgl/src/introspection.dart';

typedef void UpdateFunction();
typedef void UpdateUserInput();

abstract class IUpdatable{
}

abstract class IUpdatableScene implements IUpdatable{
  Vector4 backgroundColor;

  IEditElement currentSelection;

  update();
  updateUserInput();
  updateScene();

  render();

}

abstract class IUpdatableSceneFunction{
  UpdateUserInput updateUserInputFunction;
  UpdateFunction updateSceneFunction;
}

abstract class ISetupScene{
  setup();
  setupUserInput();
  Future setupScene();
}
