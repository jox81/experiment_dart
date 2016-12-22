import 'package:angular2/core.dart';

@Component(
    selector: 'toolbarButton',
    templateUrl: 'toolbar_button_component.html',
    styleUrls: const ['toolbar_button_component.css'])
class ToolbarButtonComponent{
  @Input()
  bool checked = false;
}