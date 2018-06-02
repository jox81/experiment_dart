import 'dart:async';

import 'package:angular/angular.dart';

@Component(
    selector: 'num',
    templateUrl: 'num_component.html',
    styleUrls: const ['num_component.css']
)
class NumComponent {

  @Input()
  num value;

  final _valueChange = new StreamController<num>.broadcast();

  @Output()
  Stream get valueChange => _valueChange.stream;

  void update(dynamic event){
    _valueChange.add(double.tryParse(event.target.value as String) ?? 0.0);
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