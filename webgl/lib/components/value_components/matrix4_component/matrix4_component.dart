import 'package:angular2/core.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/components/value_components/vector4_component/vector4_component.dart';

@Component(
    selector: 'matrix4',
    templateUrl: 'matrix4_component.html',
    styleUrls: const ['matrix4_component.css'],
    directives: const [Vector4Component]
)
class Matrix4Component {

  @Input()
  Matrix4 value;

  @Output()
  EventEmitter valueChange = new EventEmitter<Matrix4>();

  void updateRow(int rowIndex,event){
    value.setRow(rowIndex, event);
    valueChange.emit(value);
  }

  void setIdentity(){
    value.setIdentity();
    valueChange.emit(value);
  }

}