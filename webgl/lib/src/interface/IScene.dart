import 'package:webgl/src/camera.dart';
import 'package:vector_math/vector_math.dart';

typedef void UpdateFunction(num time);
typedef void UpdateUserInput();

abstract class IUpdatableScene{
  Camera get mainCamera; //mainCamera.matrix.storage ==> projection Matrix
  Vector4 get backgroundColor;

  updateUserInput();
  update(time);
  render();
}

abstract class IUpdatableSceneFunction{
  UpdateUserInput updateUserInputFunction;
  UpdateFunction updateFunction;
}