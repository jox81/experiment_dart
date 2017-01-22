import 'package:angular2/core.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/components/value_components/vector3_component/vector3_component.dart';

@Component(
    selector: 'matrix3',
    templateUrl: 'matrix3_component.html',
    styleUrls: const ['matrix3_component.css'],
    directives: const [Vector3Component]
)
class Matrix3Component {

  @Input()
  Matrix3 matrix;

  @Output()
  EventEmitter matrix3Change = new EventEmitter<Matrix4>();

  void updateRow(int rowIndex,event){
    matrix.setRow(rowIndex, event);
    matrix3Change.emit(matrix);
  }

}