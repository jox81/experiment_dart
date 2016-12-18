import 'package:angular2/core.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/components/ui/toggle_button/toggle_button_component.dart';
import 'package:webgl/components/value_components/list_component/list_component.dart';
import 'package:webgl/components/value_components/matrix4_component/matrix4_component.dart';
import 'package:webgl/components/value_components/vector2_component/vector2_component.dart';
import 'package:webgl/components/value_components/vector3_component/vector3_component.dart';
import 'package:webgl/components/value_components/vector4_component/vector4_component.dart';
import 'package:webgl/src/animation_property.dart';
import 'package:webgl/src/introspection.dart';

@Component(
    selector: 'properties',
    templateUrl: 'properties_component.html',
    styleUrls: const ['properties_component.css'],
    directives: const [Vector2Component, Vector3Component, Vector4Component, Matrix4Component, ListComponent, ToggleButtonComponent]
)
class PropertiesComponent{

  @Input()
  IEditElement iEditElement;

  @Output()
  EventEmitter innerSelectionChange = new EventEmitter<IEditElement>();

  //Null
  bool isNull(EditableProperty animationProperty){
    return animationProperty.type == Null;
  }

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
    return animationProperty.type == num || animationProperty.type == double;
  }
  setNumValue(EditableProperty animationProperty, event){
    animationProperty.setter(double.parse(event.target.value));
  }

  //Function
  bool isFunction(EditableProperty animationProperty){
    return animationProperty.type == Function;
  }

  //Custom components

  //Vector2
  bool isVector2(EditableProperty animationProperty){
    return animationProperty.type == Vector2;
  }
  setVector2Value(EditableProperty animationProperty, event){
    animationProperty.setter(event as Vector2);
  }
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
  //Matrix4
  bool isMatrix4(EditableProperty animationProperty){
    return animationProperty.type == Matrix4;
  }
  setMatrix4Value(EditableProperty animationProperty, event){
    animationProperty.setter(event as Matrix4);
  }
  //List
  bool isList(EditableProperty animationProperty){
    return animationProperty.type.toString() == 'List';
  }
  setSelection(event){
    IEditElement selection;
    if(event is IEditElement) {
      selection = event;
    }else{
      selection = new CustomEditElement(event);
    }
    innerSelectionChange.emit(selection);
  }

}