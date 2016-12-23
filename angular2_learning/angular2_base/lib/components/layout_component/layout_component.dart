import 'package:angular2/core.dart';

@Component(
    selector: 'layout',
    templateUrl: 'layout_component.html',
    styleUrls: const ['layout_component.css']
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
    return {'vertical':_type =="vertical", 'horizontal':_type !="vertical"};
  }
}