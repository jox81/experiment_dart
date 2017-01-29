import 'package:angular2/core.dart';
import 'package:vector_math/vector_math.dart';

@Component(
    selector: 'vector3',
    templateUrl: 'vector3_component.html',
    styleUrls: const ['vector3_component.css']
)
class Vector3Component {

  @Input()
  Vector3 value;

  @Output()
  EventEmitter valueChange = new EventEmitter<Vector3>();

  updateRow(int rowIndex, event){
    value[rowIndex] = double.parse(event.target.value, (s)=>0.0);
    valueChange.emit(value);
  }

  static void initDynamicComponent(Vector3Component component, defaultValue, Function callBack) {
    component
      ..value = defaultValue is Vector3 ? defaultValue : new Vector3.zero()
      ..valueChange.listen((d){
        if(callBack != null){
          callBack(d);
        }
      });
  }

}