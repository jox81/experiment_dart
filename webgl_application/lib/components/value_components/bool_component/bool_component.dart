import 'dart:async';

import 'package:angular/angular.dart';

import 'package:angular_forms/angular_forms.dart' as forms;

@Component(
    selector: 'bool',
    templateUrl: 'bool_component.html',
    styleUrls: const ['bool_component.css'],
    directives: const <dynamic>[COMMON_DIRECTIVES,
    forms.formDirectives]
)
class BoolComponent{
  @Input()
  bool checked = false;

  final _valueChange = new StreamController<bool>.broadcast();

  @Output()
  Stream get valueChange => _valueChange.stream;

  static void initDynamicComponent(BoolComponent component, bool defaultValue, Function callBack) {
    component
      ..checked = defaultValue is bool ? defaultValue : false
      ..valueChange.listen((dynamic d){
        if(callBack != null){
          callBack(d);
        }
      });
  }
}