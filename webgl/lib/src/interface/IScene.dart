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

abstract class IEditElement{
  Map<String, EditableProperty> getPropertiesInfos(){
    Map<String, EditableProperty> propertiesInfos = {};

    InstanceMirror instance_mirror = reflect(this);
    var class_mirror = instance_mirror.type;

    Map<String, MethodMirror> instance_mirror_getters = new Map();
    Map<String, MethodMirror> instance_mirror_setters = new Map();
    Map<String, MethodMirror> instance_mirror_functions = new Map();

    for (var v in class_mirror.instanceMembers.values) {
      String name = MirrorSystem.getName(v.simpleName);

      if (v is VariableMirror) {
      } else if (v is MethodMirror && v.isGetter && !v.isPrivate) {
        instance_mirror_getters[name] = v;
      } else if (v is MethodMirror && v.isSetter && !v.isPrivate ) {
        instance_mirror_setters[name] = v;
      } else if (v is MethodMirror && v.isRegularMethod) {
        instance_mirror_functions[name] = v;
      }
    }

    instance_mirror_getters.forEach((String key, MethodMirror instance_mirror_field){
      if(instance_mirror_setters.containsKey('$key=')){
        Symbol fieldSymbol = instance_mirror_field.simpleName;
        propertiesInfos[key] = new EditableProperty(instance_mirror.getField(fieldSymbol).reflectee.runtimeType,() => instance_mirror.getField(fieldSymbol).reflectee, (v) => instance_mirror.setField(fieldSymbol, v).reflectee);
      }
    });

//    instance_mirror_functions.forEach((String key, MethodMirror instance_mirror_field) {
//      Symbol fieldSymbol = instance_mirror_field.simpleName;
//      propertiesInfos[key] = new EditableProperty(Function,() => instance_mirror.getField(fieldSymbol).reflectee, null);
//    });

    return propertiesInfos;
  }

  Map<String, EditableProperty> _properties;
  Map<String, EditableProperty> get properties {
    if(_properties == null){
      _properties = getPropertiesInfos();
    }
    return _properties;
  }

}