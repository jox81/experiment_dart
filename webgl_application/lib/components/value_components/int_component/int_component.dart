import 'package:angular2/core.dart';

@Component(
    selector: 'int',
    templateUrl: 'int_component.html',
    styleUrls: const ['int_component.css']
)
class IntComponent {

  @Input()
  int value;

  @Output()
  EventEmitter valueChange = new EventEmitter<int>();

  void update(dynamic event){
    valueChange.emit(int.parse(event.target.value as String, onError:(s)=>0));
  }

  static void initDynamicComponent(IntComponent component, int defaultValue, Function callBack) {
    component
      ..value = defaultValue is int ? defaultValue : 0
      ..valueChange.listen((dynamic d){
        if(callBack != null){
          callBack(d);
        }
      });
  }
}