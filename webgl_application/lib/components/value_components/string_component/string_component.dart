import 'dart:async';

import 'package:angular/angular.dart';

@Component(
    selector: 'string',
    templateUrl: 'string_component.html',
    styleUrls: const ['string_component.css']
)
class StringComponent {

  @Input()
  String value;

  final _valueChange = new StreamController<String>.broadcast();

  @Output()
  Stream get valueChange => _valueChange.stream;

  void update(dynamic event){
    _valueChange.add(event.target.value as String);
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