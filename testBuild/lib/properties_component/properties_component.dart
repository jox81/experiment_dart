import 'package:angular2/core.dart';
import 'package:testBuild/animation_property.dart';
import 'package:testBuild/introspection.dart';

@Component(
    selector: 'properties',
    templateUrl: 'properties_component.html',
    styleUrls: const ['properties_component.css'],
    directives: const []
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

}