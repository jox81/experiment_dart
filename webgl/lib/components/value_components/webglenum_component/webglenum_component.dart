import 'package:angular2/core.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum_wrapped.dart';

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
  EventEmitter elementSelected = new EventEmitter<Object>();

  void selectionChange(dynamic event){
    var selection = webglEnums[event.target.selectedIndex as int];
    elementSelected.emit(selection);
  }
}