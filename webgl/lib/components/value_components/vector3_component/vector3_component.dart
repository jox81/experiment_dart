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
  EventEmitter valueChange = new EventEmitter<Vector3>();

  updateX(event){
    vector.setValues(double.parse(event.target.value), vector.y, vector.z);
    valueChange.emit(vector);
  }
  updateY(event){
    vector.setValues(vector.x, double.parse(event.target.value), vector.z);
    valueChange.emit(vector);
  }
  updateZ(event){
    vector.setValues(vector.x, vector.y, double.parse(event.target.value));
    valueChange.emit(vector);
  }
}