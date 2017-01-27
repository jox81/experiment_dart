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
  Matrix4 matrix;

  @Output()
  EventEmitter matrix4Change = new EventEmitter<Matrix4>();

  void updateRow(int rowIndex,event){
    matrix.setRow(rowIndex, event);
    matrix4Change.emit(matrix);
  }

  void setIdentity(){
    matrix.setIdentity();
    matrix4Change.emit(matrix);
  }

}