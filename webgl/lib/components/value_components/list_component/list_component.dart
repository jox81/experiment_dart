import 'package:angular2/core.dart';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/introspection.dart';

@Component(
    selector: 'list',
    templateUrl: 'list_component.html',
    styleUrls: const ['list_component.css']
)
class ListComponent {

  @Input()
  List list;

  dynamic element;

  @Output()
  EventEmitter elementSelected = new EventEmitter();

  void selectionChange(event){
    var selection = list[event.target.selectedIndex];
    elementSelected.emit(selection);
  }

}