import 'package:angular/angular.dart';
import 'package:webgl_application/src/ui_models/toolbar.dart';
import 'package:angular_forms/angular_forms.dart' as forms;

@Component(
    selector: 'toolBarButton',
    templateUrl: 'toolbar_button_component.html',
    styleUrls: const ['toolbar_button_component.css'],
    directives: const <dynamic>[coreDirectives,
    forms.formDirectives])
class ToolBarButtonComponent{
  @Input()
  ToolBarItemsType toolBarItemsType;

  bool get isMulti => toolBarItemsType == ToolBarItemsType.multi;

  @Input()
  bool checked = false;

  @Input()
  String text = "";
}