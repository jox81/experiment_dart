import 'dart:async';

import 'package:angular/angular.dart';

import 'package:angular_forms/angular_forms.dart' as forms;

@Component(
    selector: 'list',
    templateUrl: 'list_component.html',
    styleUrls: const ['list_component.css'],
    directives: const <dynamic>[COMMON_DIRECTIVES,
    forms.formDirectives]
)
class ListComponent {

  @Input()
  List list;

  @Input()
  bool disabled = false;

  dynamic element;

  final _elementSelected = new StreamController<dynamic>.broadcast();

  @Output()
  Stream get elementSelected => _elementSelected.stream;

  void selectionChange(dynamic event){
    dynamic selection = list[event.target.selectedIndex as int];
    _elementSelected.add(selection);
  }

}