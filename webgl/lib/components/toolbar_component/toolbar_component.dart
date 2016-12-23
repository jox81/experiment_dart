import 'package:angular2/core.dart';
import 'package:webgl/components/ui/toolbar_button/toolbar_button_component.dart';

@Component(
    selector: 'toolbar',
    templateUrl: 'toolbar_component.html',
    styleUrls: const ['toolbar_component.css'],
    directives: const [ToolbarButtonComponent])
class ToolbarComponent{
  void onToolbarButtonClicked(event){
    print('onToolbarButtonClicked');
  }
}
