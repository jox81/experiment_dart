import 'package:angular/angular.dart';

@Component(
    selector: 'layout',
    templateUrl: 'layout_component.html',
    styleUrls: const ['layout_component.css'],
    directives: const <dynamic>[COMMON_DIRECTIVES]
)
class LayoutComponent {

  String _type;
  String get type => _type;
  @Input('type')
  set type(String value) {
    _type = value;
    print(_type);
  }

  Map getOrientationType(){
    return <String, bool>{'vertical':_type =="vertical", 'horizontal':_type !="vertical"};
  }
}