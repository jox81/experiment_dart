import 'package:angular2/core.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

@Component(
    selector: 'webglEnum',
    templateUrl: 'webglenum_component.html',
    styleUrls: const ['webglenum_component.css']
)
class WebGLEnumComponent{

  @Input()
  List<WebGLEnum> webglEnums;

  @Input()
  WebGLEnum element;

  @Output()
  EventEmitter elementSelected = new EventEmitter();

  void selectionChange(event){
    var selection = webglEnums[event.target.selectedIndex];
    elementSelected.emit(selection);
  }
}