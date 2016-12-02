import 'package:angular2/core.dart';
import 'package:vector_math/vector_math.dart';

@Component(
    selector: 'vector4',
    templateUrl: 'vector4_component.html',
    styleUrls: const ['vector4_component.css']
)
class Vector4Component {

  @Input()
  Vector4 vector;

  @Output()
  EventEmitter change = new EventEmitter<Vector4>();

  updateX(event){
    vector.setValues(double.parse(event.target.value), vector.y, vector.z, vector.w);
    change.emit(vector);
  }
  updateY(event){
    vector.setValues(vector.x, double.parse(event.target.value), vector.z, vector.w);
    change.emit(vector);
  }
  updateZ(event){
    vector.setValues(vector.x, vector.y, double.parse(event.target.value), vector.w);
    change.emit(vector);
  }
  updateW(event){
    vector.setValues(vector.x, vector.y, vector.z, double.parse(event.target.value));
    change.emit(vector);
  }

}