import 'dart:async';

import 'package:angular/angular.dart';
import 'package:vector_math/vector_math.dart';

@Component(
    selector: 'vector4',
    templateUrl: 'vector4_component.html',
    styleUrls: const ['vector4_component.css']
)
class Vector4Component {

  @Input()
  Vector4 value;

  final _valueChange = new StreamController<Vector4>.broadcast();

  @Output()
  Stream get valueChange => _valueChange.stream;

  void updateRow(int rowIndex, dynamic event){
    value[rowIndex] = double.parse(event.target.value as String, (s)=>0.0);
    _valueChange.add(value);
  }

}