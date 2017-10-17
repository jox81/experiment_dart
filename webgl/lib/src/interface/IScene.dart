import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/introspection.dart';

typedef void UpdateFunction();
typedef void UpdateUserInput();

abstract class IUpdatable{
}

abstract class IUpdatableScene implements IUpdatable{
  Vector4 backgroundColor;

  IEditElement currentSelection;

  void update();
  void updateUserInput();
  void updateScene();

  void render();

  Map toJson();

}

abstract class IUpdatableSceneFunction{
  UpdateUserInput updateUserInputFunction;
  UpdateFunction updateSceneFunction;
}

abstract class ISetupScene{
  void setup();
  void setupUserInput();
  void setupScene();
}
