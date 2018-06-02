import 'package:angular/angular.dart';
import 'package:webgl_application/components/ui/toolbar_button/toolbar_button_component.dart';
import 'package:webgl_application/src/ui_models/toolbar.dart';

@Component(
    selector: 'toolBar',
    pipes: const [commonPipes],
    templateUrl: 'toolbar_component.html',
    styleUrls: const ['toolbar_component.css'],
    directives: const <dynamic>[coreDirectives, ToolBarButtonComponent])
class ToolBarComponent{

  @Input()
  ToolBar toolBar;

  void onToolBarButtonClicked(String key, UpdateToolBarItem updateToolBarItem, dynamic event){
    bool checked = event.target.checked as bool;
//    print('onToolBarButtonClicked > $key: $checked');
    updateToolBarItem(checked);
  }
}
