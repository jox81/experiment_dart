import 'package:angular2/core.dart';

@Component(
    selector: 'list',
    templateUrl: 'list_component.html',
    styleUrls: const ['list_component.css']
)
class ListComponent {

  @Input()
  List list;

  @Input()
  bool disabled = false;

  dynamic element;

  @Output()
  EventEmitter elementSelected = new EventEmitter<List>();

  void selectionChange(event){
    var selection = list[event.target.selectedIndex];
    elementSelected.emit(selection);
  }

}