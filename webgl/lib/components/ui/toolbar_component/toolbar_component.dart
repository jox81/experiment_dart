import 'dart:html';

import 'package:angular2/core.dart';
import 'package:webgl/components/ui/toolbar_button/toolbar_button_component.dart';
import 'package:webgl/src/ui_models/toolbar.dart';

@Component(
    selector: 'toolBar',
    templateUrl: 'toolbar_component.html',
    styleUrls: const ['toolbar_component.css'],
    directives: const <dynamic>[ToolBarButtonComponent])
class ToolBarComponent{

  @Input()
  ToolBar toolBar;

  void onToolBarButtonClicked(String key, UpdateToolBarItem updateToolBarItem, dynamic event){
    bool checked = event.target.checked as bool;
//    print('onToolBarButtonClicked > $key: $checked');
    updateToolBarItem(checked);
  }
}
