import 'dart:mirrors';
import 'package:webgl/src/animation_property.dart';
import 'package:webgl/src/camera.dart';
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

abstract class IEditElement{
  Map<String, EditableProperty> get properties;

  Map<String, EditableProperty> getPropertiesInfos(){
    Map<String, EditableProperty> propertiesInfos = {};

    InstanceMirror instance_mirror = reflect(this);
    var class_mirror = instance_mirror.type;

    Map<String, MethodMirror> getters = new Map();
    Map<String, MethodMirror> setters = new Map();

    print('### $class_mirror');
    for (var v in class_mirror.instanceMembers.values) {

      String name = MirrorSystem.getName(v.simpleName);

      if (v is VariableMirror) {
//        print("Variable: $name => info : ${v.type}, Static: ${v.isStatic}, Private: ${v.isPrivate}, Final: ${v.isFinal}, Const: ${v.isConst}");
      } else if (v is MethodMirror && v.isGetter ) {
//        print("Method: $name => isGetter : ${v.isGetter}, ${MirrorSystem.getName(v.returnType.simpleName)}, Static: ${v.isStatic}, Private: ${v.isPrivate}, Abstract: ${v.isAbstract}");
        getters[name] = v;
      } else if (v is MethodMirror && v.isSetter ) {
//        print("Method: $name => isSetter : ${v.isSetter}, ${MirrorSystem.getName(v.returnType.simpleName)}, Static: ${v.isStatic}, Private: ${v.isPrivate}, Abstract: ${v.isAbstract}");
        setters[name] = v;
      }

    }

    getters.forEach((String key, MethodMirror getter){
      if(setters.containsKey('$key=')){
        propertiesInfos[key] = new EditableProperty(() => class_mirror.invoke(MirrorSystem.getSymbol('$key'), []), (v) => class_mirror.invoke(MirrorSystem.getSymbol('$key'), [v]));
      }
    });

    return propertiesInfos;
  }

}