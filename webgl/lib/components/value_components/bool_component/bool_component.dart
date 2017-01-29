import 'package:angular2/core.dart';

@Component(
    selector: 'bool',
    templateUrl: 'bool_component.html',
    styleUrls: const ['bool_component.css'])
class BoolComponent{
  @Input()
  bool checked = false;

  @Output()
  EventEmitter valueChange = new EventEmitter<bool>();

  static void initDynamicComponent(BoolComponent component, defaultValue, Function callBack) {
    component
      ..checked = defaultValue is bool ? defaultValue : false
      ..valueChange.listen((d){
        if(callBack != null){
          callBack(d);
        }
      });
  }
}