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
  EventEmitter vector4Change = new EventEmitter<Vector4>();

  updateRow(int rowIndex, event){
    vector[rowIndex] = double.parse(event.target.value);
    vector4Change.emit(vector);
  }

}