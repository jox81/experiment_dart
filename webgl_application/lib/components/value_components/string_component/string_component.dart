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

  void update(dynamic event){
    valueChange.emit(event.target.value);
  }

  static void initDynamicComponent(StringComponent component, String defaultValue, Function callBack) {
    component
      ..value = defaultValue is String ? defaultValue : ''
      ..valueChange.listen((dynamic d){
        if(callBack != null){
          callBack(d);
        }
      });
  }
}