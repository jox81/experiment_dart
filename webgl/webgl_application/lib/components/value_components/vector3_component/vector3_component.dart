import 'dart:async';

import 'package:angular/angular.dart';
import 'package:vector_math/vector_math.dart';

@Component(
    selector: 'vector3',
    templateUrl: 'vector3_component.html',
    styleUrls: const ['vector3_component.css']
)
class Vector3Component {

  @Input()
  Vector3 value;

  final _valueChange = new StreamController<Vector3>.broadcast();

  @Output()
  Stream get valueChange => _valueChange.stream;

  void updateRow(int rowIndex, dynamic event){
    value[rowIndex] = double.tryParse(event.target.value as String) ?? 0.0;
    _valueChange.add(value);
  }

  static void initDynamicComponent(Vector3Component component, Vector3 defaultValue, Function callBack) {
    component
      ..value = defaultValue is Vector3 ? defaultValue : new Vector3.zero()
      ..valueChange.listen((dynamic d){
        if(callBack != null){
          callBack(d);
        }
      });
  }

}