import 'package:angular2/core.dart';
import 'package:webgl/scene_views/scene_view_base.dart';

@Component(
    selector: 'properties',
    templateUrl: 'properties_component.html',
    styleUrls: const ['properties_component.css'])
class PropertiesComponent{

  @Input()
  ISceneViewBase scene;

  bool get useLighting => scene != null ? scene.useLighting : false;
  set useLighting(bool value) => scene.useLighting = value;

}