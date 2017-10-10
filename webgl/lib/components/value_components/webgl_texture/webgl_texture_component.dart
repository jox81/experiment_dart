import 'package:angular2/core.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

@Component(
    selector: 'webglTexture',
    templateUrl: 'webgl_texture_component.html',
    styleUrls: const ['webgl_texture_component.css']
)
class WebGLTextureComponent{

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