typedef void UpdateFunction();
typedef void UpdateUserInput();

abstract class IUpdatable{
}

abstract class IUpdatableScene implements IUpdatable{

//  dynamic currentSelection;

//  void update();
//  void updateUserInput();
//  void updateScene();
//
//  void render();
//
//  Map toJson();

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
