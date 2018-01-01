import 'package:angular2/core.dart';
import 'package:webgl_application/src/ui_models/toolbar.dart';

@Component(
    selector: 'toolBarButton',
    templateUrl: 'toolbar_button_component.html',
    styleUrls: const ['toolbar_button_component.css'])
class ToolBarButtonComponent{
  @Input()
  ToolBarItemsType toolBarItemsType = ToolBarItemsType.multi;

  @Input()
  bool checked = false;

  @Input()
  String text = "";
}