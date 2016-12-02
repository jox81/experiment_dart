import 'package:angular2/core.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/components/vector3_component/vector3_component.dart';
import 'package:webgl/src/animation_property.dart';
import 'package:webgl/src/interface/IScene.dart';

@Component(
    selector: 'properties',
    templateUrl: 'properties_component.html',
    styleUrls: const ['properties_component.css'],
    directives: const [Vector3Component]
)
class PropertiesComponent{

  @Input()
  IEditElement iEditElement;

  //String
  bool isString(EditableProperty animationProperty){
    return animationProperty.getter() is String;
  }
  setStringValue(EditableProperty animationProperty, event){
    animationProperty.setter(event.target.value);
  }

  //bool
  bool isBool(EditableProperty animationProperty){
    return animationProperty.getter() is bool;
  }
  setBoolValue(EditableProperty animationProperty, event){
    animationProperty.setter(event.target.checked);
  }

  //int
  bool isInt(EditableProperty animationProperty){
    return animationProperty.getter() is int;
  }
  setIntValue(EditableProperty animationProperty, event){
    animationProperty.setter(int.parse(event.target.value));
  }

  //num
  bool isNum(EditableProperty animationProperty){
    return animationProperty.getter() is num;
  }
  setNumValue(EditableProperty animationProperty, event){
    animationProperty.setter(double.parse(event.target.value));
  }

  //Function
  bool isFunction(EditableProperty animationProperty){
    return animationProperty.getter() is Function;
  }

  //Custom components

  //Vector3
  bool isVector3(EditableProperty animationProperty){
    return animationProperty.getter() is Vector3;
  }
  setVector3Value(EditableProperty animationProperty, event){
    animationProperty.setter(event);
  }

}