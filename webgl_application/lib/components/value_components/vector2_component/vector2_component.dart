import 'dart:async';

import 'package:angular/angular.dart';
import 'package:vector_math/vector_math.dart';

@Component(
    selector: 'vector2',
    templateUrl: 'vector2_component.html',
    styleUrls: const ['vector2_component.css']
)
class Vector2Component {

  @Input()
  Vector2 value;

  final _valueChange = new StreamController<Vector2>.broadcast();

  @Output()
  Stream get valueChange => _valueChange.stream;

  void updateRow(int rowIndex, dynamic event){
    value[rowIndex] = double.tryParse(event.target.value.toString())??0.0;
    _valueChange.add(value);
  }

  static void initDynamicComponent(Vector2Component component, Vector2 defaultValue, Function callBack) {
    component
      ..value = defaultValue is Vector2 ? defaultValue : new Vector2.zero()
      ..valueChange.listen((dynamic d){
        if(callBack != null){
          callBack(d);
        }
      });
  }
}