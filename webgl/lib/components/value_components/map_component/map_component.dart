import 'package:angular2/core.dart';

@Component(
    selector: 'map',
    templateUrl: 'map_component.html',
    styleUrls: const ['map_component.css']
)
class MapComponent {

  @Input()
  Map map;

  @Input()
  bool disabled = false;

  dynamic element;

  @Output()
  EventEmitter elementSelected = new EventEmitter<Map>();

  void selectionChange(dynamic event){
    Map selection = map[(event.target.value.toString().split(': ')[1])] as Map;
    elementSelected.emit(selection);
  }

}