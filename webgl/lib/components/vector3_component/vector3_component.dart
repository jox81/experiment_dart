import 'package:angular2/core.dart';
import 'package:vector_math/vector_math.dart';

@Component(
    selector: 'vector3',
    templateUrl: 'vector3_component.html',
    styleUrls: const ['vector3_component.css']
)
class Vector3Component {

  @Input()
  Vector3 vec;

  @Output()
  EventEmitter change = new EventEmitter<Vector3>();

  updateX(event){
    vec.setValues(double.parse(event.target.value), vec.y, vec.z);
    change.emit(vec);
  }
  updateY(event){
    vec.setValues(vec.x, double.parse(event.target.value), vec.z);
    change.emit(vec);
  }
  updateZ(event){
    vec.setValues(vec.x, vec.y, double.parse(event.target.value));
    change.emit(vec);
  }
}