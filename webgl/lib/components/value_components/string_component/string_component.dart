import 'package:angular2/core.dart';

@Component(
    selector: 'string',
    templateUrl: 'string_component.html',
    styleUrls: const ['string_component.css']
)
class StringComponent {

  @Input()
  String value;

  @Output()
  EventEmitter valueChange = new EventEmitter<String>();

  update(event){
    valueChange.emit(event.target.value);
  }

  static void initDynamicComponent(StringComponent component, defaultValue, Function callBack) {
    component
      ..value = defaultValue is String ? defaultValue : ''
      ..valueChange.listen((d){
        if(callBack != null){
          callBack(d);
        }
      });
  }
}