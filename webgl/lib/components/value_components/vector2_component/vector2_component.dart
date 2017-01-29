import 'package:angular2/core.dart';
import 'package:vector_math/vector_math.dart';

@Component(
    selector: 'vector2',
    templateUrl: 'vector2_component.html',
    styleUrls: const ['vector2_component.css']
)
class Vector2Component {

  @Input()
  Vector2 value;

  @Output()
  EventEmitter valueChange = new EventEmitter<Vector2>();

  updateRow(int rowIndex, event){
    value[rowIndex] = double.parse(event.target.value, (s)=>0.0);
    valueChange.emit(value);
  }

  static void initDynamicComponent(Vector2Component component, defaultValue, Function callBack) {
    component
      ..value = defaultValue is Vector2 ? defaultValue : new Vector2.zero()
      ..valueChange.listen((d){
        if(callBack != null){
          callBack(d);
        }
      });
  }
}