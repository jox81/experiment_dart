import 'package:angular2/core.dart';
import 'package:webgl/src/introspection.dart';

@Component(
    selector: 'function',
    templateUrl: 'function_component.html',
    styleUrls: const ['function_component.css']
)
class FunctionComponent {

  @Input()
  FunctionModel functionModel;

  @Input()
  bool disabled = false;

  String getReturnType(){
    Type returnType = functionModel.returnType;

    return returnType != null ? returnType.toString() : 'void';
  }
}