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
  EventEmitter change = new EventEmitter<Vector3>();

  updateX(event){
    vector.setValues(double.parse(event.target.value), vector.y, vector.z);
    change.emit(vector);
  }
  updateY(event){
    vector.setValues(vector.x, double.parse(event.target.value), vector.z);
    change.emit(vector);
  }
  updateZ(event){
    vector.setValues(vector.x, vector.y, double.parse(event.target.value));
    change.emit(vector);
  }
}