import 'package:angular2/core.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/components/value_components/vector3_component/vector3_component.dart';
import 'package:webgl/components/value_components/vector4_component/vector4_component.dart';
import 'package:webgl/src/animation_property.dart';
import 'package:webgl/src/interface/IScene.dart';

@Component(
    selector: 'properties',
    templateUrl: 'properties_component.html',
    styleUrls: const ['properties_component.css'],
    directives: const [Vector3Component, Vector4Component]
)
class PropertiesComponent{

  @Input()
  IEditElement iEditElement;

  //String
  bool isString(EditableProperty animationProperty){
    return animationProperty.type == String;
  }
  setStringValue(EditableProperty animationProperty, event){
    animationProperty.setter(event.target.value);
  }

  //bool
  bool isBool(EditableProperty animationProperty){
    return animationProperty.type == bool;
  }
  setBoolValue(EditableProperty animationProperty, event){
    animationProperty.setter(event.target.checked);
  }

  //int
  bool isInt(EditableProperty animationProperty){
    return animationProperty.type == int;
  }
  setIntValue(EditableProperty animationProperty, event){
    animationProperty.setter(int.parse(event.target.value));
  }

  //num
  bool isNum(EditableProperty animationProperty){
    return animationProperty.type == num;
  }
  setNumValue(EditableProperty animationProperty, event){
    animationProperty.setter(double.parse(event.target.value));
  }

  //Function
  bool isFunction(EditableProperty animationProperty){
    return animationProperty.type == Function;
  }

  //Custom components

  //Vector3
  bool isVector3(EditableProperty animationProperty){
    return animationProperty.type == Vector3;
  }
  setVector3Value(EditableProperty animationProperty, event){
    animationProperty.setter(event as Vector3);
  }
  //Vector4
  bool isVector4(EditableProperty animationProperty){
    return animationProperty.type == Vector4;
  }
  setVector4Value(EditableProperty animationProperty, event){
    animationProperty.setter(event as Vector4);
  }

}