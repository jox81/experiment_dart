import 'dart:async';

import 'package:angular/angular.dart';

import 'package:angular_forms/angular_forms.dart' as forms;

@Component(
    selector: 'map',
    templateUrl: 'map_component.html',
    styleUrls: const ['map_component.css'],
    directives: const <dynamic>[COMMON_DIRECTIVES,
    forms.formDirectives]
)
class MapComponent {

  @Input()
  Map map;

  @Input()
  bool disabled = false;

  dynamic element;

  final _elementSelected = new StreamController<Map>.broadcast();

  @Output()
  Stream get elementSelected => _elementSelected.stream;

  void selectionChange(dynamic event){
    Map selection = map[(event.target.value.toString().split(': ')[1])] as Map;
    _elementSelected.add(selection);
  }

}