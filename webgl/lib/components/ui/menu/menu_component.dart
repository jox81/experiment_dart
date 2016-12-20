import 'package:angular2/core.dart';
import 'package:webgl/directives/clickoutside_directive.dart';

// Suivant l'exemple :
// http://www.w3schools.com/howto/tryit.asp?filename=tryhow_css_dropdown_navbar_click

@Component(
    selector: 'menuBase',
    templateUrl: 'menu_component.html',
    styleUrls: const ['menu_component.css'],
    directives: const [ClickOutsideDirective])
class MenuComponent{

  bool headerId1Visible = false;

  headerClick(String headerId){
    headerId1Visible = !headerId1Visible;
    print('toggle menu $headerId : visible = $headerId1Visible');
  }

  void close(String headerId){
    print('closing menu $headerId');
    headerId1Visible = false;
  }
}