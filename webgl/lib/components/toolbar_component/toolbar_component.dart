import 'dart:async';
import 'package:angular2/core.dart';
import 'package:webgl/scene_views/scene_view_base.dart';
import 'package:webgl/src/application.dart';
import 'package:webgl/src/scene.dart';

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