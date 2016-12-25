import 'package:angular2/core.dart';

@Component(
    selector: 'toolBarButton',
    templateUrl: 'toolbar_button_component.html',
    styleUrls: const ['toolbar_button_component.css'])
class ToolBarButtonComponent{

  @Input()
  bool checked = false;

  @Input()
  String text = "";
}