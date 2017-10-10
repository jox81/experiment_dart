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
  EventEmitter elementSelected = new EventEmitter<dynamic >();

  void selectionChange(dynamic event){
    dynamic selection = list[event.target.selectedIndex as int];
    elementSelected.emit(selection);
  }

}