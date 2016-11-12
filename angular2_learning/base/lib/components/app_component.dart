import 'package:angular2/core.dart';
import 'package:angular2_base/components/layout_component/layout_component.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    styleUrls: const ['app_component.css'],
    directives: const[LayoutComponent]
)
class AppComponent {
  String title = 'Base application';
}