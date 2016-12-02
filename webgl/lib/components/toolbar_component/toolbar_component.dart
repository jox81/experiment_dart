import 'package:angular2/core.dart';

@Component(
    selector: 'toolbar',
    templateUrl: 'toolbar_component.html',
    styleUrls: const ['toolbar_component.css'])
class ToolbarComponent{

  @Output()
  EventEmitter onSwitchScene = new EventEmitter<bool>();

  onSelectNextScene(){
    onSwitchScene.emit(null);
  }

}