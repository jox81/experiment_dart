import 'dart:async';

import 'package:angular/angular.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl_application/components/value_components/vector3_component/vector3_component.dart';

@Component(
    selector: 'matrix3',
    templateUrl: 'matrix3_component.html',
    styleUrls: const ['matrix3_component.css'],
    directives: const <dynamic>[Vector3Component]
)
class Matrix3Component {

  @Input()
  Matrix3 value;

  final _valueChange = new StreamController<Matrix3>.broadcast();

  @Output()
  Stream get valueChange => _valueChange.stream;

  void updateRow(int rowIndex,Vector3 event){
    value.setRow(rowIndex, event);
    _valueChange.add(value);
  }

}