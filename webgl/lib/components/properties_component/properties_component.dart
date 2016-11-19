import 'package:angular2/core.dart';
import 'package:webgl/scene_views/scene_view_base.dart';
import 'package:webgl/src/animation_property.dart';

@Component(
    selector: 'properties',
    templateUrl: 'properties_component.html',
    styleUrls: const ['properties_component.css'])
class PropertiesComponent{

  @Input()
  IEditScene iEditScene;

  setStringValue(AnimationProperty animationProperty, event){
    animationProperty.setter(event.target.value);
  }

  setBoolValue(AnimationProperty animationProperty, event){
    animationProperty.setter(event.target.checked);
  }

  setIntValue(AnimationProperty animationProperty, event){
    animationProperty.setter(int.parse(event.target.value));
  }

  setNumValue(AnimationProperty animationProperty, event){
    animationProperty.setter(double.parse(event.target.value));
  }

}