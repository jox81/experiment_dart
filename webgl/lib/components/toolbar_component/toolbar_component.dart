import 'package:angular2/core.dart';
import 'package:webgl/components/ui/toggle_button/toggle_button_component.dart';
import 'package:webgl/components/ui/toolbar_button/toolbar_button_component.dart';

@Component(
    selector: 'toolbar',
    templateUrl: 'toolbar_component.html',
    styleUrls: const ['toolbar_component.css'],
    directives: const [ToolbarButtonComponent])
class ToolbarComponent{

  @Output()
  EventEmitter onSwitchScene = new EventEmitter<bool>();

  @Output()
  EventEmitter axisXChange = new EventEmitter<bool>();

  onSelectNextScene(){
    onSwitchScene.emit(null);
  }

  onAxisXChange(event){
    axisXChange.emit(event.target.checked);
  }

}