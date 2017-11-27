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

  void updateRow(int rowIndex, dynamic event){
    value[rowIndex] = double.parse(event.target.value as String, (s)=>0.0);
    valueChange.emit(value);
  }

  static void initDynamicComponent(Vector3Component component, Vector3 defaultValue, Function callBack) {
    component
      ..value = defaultValue is Vector3 ? defaultValue : new Vector3.zero()
      ..valueChange.listen((dynamic d){
        if(callBack != null){
          callBack(d);
        }
      });
  }

}