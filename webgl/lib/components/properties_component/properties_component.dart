import 'dart:html';
import 'dart:mirrors';
import 'package:angular2/core.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/components/ui/toggle_button/toggle_button_component.dart';
import 'package:webgl/components/value_components/list_component/list_component.dart';
import 'package:webgl/components/value_components/matrix3_component/matrix3_component.dart';
import 'package:webgl/components/value_components/matrix4_component/matrix4_component.dart';
import 'package:webgl/components/value_components/vector2_component/vector2_component.dart';
import 'package:webgl/components/value_components/vector3_component/vector3_component.dart';
import 'package:webgl/components/value_components/vector4_component/vector4_component.dart';
import 'package:webgl/components/value_components/webglenum_component/webglenum_component.dart';
import 'package:webgl/src/animation_property.dart';
import 'package:webgl/src/introspection.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

@Component(
    selector: 'properties',
    templateUrl: 'properties_component.html',
    styleUrls: const ['properties_component.css'],
    directives: const [Vector2Component, Vector3Component, Vector4Component, Matrix3Component, Matrix4Component, ListComponent, ToggleButtonComponent, WebGLEnumComponent]
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
    bool result = compareType(animationProperty.type, String);
    if(result){
      print('');
    }
    return result;
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
  //Matrix3
  bool isMatrix3(EditableProperty animationProperty){
    return animationProperty.type == Matrix3;
  }
  setMatrix3Value(EditableProperty animationProperty, event){
    animationProperty.setter(event as Matrix3);
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

  //isWebGLEnum
  bool isWebGLEnum(EditableProperty animationProperty){
    return compareType(animationProperty.type, WebGLEnum);
  }
  setWebGLEnumSelection(EditableProperty animationProperty, event){
    animationProperty.setter(event);
  }
  List<WebGLEnum> getWebglEnumItems(Type type) {
    return WebGLEnum.getItems(type);
  }

  /// Return true if type is the same or if it's a subType
  bool compareType(Type elementType, Type compareType){
    ClassMirror elementTypeMirror = reflectClass(elementType);
    ClassMirror compareTypeMirror = reflectClass(compareType);
    return elementTypeMirror.isSubtypeOf(compareTypeMirror);
  }
}