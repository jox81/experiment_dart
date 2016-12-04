import 'package:angular2/core.dart';
import 'package:vector_math/vector_math.dart';

@Component(
    selector: 'vector2',
    templateUrl: 'vector2_component.html',
    styleUrls: const ['vector2_component.css']
)
class Vector2Component {

  @Input()
  Vector2 vector;

  @Output()
  EventEmitter vector2Change = new EventEmitter<Vector3>();

  updateRow(int rowIndex, event){
    vector[rowIndex] = double.parse(event.target.value);
    vector2Change.emit(vector);
  }

}