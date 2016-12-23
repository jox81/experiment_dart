import 'package:angular2/core.dart';
import 'package:angular2_base/components/toolbar_button/toolbar_button_component.dart';
import 'package:angular2_base/components/toolbar_component/toolbar_component.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    styleUrls: const ['app_component.css'],
    directives: const[ToolbarComponent, ToolbarButtonComponent]
)
class AppComponent {
}