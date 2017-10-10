import 'package:angular2/core.dart';

@Component(
    selector: 'num',
    templateUrl: 'num_component.html',
    styleUrls: const ['num_component.css']
)
class NumComponent {

  @Input()
  num value;

  @Output()
  EventEmitter valueChange = new EventEmitter<num>();

  void update(dynamic event){
    valueChange.emit(double.parse(event.target.value as String, (s)=>0.0));
  }

  static void initDynamicComponent(NumComponent component, num defaultValue, Function callBack) {
    component
      ..value = defaultValue is num ? defaultValue : 0.0
      ..valueChange.listen((dynamic d){
        if(callBack != null){
          callBack(d);
        }
      });
  }
}