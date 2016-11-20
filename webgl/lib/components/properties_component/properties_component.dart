import 'package:angular2/core.dart';
import 'package:webgl/src/animation_property.dart';
import 'package:webgl/src/interface/IScene.dart';

@Component(
    selector: 'properties',
    templateUrl: 'properties_component.html',
    styleUrls: const ['properties_component.css'])
class PropertiesComponent{

  @Input()
  IEditScene iEditScene;

  //String
  bool isString(AnimationProperty animationProperty){
    return animationProperty.getter() is String;
  }
  setStringValue(AnimationProperty animationProperty, event){
    animationProperty.setter(event.target.value);
  }

  //bool
  bool isBool(AnimationProperty animationProperty){
    return animationProperty.getter() is bool;
  }
  setBoolValue(AnimationProperty animationProperty, event){
    animationProperty.setter(event.target.checked);
  }

  //int
  bool isInt(AnimationProperty animationProperty){
    return animationProperty.getter() is int;
  }
  setIntValue(AnimationProperty animationProperty, event){
    animationProperty.setter(int.parse(event.target.value));
  }

  //num
  bool isNum(AnimationProperty animationProperty){
    return animationProperty.getter() is num;
  }
  setNumValue(AnimationProperty animationProperty, event){
    animationProperty.setter(double.parse(event.target.value));
  }

  //Function
  bool isFunction(AnimationProperty animationProperty){
    return animationProperty.getter() is Function;
  }

}