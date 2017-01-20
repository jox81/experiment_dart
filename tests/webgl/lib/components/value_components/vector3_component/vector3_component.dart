import 'package:angular2/core.dart';
import 'package:vector_math/vector_math.dart';

@Component(
    selector: 'vector3',
    templateUrl: 'vector3_component.html',
    styleUrls: const ['vector3_component.css']
)
class Vector3Component {

  @Input()
  Vector3 vector;

  @Output()
  EventEmitter vector3Change = new EventEmitter<Vector3>();

  updateRow(int rowIndex, event){
    vector[rowIndex] = double.parse(event.target.value);
    vector3Change.emit(vector);
  }

}