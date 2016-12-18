import 'dart:html';
import 'package:angular2/core.dart';

//Suivant l'exemple : http://www.w3schools.com/howto/tryit.asp?filename=tryhow_css_dropdown_navbar_click

@Component(
    selector: 'menuBase',
    templateUrl: 'menu_component.html',
    styleUrls: const ['menu_component.css'])
class MenuComponent{

  bool headerId1Visible = false;

  headerClick(String headerId){
    print(headerId1Visible);
    headerId1Visible = !headerId1Visible;
  }
}