import 'package:angular2/core.dart';
import 'package:vector_math/vector_math.dart';

@Component(
    selector: 'vector4',
    templateUrl: 'vector4_component.html',
    styleUrls: const ['vector4_component.css']
)
class Vector4Component {

  @Input()
  Vector4 value;

  @Output()
  EventEmitter valueChange = new EventEmitter<Vector4>();

  void updateRow(int rowIndex, dynamic event){
    value[rowIndex] = double.parse(event.target.value as String, (s)=>0.0);
    valueChange.emit(value);
  }

}