import 'dart:async';

import 'package:angular/angular.dart';

@Component(
    selector: 'int',
    templateUrl: 'int_component.html',
    styleUrls: const ['int_component.css']
)
class IntComponent {

  @Input()
  int value;

  final _valueChange = new StreamController<int>.broadcast();

  @Output()
  Stream get valueChange => _valueChange.stream;

  void update(dynamic event){
    _valueChange.add(int.parse(event.target.value as String, onError:(s)=>0));
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