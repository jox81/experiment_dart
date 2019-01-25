import 'dart:async';

import 'package:angular/angular.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl_application/components/value_components/vector4_component/vector4_component.dart';

@Component(
    selector: 'matrix4',
    templateUrl: 'matrix4_component.html',
    styleUrls: const ['matrix4_component.css'],
    directives: const <dynamic>[Vector4Component]
)
class Matrix4Component {

  @Input()
  Matrix4 value;

  final _valueChange = new StreamController<Matrix4>.broadcast();

  @Output()
  Stream get valueChange => _valueChange.stream;

  void updateRow(int rowIndex,Vector4 event){
    value.setRow(rowIndex, event);
    _valueChange.add(value);
  }

  void setIdentity(){
    value.setIdentity();
    _valueChange.add(value);
  }

}